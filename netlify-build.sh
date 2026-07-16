#!/bin/bash
set -e

# Delete any existing Flutter folder
rm -rf flutter

# Clone Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable flutter

# Add Flutter to PATH
export PATH="$PWD/flutter/bin:$PATH"

flutter --version

flutter config --enable-web

flutter pub get

flutter build web --release