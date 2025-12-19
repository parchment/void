function setup_docker --description "Configure and start Docker with user permissions"
    echo "Configuring Docker..."

    # Enable the Docker service
    sudo ln -sf /etc/sv/docker /var/service/

    # Add current user to docker group
    echo "Adding user to docker group..."
    sudo usermod -aG docker $USER

    # Start Docker service
    echo "Starting Docker service..."
    sudo sv up docker

    # Apply group changes for current session
    echo "Applying docker group changes..."
    sudo newgrp docker

    echo "Docker setup complete!"
    echo "Note: You may need to log out and back in for group changes to take full effect."
end
