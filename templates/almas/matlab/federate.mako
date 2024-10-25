<%! 
import filters.matlab as filters
%>
% for fd in root.federates.values(): 
/*
<%include file="/header.makot" args="root=root"/>
*/

% if fd.desc1.strip():
%% <summery>
%% ${fd.desc1}
%% </summery>
% endif
% if fd.desc2.strip():
%% <remarks>
%% ${fd.desc2,'% '| filters.indent}
%% </remarks>
% endif

classdef ${fd.name|filters.cap}_Controller < Connection_Almas {

    methods
        function obj = ${fd.name|filters.cap}()
            % for tp in fd.items:
            obj.do_${tp.dir}('${tp.topic.name}');
            % endfor
        end
    end

    % for tp in fd.items:
    % if tp.desc1.strip():
    %% ${tp.dir}-${tp.desc1}
    % endif
    % if tp.desc2.strip():
    %% ${tp.desc2,'    % '| filters.indent}
    % endif
    % if root.topics[tp.topic_id].desc1.strip() or root.topics[tp.topic_id].desc2.strip():
    %% ---------------------
    % endif
    % if root.topics[tp.topic_id].desc1.strip():
    %% ${root.topics[tp.topic_id].desc1,'    % '| filters.indent}
    % endif
    % if root.topics[tp.topic_id].desc2.strip():
    %% ${root.topics[tp.topic_id].desc2,'    % '| filters.indent}
    % endif
    
    % if tp.dir == 'subscribe':
    methods(Abstract, Static)
        result = on_${tp.topic.name}
    end
    %endif
    % if tp.dir == 'publish':
    methods
        function ret = send_${tp.topic.name}(obj, value)
            
        end
    end
    %endif

    % endfor
end

ALMAS-FILE-INFO
almas/matlab/${fd.name|filters.cap}/Core/${fd.name|filters.cap}_Controller.m
ALMAS-FILE-SEPRATE
% endfor
