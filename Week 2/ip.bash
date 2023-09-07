#!/bin/bash

# This line runs the 'ip addr' command and stores its output in the variable called ip_output
ip_output=$(ip addr)

# This line uses grep to filter out any lines containing '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/24' which would be the inet address(IPv4) with a subne>
inet_address=$(echo "$ip_output" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/24')

# Print the 'IPv4' address
echo "Your IPv4 address is: $inet_address"
