<%! 
import filters.csharp as filters
%>
% for fd in root.federates.values(): 
/*
<%include file="/header.makot" args="root=root"/>
*/
using System.Collections.Specialized;
using System.Runtime.CompilerServices;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.Json.Serialization;

% if fd.desc1.strip():
/// <summery>
/// ${fd.desc1}
/// </summery>
% endif
% if fd.desc2.strip():
/// <remarks>
/// ${fd.desc2,'/// '| filters.indent}
/// </remarks>
% endif

public class ${fd.name|filters.cap}_Controller: Connection_Almas {

    public ${fd.name|filters.cap}() {
        % for tp in fd.items:
        this.do_${tp.dir}('${tp.topic.name}');
        % endfor
    }

    % for tp in fd.items:
    % if tp.desc1.strip():
    /// <summery>
    /// ${tp.dir}-${tp.desc1}
    /// </summery>
    % endif
    % if tp.desc2.strip():
    /// <remarks>
    /// ${tp.desc2,'    /// '| filters.indent}
    /// </remarks>
    % endif
    % if root.topics[tp.topic_id].desc1.strip() or root.topics[tp.topic_id].desc2.strip():
    /// ---------------------
    % endif
    % if root.topics[tp.topic_id].desc1.strip():
    /// ${root.topics[tp.topic_id].desc1,'    /// '| filters.indent}
    % endif
    % if root.topics[tp.topic_id].desc2.strip():
    /// ${root.topics[tp.topic_id].desc2,'    /// '| filters.indent}
    % endif
    
    % if tp.dir == 'subscribe':
    public abstract void on_${tp.topic.name}(${tp.topic.end_type.name | filters.type} value);
    %endif
    % if tp.dir == 'publish':
    public void send_${tp.topic.name}(${tp.topic.start_type.name | filters.type} value) 
    {

    }
    %endif

    % endfor
}

ALMAS-FILE-INFO
almas/csharp/${fd.name|filters.cap}/Core/${fd.name|filters.cap}_Controller.cs
ALMAS-FILE-SEPRATE
% endfor
