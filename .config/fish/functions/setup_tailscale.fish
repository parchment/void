function setup_tailscale --description "Configure and start Tailscale with SSH enabled"
    echo "Configuring Tailscale..."

    # Enable the service
    sudo ln -sf /etc/sv/tailscaled /var/service/

    # Start the service
    echo "Starting Tailscale service..."
    sudo sv up tailscaled

    # Connect with SSH enabled
    echo "Connecting to Tailscale network with SSH enabled..."
    sudo tailscale up --ssh

    # Configure persistent SSH support
    echo "Configuring Tailscale to start with SSH enabled..."
    echo 'TS_EXTRA_ARGS="--ssh"' | sudo tee /etc/tailscale/tailscaled.conf
    echo 'OPTS="--state=/var/lib/tailscale/tailscaled.state"' | sudo tee /etc/sv/tailscaled/conf

    # Restart to apply config
    sudo sv restart tailscaled

    echo "Tailscale setup complete!"
end
