#!/usr/bin/bash
path=/recordings
find $path -name "*.wav"|sed 's/wav//g'|while read line;
do
        if [ ! -f ${line}mp3 ]; then
                cp ${line}wav  ${line}mp3
        fi
done


find $path -mtime +3  -name "*.wav" |sed 's/wav//g'|while read line;
do
        if [ -f ${line}mp3 ]; then
                rm -rf ${line}wav
        fi
done
