#!/bin/bash

sudo apt update
sudo apt install -y clang
git clone https://github.com/odin-lang/Odin
cd Odin
make release-native

