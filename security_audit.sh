#!/bin/bash

# Function to check open ports
check_open_ports() {
    echo "Checking for open ports..."
    output=$(ss -tuln)
    echo "$output"
    echo "$output" > open_ports.txt
    echo "Open ports results saved to open_ports.txt"
    echo
}

# Function to check user accounts
check_user_accounts() {
    echo "Checking user accounts..."
    output=$(cut -d: -f1 /etc/passwd)
    echo "$output"
    echo "$output" > user_accounts.txt
    echo "User accounts results saved to user_accounts.txt"
    echo
}

# Function to check for available updates
check_updates() {
    echo "Checking for available updates..."
    output=$(apt list --upgradable 2>/dev/null)
    echo "$output"
    echo "$output" > updates.txt
    echo "Update results saved to updates.txt"
    echo
}

# Function to check for failed login attempts
check_failed_logins() {
    echo "Checking for failed login attempts..."
    output=$(journalctl -xe | grep 'Failed')
    if [ -z "$output" ]; then
        echo "No failed login attempts found."
    else
        echo "$output"
    fi
    echo "$output" > failed_logins.txt
    echo "Failed login results saved to failed_logins.txt"
    echo
}

# Function to check for unused services
check_unused_services() {
    echo "Checking for unused services..."
    output=$(systemctl list-unit-files --type=service | grep enabled | awk '{print $1}')
    echo "Enabled Services:"
    echo "$output"
    echo "$output" > enabled_services.txt
    echo "Enabled services results saved to enabled_services.txt"
    echo
}

# Function to check disk usage
check_disk_usage() {
    echo "Checking disk usage..."
    output=$(df -h)
    echo "$output"
    echo "$output" > disk_usage.txt
    echo "Disk usage results saved to disk_usage.txt"
    echo
}

# Function to check SSH configuration
check_ssh_config() {
    echo "Checking SSH configuration..."
    output=$(grep -E 'PermitRootLogin|PasswordAuthentication' /etc/ssh/sshd_config)
    echo "$output"
    echo "$output" > ssh_config.txt
    echo "SSH configuration results saved to ssh_config.txt"
    echo
}

# Function to check for SUID/SGID files
check_suid_sgid() {
    echo "Checking for SUID/SGID files..."
    output=$(find / -perm /6000 -type f 2>/dev/null)
    echo "$output"
    echo "$output" > suid_sgid_files.txt
    echo "SUID/SGID files results saved to suid_sgid_files.txt"
    echo
}

# Function to check firewall status
check_firewall_status() {
    echo "Checking firewall status..."
    output=$(ufw status)
    echo "$output"
    echo "$output" > firewall_status.txt
    echo "Firewall status results saved to firewall_status.txt"
    echo
}

# Run all functions
check_open_ports
check_user_accounts
check_updates
check_failed_logins
check_unused_services
check_disk_usage
check_ssh_config
check_suid_sgid
check_firewall_status

echo "Security audit completed."
