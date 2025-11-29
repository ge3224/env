#!/usr/bin/env bash

# Get fcitx5 current input method state
# 1 = inactive (English)
# 2 = active (Chinese/Pinyin)

state=$(fcitx5-remote 2>/dev/null)

if [ "$state" = "2" ]; then
    echo '{"text": "中", "tooltip": "Chinese (Pinyin)", "class": "chinese"}'
else
    echo '{"text": "英", "tooltip": "English", "class": "english"}'
fi
