<%! 
import filters.cpp as filters
%>
% for fd in root.federates.values():

/*
<%include file="/header.makot" args="root=root"/>
*/

#include <iostream>
#include <fstream>
#include <string>
#include <unordered_map>
#include <sstream>
#include "json.hpp"

// Include data types
% for i in [i.name for i in root.datatypes.values()]:
#include "DataType/${i|filters.cap}.hpp"
% endfor

// Include the federate controller
#include "${fd.name|filters.cap}_Controller_Sample.cpp"

${fd.name|filters.cap}_Controller* ${fd.name|filters.cap}_c = nullptr;

void receive_callback(char* topic, char* jsonBody, char* jsonMeta) {
    //std::string topic_str = std::string(topic);
    //std::cout << "*****************" << topic << std::endl;

    if(${fd.name|filters.cap}_c) ${fd.name|filters.cap}_c->receive(topic, jsonBody, jsonMeta);
}

int main()
{
    std::ifstream configFile("./config.json");
    if(!configFile.is_open())
    {
        std::cerr << "Failed to open config.json\n";
        return 1;
    }
    nlohmann::json jConfig;
    try {
        configFile >> jConfig; // parse JSON
    } catch(const std::exception &ex) {
        std::cerr << "Error parsing config.json: " << ex.what() << "\n";
        return 1;
    }
    configFile.close();

    std::unordered_map<std::string, std::string> config;
    for (auto it = jConfig.begin(); it != jConfig.end(); ++it) {
        config[it.key()] = it.value(); 
    }

    ${fd.name|filters.cap}_c = new ${fd.name|filters.cap}_Controller(config);
    ${fd.name|filters.cap}_c->start((void*)receive_callback); // Adjust if your C++ version uses a different method signature

    // 5) Publish loop
    while(true)
    {
        std::cout << "--------------------------------------------------\n";
        std::cout << "Publishing Data. Please Select Publishing\n";

        <% 
        # Gather only the topics that are "publish"
        sublist = [i for i in fd.items if i.dir == 'publish'] 
        %>

        // Show menu of publishable topics
        % for tp in sublist:
        std::cout << "[" << ${loop.index|str} << "] - ${tp.topic.name} : ${tp.desc1} \n";
        % endfor

        std::cout << "Your Select? ";
        std::string p;
        if(!std::getline(std::cin, p)) {
            // If user input fails (EOF, ctrl+D, etc.), break
            break;
        }

        bool found = false;
        % for tp in sublist:
        if(!found && p == "${loop.index|str}") {
            // 6) Construct a default object for this topic's data type
            ${tp.topic.start_type.name|filters.cap} d;

            // Debug print—assuming your data type has something like toString():
            std::cout << ">>>> publish " << d.toString() 
                      << " on ${tp.topic.name}\n";

            // Actually send
            ${fd.name|filters.cap}_c->send_${tp.topic.name}(d);
            found = true;
        }
        % endfor

        if(!found) {
            std::cout << "not found!.\n";
        }
    }

    return 0;
}

ALMAS-FILE-INFO
alt/cpp/${fd.name|filters.cap}/src/main.cpp
ALMAS-FILE-SEPRATE

% endfor
