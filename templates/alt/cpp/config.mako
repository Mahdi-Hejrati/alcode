<%! 
import filters.cpp as filters
%>
% for fd in root.federates.values(): 
{
    "service": "alt",
    "login": "${fd.login}",
    "passw": "${fd.passw}",
    "token": "${fd.token|str}",
    "host": "${fd.host|str}",
    "port": "${fd.port|str}",
    "connectionType": "${fd.connectionType}"
}
ALMAS-FILE-INFO
alt/cpp/${fd.name|filters.cap}/build/config.json
ALMAS-FILE-SEPRATE
% endfor