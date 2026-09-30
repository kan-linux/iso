#!/bin/bash
# Hyprland 自动启动脚本

# PipeWire 音频服务（按顺序启动）
pipewire &
sleep 2
pipewire-pulse &
sleep 1
wireplumber &
