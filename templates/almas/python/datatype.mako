<%! 
import filters.python as filters
%>
% for dt in root.datatypes.values():
"""
<%include file="/header.makot" args="root=root"/>
"""

import json

% if dt.desc1.strip():
# ${dt.desc1}
% endif
% if dt.desc2.strip():
# ${dt.desc2,'# '| filters.indent}
% endif

class ${dt.name|filters.cap}:
    storage = {}

    def __init__(self,
        % for di in dt.items:
        ${di.name} = ${di.di_type.name | filters.defval}${',' if not loop.last else ''}
        % endfor
    ):
        % for di in dt.items:
        self.storage['${di.name}'] = ${di.name}
        % endfor

    @classmethod
    def Deserialize(cls, data):
        return cls(**(json.loads(data))))


    % for di in dt.items:
    % if di.desc1.strip():
    # ${di.desc1}
    % endif
    % if di.desc2.strip():
    # ${di.desc2,'    # '| filters.indent}
    % endif
    @property
    def ${di.name}(self):
        return self.storage['${di.name}']
    
    @${di.name}.setter
    def ${di.name}(self, value):
        self.storage['${di.name}'] = value

    % endfor

    def Serialize(self):
        return json.dumps(self.storage)


% for fd in root.federates.values(): 
ALMAS-FILE-INFO
almas/python/${fd.name|filters.cap}/DataType/${dt.name|filters.cap}.py
% endfor
ALMAS-FILE-SEPRATE
% endfor
