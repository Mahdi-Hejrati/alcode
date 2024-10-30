<%! 
import filters.python as filters
%>
% for fd in root.federates.values(): 
{
    "service": "rabbitmq",
    "login": "${fd.login}",
    "passw": "${fd.passw}",
    "token": "${fd.token|str}",
    "host": "${fd.host|str}",
    "port": "${fd.port|str}",
    "connectionType": "${fd.connectionType}"
}
ALMAS-FILE-INFO
rabbitmq/python/${fd.name|filters.cap}/config.json
ALMAS-FILE-SEPRATE
% endfor