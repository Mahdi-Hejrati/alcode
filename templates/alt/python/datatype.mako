## DatatType has Serialize methos 
## return of Serialize is a dictionary for protocol class
## UnSerialize will do with constructor that accept a dict
<%! 
import filters.python as filters
%>
% for dt in root.datatypes.values():
"""
<%include file="/header.makot" args="root=root"/>
"""

<%
imports = [i.di_type.name for i in dt.items if i.di_type_id > 0]
%>

% for i in imports:
from .${i|filters.cap} import ${i|filters.cap}
% endfor

class ${dt.name|filters.cap}:
% if dt.desc1.strip() or dt.desc2.strip():
    """
    ${dt.desc1}
    ${dt.desc2,'    '| filters.indent}
    """
    % endif

    storage = {}

    def __init__(self, content: dict = {}):
        % for di in dt.items:
        self.${di.name} = content.get('${di.name}', ${di.di_type.name | filters.defval})
        % endfor

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
        % if di.di_type_id > 0:
        if isinstance(value, dict):
            value = ${di.di_type.name | filters.type}(value)
        % endif 
        self.storage['${di.name}'] = value

    % endfor

    def Serialize(self):
        ret = {}
        % for di in dt.items:
        % if di.di_type_id > 0:
        if isinstance(self.${di.name}, ${di.di_type.name | filters.type}):
            ret['${di.name}'] = self.${di.name}.Serialize()
        % else:
        ret['${di.name}'] = self.${di.name}
        % endif    
        % endfor
        return ret

    def __str__(self):
        return str(self.Serialize())

% for fd in root.federates.values(): 
ALMAS-FILE-INFO
alt/python/${fd.name|filters.cap}/DataType/${dt.name|filters.cap}.py
% endfor
ALMAS-FILE-SEPRATE
% endfor