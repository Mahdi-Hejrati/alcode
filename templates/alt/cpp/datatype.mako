<%! 
import filters.cpp as filters
%>

% for dt in root.datatypes.values():

/*
<%include file="/header.makot" args="root=root"/>
*/

#include "${dt.name|filters.cap}.hpp"

// If needed, you can include extra headers for JSON, etc.:
// #include <nlohmann/json.hpp>

${dt.name|filters.cap}::${dt.name|filters.cap}()
{
    // Default constructor body if needed
}

${dt.name|filters.cap}::${dt.name|filters.cap}(const std::unordered_map<std::string, std::string> &content)
{
    % for di in dt.items:
    {
        auto it = content.find("${di.name}");
        if (it != content.end())
        {
            % if di.di_type_id > 0:
            // Example: parse a nested object from JSON
            // this->${di.name}_ = ${di.di_type.name|filters.cap}( parseDict(it->second) );
            % else:
            this->${di.name}_ = it->second;
            % endif
        }
        else
        {
            // Assign a default if the key is not in the map
            % if di.di_type_id > 0:
            // this->${di.name}_ = ${di.di_type.name|filters.cap}();
            % else:
            this->${di.name}_ = "${di.di_type.name | filters.defval}";
            % endif
        }
    }
    % endfor
}

// --------------- Getters and Setters ---------------

% for di in dt.items:
% if di.di_type_id > 0:
const ${di.di_type.name|filters.cap}& ${dt.name|filters.cap}::get${di.name|filters.cap}() const
{
    return ${di.name}_;
}

void ${dt.name|filters.cap}::set${di.name|filters.cap}(const ${di.di_type.name|filters.cap} &value)
{
    ${di.name}_ = value;
}

% else:
const std::string& ${dt.name|filters.cap}::get${di.name|filters.cap}() const
{
    return ${di.name}_;
}

void ${dt.name|filters.cap}::set${di.name|filters.cap}(const std::string &value)
{
    ${di.name}_ = value;
}

% endif
% endfor

// --------------- Serialize Method ---------------
std::unordered_map<std::string, std::string> ${dt.name|filters.cap}::Serialize() const
{
    std::unordered_map<std::string, std::string> ret;
    % for di in dt.items:
    % if di.di_type_id > 0:
    // If this field is a nested object, you could store it as a JSON string:
    // ret["${di.name}"] = ${di.name}_.toJsonString();
    % else:
    ret["${di.name}"] = this->${di.name}_;
    % endif
    % endfor
    return ret;
}

// --------------- toString() ---------------
std::string ${dt.name|filters.cap}::toString() const
{
    auto data = Serialize();
    std::ostringstream oss;
    oss << "{";
    bool first = true;
    for (auto &kv : data)
    {
        if (!first) { oss << ", "; }
        oss << "\"" << kv.first << "\": \"" << kv.second << "\"";
        first = false;
    }
    oss << "}";
    return oss.str();
}

// ---------------------------------------------

% for fd in root.federates.values():
ALMAS-FILE-INFO
alt/cpp/${fd.name|filters.cap}/src/DataType/${dt.name|filters.cap}.cpp
% endfor
ALMAS-FILE-SEPRATE

% endfor
