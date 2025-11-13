#!/bin/bash
temp=$(sensors | grep -m 1 'Core 0' | awk '{print $3}' | tr -d '+')
echo "{\"text\": \"  $temp\", \"tooltip\": \"CPU temperature\"}"

