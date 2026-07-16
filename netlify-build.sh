#!/bin/bash
set -e

git clone https://github.com/flutter/flutter.git --depth 1 -b stable

export PATH="$(pwd)/flutter/bin:$PATH"

flutter --version
dart --version

flutter config --enable-web

flutter pub get

flutter build web --release