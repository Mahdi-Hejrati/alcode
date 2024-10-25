<%! 
import filters.python as filters
%>
% for fd in root.federates.values(): 
"""
<%include file="/header.makot" args="root=root"/>
"""
from Core.protocol import Connection_Almas

import json
import DataType

% if fd.desc1.strip():
# ${fd.desc1}
% endif
% if fd.desc2.strip():
# ${fd.desc2,'# '| filters.indent}
% endif

class ${fd.name|filters.cap}_Controller_Base(Connection_Almas):

    def __init__(self):
        super().__init__()
        % for tp in fd.items:
        self.do_${tp.dir}('${tp.topic.name}')
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
    def on_${tp.topic.name}(self, value: DataType.${tp.topic.start_type.name|filters.cap}):
        pass
    %endif
    % if tp.dir == 'publish':
    def send_${tp.topic.name}(self, value: DataType.${tp.topic.start_type.name|filters.cap}):
        body = json.dumps(value.Serialize())
        self.publish(topic='${tp.topic.name}', Serialized=body)
    %endif

    % endfor

    def recievie(self, topic, value):
        <% 
        sublist = [i for i in fd.items if i.dir == 'subscribe'] 
        %>
        % if sublist:
        % for tp in sublist:
        ${'el' if not loop.first else ''}if topic == '${tp.topic.name}':
            self.on_${tp.topic.name}(DataType.${tp.topic.start_type.name|filters.cap}(**value))
        % endfor
        else:
            print("Subscribe not found!.")
        % else:
            pass
        % endif

ALMAS-FILE-INFO
almas/python/${fd.name|filters.cap}/Core/${fd.name|filters.cap}_Controller.py
ALMAS-FILE-SEPRATE
% endfor
