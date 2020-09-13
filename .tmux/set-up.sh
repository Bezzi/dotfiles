#!/usr/bin/env bash

# Use nord theme
[ ! -d './themes/nord-tmux' ] && git clone git@github.com:arcticicestudio/nord-tmux.git ./themes/nord-tmux
cd ./themes/nord-tmux && git pull
