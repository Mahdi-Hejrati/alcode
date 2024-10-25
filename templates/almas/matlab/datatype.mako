<%! 
import filters.csharp as filters
%>
% for dt in root.datatypes.values():
/*
<%include file="/header.makot" args="root=root"/>
*/

% if dt.desc1.strip():
%% ${dt.desc1}
% endif
% if dt.desc2.strip():
%% ${dt.desc2,'% '| filters.indent}
% endif

classdef ${dt.name|filters.cap}
    properties
        storage = struct();
    end
    properties (Dependent)
        % for di in dt.items:
        ${di.name};
        % endfor
    end

    methods ( Access = 'public' )
        function obj = ${dt.name|filters.cap}()
            obj.storage = struct();
            % for di in dt.items:
            obj.storage.${di.name} = ${di.di_type.name | filters.defval};
            % endfor
        end
    
%%        function obj = ${dt.name|filters.cap} (
          % for di in dt.items:
%%            _${di.name}${',' if not loop.last else ''}
          % endfor
%%        )
%%        obj.storage = struct();
          % for di in dt.items:
%%        obj.storage.${di.name} = _${di.name}${'.serialize()' if di.di_type_id > 0 else ''};
          % endfor
%%        end
    end

    methods ( Access = 'public' )

        % for di in dt.items:
        % if di.desc1.strip():
        %% ${di.desc1}
        % endif
        % if di.desc2.strip():
        %% ${di.desc2,'        % '| filters.indent}
        % endif
        function ret = get.${di.name} (obj)
            ret = obj.storage.${di.name};
        end
        function obj = set.${di.name} (obj, val)
            obj.storage.${di.name} = val;
        end

    % endfor

    end
    methods ( Access = 'public' )
        function ret = serialize(obj)
            ret = obj.storage;
        end    
    end
end

% for fd in root.federates.values(): 
ALMAS-FILE-INFO
almas/matlab/${fd.name|filters.cap}/DataType/${dt.name|filters.cap}.m
% endfor
ALMAS-FILE-SEPRATE
% endfor
