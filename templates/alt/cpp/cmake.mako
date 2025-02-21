<%!
import filters.cpp as filters
%>

% for fd in root.federates.values():


cmake_minimum_required(VERSION 3.10)
project(Messenger LANGUAGES CXX)

# Use at least C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF) 

# Create an executable named after the federate, e.g. "Machinery"
add_executable(${fd.name|filters.cap}
    # The main file for this federate
    src/main.cpp

    # All data type .cpp files for this federate
    % for dt in root.datatypes.values():
    src/DataType/${dt.name|filters.cap}.cpp
    % endfor

    # Core and controller .cpp files for this federate
    src/Core/${fd.name|filters.cap}_Controller_Base.cpp
    src/${fd.name|filters.cap}_Controller_Sample.cpp
)

# If /usr/local/include has the headers:
target_include_directories(${fd.name|filters.cap} PRIVATE /usr/local/include)

# If /usr/local/lib has the .so:
target_link_directories(${fd.name|filters.cap} PRIVATE /usr/local/lib)

ALMAS-FILE-INFO
alt/cpp/${fd.name|filters.cap}/CMakeLists.txt
ALMAS-FILE-SEPRATE
% endfor

