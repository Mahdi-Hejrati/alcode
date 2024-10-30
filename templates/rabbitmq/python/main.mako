<%! 
import filters.python as filters
%>
% for fd in root.federates.values(): 
"""
<%include file="/header.makot" args="root=root"/>
"""

import json
from pathlib import Path

from ${fd.name|filters.cap}_Controller_Sample import ${fd.name|filters.cap}_Controller
% for i in [i.name for i in root.datatypes.values()]:
from DataType.${i|filters.cap} import ${i|filters.cap}
% endfor

config = json.loads(Path('./config.json').read_text())

cc = ${fd.name|filters.cap}_Controller(config)

cc.start()

while(True):
    print("--------------------------------------------------")
    print("Publishing Data. Please Select Publishing")
    <% 
    sublist = [i for i in fd.items if i.dir == 'publish'] 
    %>
    % for tp in sublist:
    print("[${loop.index|str}] - ${tp.topic.name} : ${tp.desc1} ")
    %endfor
    p = input("Your Select? ")
    % for tp in sublist:
    ${'el' if not loop.first else ''}if p == '${loop.index|str}':
        d = ${tp.topic.start_type.name|filters.cap}()
        print(f">>>>> publish {d} On ${tp.topic.name}")
        cc.send_${tp.topic.name}(d)
    % endfor
    else:
        print("not found!.")

ALMAS-FILE-INFO
rabbitmq/python/${fd.name|filters.cap}/main.py
ALMAS-FILE-SEPRATE
% endfor
