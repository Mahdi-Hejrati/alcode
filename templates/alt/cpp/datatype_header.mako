<%!
import filters.cpp as filters
%>
% for dt in root.datatypes.values():

/*
<%include file="/header.makot" args="root=root"/>
*/

#ifndef ${dt.name.upper()}_HPP
#define ${dt.name.upper()}_HPP

#include <string>
#include <unordered_map>
% if [i for i in dt.items if i.di_type_id > 0]:
// If this data type references other types, include their HPPs here:
% for i in [i.di_type.name for i in dt.items if i.di_type_id > 0]:
#include "${i|filters.cap}.hpp"
% endfor
% endif

#include <sstream>
#include <iostream>

// Class: ${dt.name|filters.cap}
// Description lines:
% if dt.desc1.strip() or dt.desc2.strip():
/*  
${dt.desc1}
${dt.desc2,'    '| filters.indent}
*/
% endif
class ${dt.name|filters.cap}
{
public:
    // Default constructor
    ${dt.name|filters.cap}();

    // Constructor that behaves like "UnSerialize", accepting a dictionary
    explicit ${dt.name|filters.cap}(const std::unordered_map<std::string, std::string> &content);

    % for di in dt.items:
    % if di.desc1.strip():
    // ${di.desc1}
    % endif
    % if di.desc2.strip():
    // ${di.desc2,'    # '| filters.indent}
    % endif
    % if di.di_type_id > 0:
    // Getter for ${di.name}
    const ${di.di_type.name|filters.cap}& get${di.name|filters.cap}() const;
    // Setter for ${di.name}
    void set${di.name|filters.cap}(const ${di.di_type.name|filters.cap} &value);
    % else:
    // Getter for ${di.name}
    const std::string& get${di.name|filters.cap}() const;
    // Setter for ${di.name}
    void set${di.name|filters.cap}(const std::string &value);
    % endif
    % endfor

    // Serialize method that returns a dictionary-like structure
    std::unordered_map<std::string, std::string> Serialize() const;

    std::string toString() const;

private:
    // Members that store each field
    % for di in dt.items:
    % if di.di_type_id > 0:
    ${di.di_type.name|filters.cap} ${di.name}_;
    % else:
    std::string ${di.name}_;
    % endif
    % endfor
};

#endif // ${dt.name.upper()}_HPP

% for fd in root.federates.values():
ALMAS-FILE-INFO
alt/cpp/${fd.name|filters.cap}/src/DataType/${dt.name|filters.cap}.hpp
% endfor
ALMAS-FILE-SEPRATE
% endfor
