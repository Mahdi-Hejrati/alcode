<%! 
import filters.csharp as filters
%>
% for dt in root.datatypes.values():
/*
<%include file="/header.makot" args="root=root"/>
*/
using System.Collections.Specialized;
using System.Runtime.CompilerServices;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.Json.Serialization;

% if dt.desc1.strip():
/// <summery>
/// ${dt.desc1}
/// </summery>
% endif
% if dt.desc2.strip():
/// <remarks>
/// ${dt.desc2,'/// '| filters.indent}
/// </remarks>
% endif

public class ${dt.name|filters.cap}: IAlmas_Serialize {
    private Dictionary<string, object> storage = new Dictionary<string, object>();

    public ${dt.name|filters.cap}() {
        % for di in dt.items:
        storage['${di.name}'] = ${di.di_type.name | filters.defval};
        % endfor
    }

    public ${dt.name|filters.cap}(
        % for di in dt.items:
        ${di.di_type.name | filters.type} _${di.name}${',' if not loop.last else ''}
        % endfor
    ) 
    {
        % for di in dt.items:
        storage['${di.name}'] = _${di.name};
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
    /// ${di.desc2,'    /// '| filters.indent}
    /// </remarks>
    % endif
    public ${di.di_type.name | filters.type} ${di.name} 
    { 
        get { return (${di.di_type.name | filters.type})storage['${di.name}']; }
        set { storage['${di.name}'] = value; }
    }

    % endfor

    public override Dictionary<string, object> Serialize() {
        return this.storage;
    }
}
% for fd in root.federates.values(): 
ALMAS-FILE-INFO
almas/csharp/${fd.name|filters.cap}/DataType/${dt.name|filters.cap}.cs
% endfor
ALMAS-FILE-SEPRATE
% endfor
