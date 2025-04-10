#!/bin/sh
set -e

chmod +x ./install-scripts/ubuntu.sh
chmod +x ./install-scripts/fresh_install.sh
chmod +x ./install-scripts/setup_fish

./install-scripts/ubuntu.sh
./install-scripts/fresh_install.sh
. ./install-scripts/setup_fish
