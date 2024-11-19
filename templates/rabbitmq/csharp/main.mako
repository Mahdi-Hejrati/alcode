<%! 
import filters.csharp as filters
%>
% for fd in root.federates.values(): 
/*
<%include file="/header.makot" args="root=root"/>
*/

using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;

class Program
{
    static void Main()
    {
        // Load configuration from JSON
        var configJson = File.ReadAllText("./config.json");
        var config = JsonSerializer.Deserialize<Dictionary<string, string>>(configJson);

        var cc = new ${fd.name|filters.cap}_Controller(config);

        cc.Start();

        while (true)
        {
            Console.WriteLine("--------------------------------------------------");
            Console.WriteLine("Publishing Data. Please Select Publishing");
            <% 
            sublist = [i for i in fd.items if i.dir == 'publish'] 
            %>
            % for tp in sublist:
            Console.WriteLine("[${loop.index|str}] - ${tp.topic.name} : ${tp.desc1}");
            % endfor

            Console.Write("Your Select? ");
            var p = Console.ReadLine();

            % for tp in sublist:
            ${'else ' if not loop.first else ''}if (p == "${loop.index|str}")
            {
                var data = new ${tp.topic.start_type.name|filters.cap}();
                Console.WriteLine(">>>>> publish {0} On ${tp.topic.name}",data);
                cc.Send_${tp.topic.name}(data);
            }
            % endfor
            else
            {
                Console.WriteLine("Selection not found!");
            }
        }
    }
}

ALMAS-FILE-INFO
rabbitmq/csharp/${fd.name|filters.cap}/Program.cs
ALMAS-FILE-SEPRATE
% endfor

