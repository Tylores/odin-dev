#!/bin/bash

sudo apt update
sudo apt install -y clang
git clone https://github.com/odin-lang/Odin
cd Odin
make release-native

current_dir="$(pwd)"
if [[ ":$PATH:" != *":${current_dir}:"* ]]; then
  echo "export PATH=\"${current_dir}:\$PATH\"" >> ~/.bashrc
  source ~/.bashrc
fi
