<%! 
import filters.csharp as filters
%>
% for dt in root.datatypes.values():
/*
<%include file="/header.makot" args="root=root"/>
*/

<%
imports = [i.di_type.name for i in dt.items if i.di_type_id > 0]
%>

using System.Collections.Generic;

public class ${dt.name|filters.cap} {

    % if dt.desc1.strip() or dt.desc2.strip():

///     <summary>
///     ${dt.desc1}
///     ${dt.desc2, '///    '|filters.indent}
///     </summary>
    
    % endif

    private Dictionary<string, object> storage = new Dictionary<string, object>();

    public ${dt.name|filters.cap}() {
        % for di in dt.items:
        storage["${di.name}"] = ${di.di_type.name | filters.defval};
        % endfor
    }

    public ${dt.name|filters.cap}(
        % for di in dt.items:
        ${di.di_type.name | filters.type} _${di.name}${',' if not loop.last else ''}
        % endfor
    ) 
    {
        % for di in dt.items:
        storage["${di.name}"] = _${di.name};
        % endfor
    }

    % for di in dt.items:
    % if di.desc1.strip():
    /// <summery>
    /// ${di.desc1}
    /// </summery>
    % endif
    % if di.desc2.strip():
    /// <remarks>
    /// ${di.desc2,'///    '| filters.indent}
    /// </remarks>
    % endif
    public ${di.di_type.name | filters.type} ${di.name} 
    { 
        get { return (${di.di_type.name | filters.type})storage["${di.name}"]; }
        set { storage["${di.name}"] = value; }
    }

    % endfor

    public Dictionary<string, object> Serialize() {
        return this.storage;
    }

    public override string ToString()
    {
        string toString = "{"; 
        foreach (string key in storage.Keys)
        {
            toString += " \'" + key + "\' : \'" + storage[key] + "\',";
        }

        toString += " }";
        return toString;
    }
}

% for fd in root.federates.values(): 
ALMAS-FILE-INFO
rabbitmq/csharp/${fd.name|filters.cap}/DataType/${dt.name|filters.cap}.cs
% endfor
ALMAS-FILE-SEPRATE
% endfor

