import subprocess

def run_command(command):
    """Run a command and return its output."""
    try:
        result = subprocess.run(command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        return f"Error: {e.stderr}"

def install_apache():
    """Install Apache2 using apt."""
    print("Installing Apache2...")
    return run_command(['sudo', 'apt', 'update']), run_command(['sudo', 'apt', 'install', '-y', 'apache2'])

def check_apache_running():
    """Check if Apache2 service is running."""
    print("Checking if Apache2 is running...")
    status = run_command(['sudo', 'systemctl', 'status', 'apache2'])
    if 'active (running)' in status:
        return "Apache2 is running."
    return "Apache2 is not running."

def ensure_ufw_installed():
    """Ensure UFW is installed and enable it."""
    print("Ensuring UFW (Uncomplicated Firewall) is installed and enabled...")
    run_command(['sudo', 'apt', 'install', '-y', 'ufw'])  # Install UFW if not installed
    run_command(['sudo', 'ufw', '--force', 'enable'])  # Enable UFW without confirmation prompt
    return "UFW is installed and enabled."

def allow_ports():
    """Allow HTTP (port 80) and HTTPS (port 443) traffic in UFW."""
    print("Allowing HTTP and HTTPS traffic in UFW...")
    run_command(['sudo', 'ufw', 'allow', '80/tcp'])  # Allow HTTP (port 80)
    run_command(['sudo', 'ufw', 'allow', '443/tcp']) # Allow HTTPS (port 443)
    return "Allowed HTTP and HTTPS traffic."

def ensure_listening_on_port_80():
    """Check if Apache2 is listening on port 80."""
    print("Checking if Apache2 is listening on port 80...")
    netstat_output = run_command(['sudo', 'netstat', '-tuln'])
    if '0.0.0.0:80' in netstat_output:
        return "Apache2 is listening on port 80."
    return "Apache2 is not listening on port 80."

def restart_apache():
    """Restart Apache2 service."""
    print("Restarting Apache2 service...")
    return run_command(['sudo', 'systemctl', 'restart', 'apache2'])

def main():
    # Install Apache2
    print(install_apache())

    # Check if Apache2 is running
    print(check_apache_running())

    # Ensure UFW is installed
    print(ensure_ufw_installed())

    # Allow ports 80 and 443
    print(allow_ports())

    # Check if Apache is listening on port 80
    print(ensure_listening_on_port_80())

    # Restart Apache2 to apply any changes
    print(restart_apache())

if __name__ == "__main__":
    main()
