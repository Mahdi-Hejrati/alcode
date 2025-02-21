<%! 
import filters.cpp as filters
%>

% for fd in root.federates.values():

/*
<%include file="/header.makot" args="root=root"/>
*/

% for dt in root.datatypes.values():
#include "${dt.name|filters.cap}.hpp"
% endfor

ALMAS-FILE-INFO
alt/cpp/${fd.name|filters.cap}/src/DataType/DataType_includes.hpp
ALMAS-FILE-SEPRATE
% endfor
