<%! 
import filters.csharp as filters
%>
% for fd in root.federates.values(): 
/*
<%include file="/header.makot" args="root=root"/>
*/
using System;
using System.Collections.Generic;
using System.Text.Json;

% if fd.desc1.strip():
///     <summary>
///     ${fd.desc1}
///     </summary>
% endif
% if fd.desc2.strip():
///     <summary>
///     ${fd.desc2,'///   '| filters.indent}
///     </summary>
% endif

public class ${fd.name|filters.cap}_Controller_Base : Connection_Almas
{
    public ${fd.name|filters.cap}_Controller_Base(Dictionary<string, string> config) : base(config)
    {
        % for tp in fd.items:
        this.Do${tp.dir.capitalize()}("${tp.topic.name}");
        % endfor
    }

    % for tp in fd.items:
    % if tp.desc1.strip():
///     <summary>   
///     ${tp.dir}-${tp.desc1}
///     </summary>    
    % endif
    % if tp.desc2.strip():
///     <summary>   
///     ${tp.desc2,'///    '| filters.indent}
///     </summary>    
    % endif
    % if root.topics[tp.topic_id].desc1.strip() or root.topics[tp.topic_id].desc2.strip():
    // ---------------------
    % endif
    % if root.topics[tp.topic_id].desc1.strip():
    /// ${root.topics[tp.topic_id].desc1,'///    '| filters.indent}
    % endif
    % if root.topics[tp.topic_id].desc2.strip():
    /// ${root.topics[tp.topic_id].desc2,'///    '| filters.indent}
    % endif

    % if tp.dir == 'subscribe':
    public virtual void On_${tp.topic.name}(${tp.topic.start_type.name|filters.cap} value)
    {
        // Handle received data
    }
    % endif
    % if tp.dir == 'publish':
    public void Send_${tp.topic.name}(${tp.topic.start_type.name|filters.cap} value)
    {
        var body = JsonSerializer.Serialize(value);
        this.Publish(topic: "${tp.topic.name}", serialized: body);
    }
    % endif

    % endfor

    public override void Receive(string topic, string value)
    {
        <% 
        sublist = [i for i in fd.items if i.dir == 'subscribe'] 
        %>
        % if sublist:
        % for tp in sublist:
        ${'else ' if not loop.first else ''}if (topic == "${tp.topic.name}")
        {
            var data = JsonSerializer.Deserialize<${tp.topic.start_type.name|filters.cap}>(value);
            On_${tp.topic.name}(data);
        }
        % endfor
        else
        {
            Console.WriteLine("Subscribe not found!");
        }
        % else:
        // No subscription topics available
        % endif
    }
}

ALMAS-FILE-INFO
rabbitmq/csharp/${fd.name|filters.cap}/Core/${fd.name|filters.cap}_Controller_Base.cs
ALMAS-FILE-SEPRATE
% endfor

