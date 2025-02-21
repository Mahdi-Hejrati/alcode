<%! 
import filters.python as filters
%>
% for fd in root.federates.values(): 
"""
<%include file="/header.makot" args="root=root"/>
"""

import time
import ctypes
from sys import platform
import json
% for i in [i.name for i in root.datatypes.values()]:
from DataType.${i|filters.cap} import ${i|filters.cap}
% endfor

% if fd.desc1.strip():
# ${fd.desc1}
% endif
% if fd.desc2.strip():
# ${fd.desc2,'# '| filters.indent}
% endif

class ${fd.name|filters.cap}_Controller_Base:

    def __init__(self, config):
        self.config = config

        libraryname = f"./almas-{self.config['service']}.{'dll' if platform == 'win32' else 'so'}"

        self.Connection = ctypes.CDLL(libraryname)
        self.Connection.init.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.c_char_p, ctypes.c_char_p]
        self.Connection.init.restype = ctypes.c_int
        self.Connection.publish.argtypes = [ctypes.c_char_p, ctypes.c_char_p]
        self.Connection.publish.restype = ctypes.c_int
        self.Connection.register_subscribe.argtypes = [ctypes.c_char_p, ctypes.c_void_p]
        self.Connection.register_subscribe.restype = ctypes.c_int
        self.Connection.register_publish.argtypes = [ctypes.c_char_p, ctypes.c_void_p]
        self.Connection.register_publish.restype = ctypes.c_int
        if platform == "win32":
            self.CALLBACKFUNC = ctypes.WINFUNCTYPE(ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p)
        else:
            self.CALLBACKFUNC = ctypes.CFUNCTYPE(ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p)
        self.Connection.start.argtypes = [self.CALLBACKFUNC]
        self.Connection.start.restype = ctypes.c_int

        self.Connection.init(
            self.config['host'].encode('utf-8'), 
            int(self.config['port']), 
            self.config['login'].encode('utf-8'), 
            self.config['passw'].encode('utf-8')
        )

        % for tp in fd.items:
        self.Connection.register_${tp.dir}('${tp.topic.name}'.encode('utf-8'), None)
        % endfor
    
    % for tp in fd.items:
    % if tp.desc1.strip():
    # ${tp.dir}-${tp.desc1}
    % endif
    % if tp.desc2.strip():
    # ${tp.desc2,'    # '| filters.indent}
    % endif
    % if root.topics[tp.topic_id].desc1.strip() or root.topics[tp.topic_id].desc2.strip():
    # ---------------------
    % endif
    % if root.topics[tp.topic_id].desc1.strip():
    # ${root.topics[tp.topic_id].desc1,'    # '| filters.indent}
    % endif
    % if root.topics[tp.topic_id].desc2.strip():
    # ${root.topics[tp.topic_id].desc2,'    # '| filters.indent}
    % endif
    
    % if tp.dir == 'subscribe':
    def on_${tp.topic.name}(self, value: ${tp.topic.start_type.name|filters.cap}):
        pass
    %endif
    % if tp.dir == 'publish':
    def send_${tp.topic.name}(self, value: ${tp.topic.start_type.name|filters.cap}):
        body = json.dumps(value.Serialize())
        self.Connection.publish("${tp.topic.name}".encode('utf-8'), body.encode('utf-8'))
    %endif

    % endfor

    def start(self):
        self.receiveFinal = self.CALLBACKFUNC(self.receive)
        self.Connection.start(self.receiveFinal)

    def receive(self, topic, body, meta):
        topic = ctypes.cast(topic, ctypes.c_char_p).value
        body  = ctypes.cast(body, ctypes.c_char_p).value
        meta  = ctypes.cast(meta, ctypes.c_char_p).value
        topic = topic.decode('utf-8') if topic != None else ''
        body = body.decode('utf-8') if body != None else ''
        meta = meta.decode('utf-8') if meta != None else ''
        <% 
        sublist = [i for i in fd.items if i.dir == 'subscribe'] 
        %>
        % if sublist:
        % for tp in sublist:
        ${'el' if not loop.first else ''}if topic == '${tp.topic.name}':
            self.on_${tp.topic.name}(${tp.topic.start_type.name|filters.cap}(json.loads(body)))
        % endfor
        else:
            print("Subscribe not found!.", topic.decode('utf-8'), body, meta)
        % else:
            pass
        % endif

ALMAS-FILE-INFO
alt/python/${fd.name|filters.cap}/Core/${fd.name|filters.cap}_Controller_Base.py
ALMAS-FILE-SEPRATE
% endfor
