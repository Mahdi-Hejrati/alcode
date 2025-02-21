<%! 
import filters.cpp as filters
%>
% for fd in root.federates.values():

/*
<%include file="/header.makot" args="root=root"/>
*/

#include "../json.hpp"
#include <string>
#include <iostream>
#include <unordered_map>

% for i in [i.name for i in root.datatypes.values()]:
#include "../DataType/${i|filters.cap}.hpp"
% endfor

#include <dlfcn.h>

//typedef void* (*__callback)(void* topic, void* jsonBody, void* jsonMeta);

using json = nlohmann::json;

class Connection {
public:
    Connection(std::string service) {
        // Determine the platform and set the library name
#ifdef _WIN32
        std::string extension = "dll";
#else
        std::string extension = "so";
#endif
        libraryName = "./almas-" + service + "." + extension;
        handle = nullptr;
    }

    ~Connection() {
        if (handle) {
            dlclose(handle); // Close the library if it was opened
        }
    }

    bool load() {
        handle = dlopen(libraryName.c_str(), RTLD_LAZY);
        if (!handle) {
            std::cerr << "Cannot open library: " << dlerror() << '\n';
            return false;
        }

        // Cache function pointers
        initFunc = (init_t)dlsym(handle, "init");
        registerSubscribeFunc = (register_subscribe_t)dlsym(handle, "register_subscribe");
        registerPublishFunc = (register_publish_t)dlsym(handle, "register_publish");
        publishFunc = (publish_t)dlsym(handle, "publish");
        startFunc = (start_t)dlsym(handle, "start");
        stopFunc = (stop_t)dlsym(handle, "stop");
        finalizeFunc = (finalize_t)dlsym(handle, "finalize");

        // Check for errors in loading function pointers
        if (!initFunc || !registerSubscribeFunc || !registerPublishFunc ||
            !publishFunc || !startFunc || !stopFunc || !finalizeFunc) {
            std::cerr << "Error loading functions: " << dlerror() << '\n';
            return false;
        }

        return true;
    }

    // Function to initialize the library
    int init(char* address, int port, char* username, char* password) {
        return initFunc(address, port, username, password);
    }

    // Function to register a subscription
    int register_subscribe(char* topic, char* jsonConfig) {
        return registerSubscribeFunc(topic, jsonConfig);
    }

    // Function to register a publication
    int register_publish(char* topic, char* jsonConfig) {
        return registerPublishFunc(topic, jsonConfig);
    }

    // Function to publish a message
    int publish(char* topic, char* jsonString) {
        return publishFunc(topic, jsonString);
    }

    // Function to start the library
    int start(void* callbackFunction) {
        return startFunc(callbackFunction);
    }

    // Function to stop the library
    int stop() {
        return stopFunc();
    }

    // Function to finalize the library
    int finalize() {
        return finalizeFunc();
    }

private:
    // Function pointer types
    typedef int (*init_t)(char*, int, char*, char*);
    typedef int (*register_subscribe_t)(char*, char*);
    typedef int (*register_publish_t)(char*, char*);
    typedef int (*publish_t)(char*, char*);
    typedef int (*start_t)(void*);
    typedef int (*stop_t)();
    typedef int (*finalize_t)();

    std::string libraryName;
    void* handle;

    // Cached function pointers
    init_t initFunc;
    register_subscribe_t registerSubscribeFunc;
    register_publish_t registerPublishFunc;
    publish_t publishFunc;
    start_t startFunc;
    stop_t stopFunc;
    finalize_t finalizeFunc;
};


% if fd.desc1.strip() or fd.desc2.strip():
/*
% if fd.desc1.strip():
${fd.desc1}
% endif
% if fd.desc2.strip():
${fd.desc2,'    '| filters.indent}
% endif
*/
% endif

class ${fd.name|filters.cap}_Controller_Base
{
public:

    // Constructor
    explicit ${fd.name|filters.cap}_Controller_Base(const std::unordered_map<std::string, std::string>& config)
        : connection(config.at("service"))
    {
        connection.load();

        connection.init(
            const_cast<char*>(config.at("host").c_str()),
            std::stoi(config.at("port")),
            const_cast<char*>(config.at("login").c_str()),
            const_cast<char*>(config.at("passw").c_str())
        );

        % for tp in fd.items:
        connection.register_${tp.dir}(const_cast<char*>("${tp.topic.name}"), nullptr);
        % endfor
    }

    % for tp in fd.items:
    % if tp.desc1.strip() or tp.desc2.strip():
    // ------------------------------------------------
    // ${tp.dir}-${tp.desc1}
    % if tp.desc2.strip():
    // ${tp.desc2,'    // '| filters.indent}
    % endif
    % if root.topics[tp.topic_id].desc1.strip() or root.topics[tp.topic_id].desc2.strip():
    // ---------------------
    % if root.topics[tp.topic_id].desc1.strip():
    // ${root.topics[tp.topic_id].desc1,'    // '| filters.indent}
    % endif
    % if root.topics[tp.topic_id].desc2.strip():
    // ${root.topics[tp.topic_id].desc2,'    // '| filters.indent}
    % endif
    % endif
    % endif

    % if tp.dir == 'subscribe':
    // Called when data arrives on topic "${tp.topic.name}"
    virtual void on_${tp.topic.name}(const ${tp.topic.start_type.name|filters.cap}& value)
    {
        // pass
    }
    % endif

    % if tp.dir == 'publish':
    // Publishes data on topic "${tp.topic.name}"
    void send_${tp.topic.name}(const ${tp.topic.start_type.name|filters.cap}& value)
    {
        auto data = value.Serialize();
        json j(data);
        std::string body = j.dump();
        connection.publish(const_cast<char*>("${tp.topic.name}"), const_cast<char*>(body.c_str()));
    }
    % endif
    % endfor

    void receive(char* topic, char* jsonBody, char* jsonMeta)
    {
        std::string topic_str = std::string(topic);
        std::string jsonBody_str = std::string(jsonBody);

        <% sublist = [i for i in fd.items if i.dir == 'subscribe'] %>
        % if sublist:
        % for tp in sublist:
        ${'else ' if not loop.first else ''}if(topic_str == "${tp.topic.name}") {
            json j = json::parse(jsonBody_str);
            ${tp.topic.start_type.name|filters.cap} obj(j);
            on_${tp.topic.name}(obj);
        }
        % endfor
        else {
            std::cout << "Subscribe not found!." << topic << jsonBody << jsonMeta << std::endl;
        }
        % else:
            // no subscribe
        % endif
    }

    void start(void* receive_callback) {
        connection.start((void*)receive_callback);
    }

    
    //static void receive_callback(void* topic, void* jsonBody, void* jsonMeta)
    //{
    //    if(${fd.name|filters.cap}_Controller_Base::instance) 
    //    {
    //        //${fd.name|filters.cap}_Controller_Base::instance->receive(topic, jsonBody, jsonMeta);
    //    }
    //}

private:
    Connection connection;

};

ALMAS-FILE-INFO
alt/cpp/${fd.name|filters.cap}/src/Core/${fd.name|filters.cap}_Controller_Base.cpp
ALMAS-FILE-SEPRATE

% endfor
