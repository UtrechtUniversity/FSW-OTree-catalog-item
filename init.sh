#!/bin/bash

# This script runs just before the Docker project starts. It makes a couple
# of changes in the system for the Compose project

# Define the Nginx configuration file path
nginx_conf="/etc/nginx/conf.d/ssl_main.conf"

# Let Nginx serve the docker container running on port 8000 instead of a static web page
sed -i 's|root /var/www/html;|location \/ {\n    \tproxy_pass http:\/\/localhost:8000;\n    \tproxy_set_header Host $host;\n    \tproxy_set_header X-Real-IP $remote_addr;\n    }|' "$nginx_conf"
sed -i 's|index index.html index.htm;||' "$nginx_conf"

# Restart nginx to reload configuration
systemctl restart nginx.service

# Use the Research Cloud parameters to create an environment file to configure
# our Docker containers
parameters=$PLUGIN_PARAMETERS
echo $parameters | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' > /var/parameters.txt