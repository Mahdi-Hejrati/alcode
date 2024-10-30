<%! 
import filters.python as filters
%>
% for fd in root.federates.values(): 
"""
WARNING: Copy Content of this file to ${fd.name|filters.cap}_Controller.py
and edit that one
if you edit this file your changes will lost

<%include file="/header.makot" args="root=root"/>
"""

from Core.${fd.name|filters.cap}_Controller_Base import ${fd.name|filters.cap}_Controller_Base
import json
import DataType

class ${fd.name|filters.cap}_Controller(${fd.name|filters.cap}_Controller_Base):

    def __init__(self, config):
        super().__init__(config)
    
    % for tp in fd.items:
    % if tp.dir == 'subscribe':
    # redefine def below to recievive Data on topic ${tp.topic.name}
    def on_${tp.topic.name}(self, value: DataType.${tp.topic.start_type.name|filters.cap}):
        print(f"recievive on ${tp.topic.name}: value {value}")
        pass
    %endif
    % if tp.dir == 'publish':
    # for send data on topic ${tp.topic.name} use this function
    # send_${tp.topic.name}
    %endif

    % endfor

ALMAS-FILE-INFO
rabbitmq/python/${fd.name|filters.cap}/${fd.name|filters.cap}_Controller_Sample.py
ALMAS-FILE-SEPRATE
% endfor
