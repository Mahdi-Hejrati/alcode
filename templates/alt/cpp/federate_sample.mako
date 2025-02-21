<%!
import filters.cpp as filters
%>
% for fd in root.federates.values():

/*
<%include file="/header.makot" args="root=root"/>
*/

#include <iostream>
#include <string>

// Include the base class header
#include "Core/${fd.name|filters.cap}_Controller_Base.cpp"
// Include your data types if needed
//#include "DataType/DataType_includes.hpp"  // or each type individually

class ${fd.name|filters.cap}_Controller : public ${fd.name|filters.cap}_Controller_Base
{
public:
    explicit ${fd.name|filters.cap}_Controller(const std::unordered_map<std::string, std::string>& config)
        : ${fd.name|filters.cap}_Controller_Base(config)
    {
    }

    % for tp in fd.items:
    % if tp.dir == 'subscribe':
    // redefine method below to receive data on topic "${tp.topic.name}"
    virtual void on_${tp.topic.name}(const ${tp.topic.start_type.name|filters.cap}& value) override
    {
        // C++ equivalent:
        std::cout << "Receive on ${tp.topic.name}: value " << value.toString() << std::endl;
    }
    % endif

    % if tp.dir == 'publish':
    // for sending data on topic "${tp.topic.name}", use this function:
    // void send_${tp.topic.name}(const ${tp.topic.start_type.name|filters.cap}& value)
    // {
    //     // Implementation
    // }
    % endif
    % endfor
};

// The rest of your code may want to instantiate and use this class.

ALMAS-FILE-INFO
alt/cpp/${fd.name|filters.cap}/src/${fd.name|filters.cap}_Controller_Sample.cpp
ALMAS-FILE-SEPRATE

% endfor
