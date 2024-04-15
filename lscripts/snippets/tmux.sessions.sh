#!/bin/bash

tmux new-session -d -s main
tmux split-window -h
tmux split-window -v
tmux select-pane -t 0
tmux split-window -v
tmux -2 attach-session -d
