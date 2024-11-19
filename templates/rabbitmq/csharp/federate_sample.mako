<%! 
import filters.csharp as filters
%>
% for fd in root.federates.values(): 
/*
WARNING: Copy content of this file to ${fd.name|filters.cap}_Controller.cs
and edit that one.
If you edit this file, your changes will be lost.

<%include file="/header.makot" args="root=root"/>
*/

using System.Collections.Generic;
using System;

public class ${fd.name|filters.cap}_Controller : ${fd.name|filters.cap}_Controller_Base
{
    public ${fd.name|filters.cap}_Controller(Dictionary<string, string> config) : base(config) { }

    % for tp in fd.items:
    % if tp.dir == 'subscribe':
    // Redefine method below to receive data on topic ${tp.topic.name}
    public override void On_${tp.topic.name}(${tp.topic.start_type.name|filters.cap} value)
    {
        Console.WriteLine("Received on ${tp.topic.name}: value {0}",value);
        // Implement additional processing logic here if needed
    }
    % endif
    % if tp.dir == 'publish':
    // Use the method Send_${tp.topic.name} to publish data on topic ${tp.topic.name}
    % endif

    % endfor
}

ALMAS-FILE-INFO
rabbitmq/csharp/${fd.name|filters.cap}/${fd.name|filters.cap}_Controller_Sample.cs
ALMAS-FILE-SEPRATE
% endfor

