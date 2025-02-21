#!/bin/bash

# python
# python3 main.py
# cp -f ~/projects/alt-server/dynamiclib/cmake-build-debug/libSDKUtils.so ~/projects/alcode/output/Machinery/alt/python/Commander/almas-alt.so
# cd ~/projects/alcode/output/Machinery/alt/python/Commander
# python3 main.py
# cd ~/projects/alcode
# python3 main.py

#------------------------------------------
# cpp

python3 main.py
cp -f ~/projects/alt-server/dynamiclib/cmake-build-debug/libSDKUtils.so ~/projects/alcode/output/Machinery/alt/cpp/Commander/build/almas-alt.so
cd ~/projects/alcode/output/Machinery/alt/cpp/Commander/build
cmake ..
make -j
./Commander

cd ~/projects/alcode