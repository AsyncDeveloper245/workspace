#!/bin/sh

OPERATION="$1"
APP_NAME="$2"
APP_PORT="$3"
Vhost=/etc/nginx/sites-available/$APP_NAME
Sites_Enabled=/etc/nginx/sites-enabled

if [ $OPERATION == create ]
then
    echo "Creating Virtual Host"
    sudo touch $Vhost

    echo "Configuring ${APP_NAME} with the specified configuration.........."
    sudo tee <<EOF > $Vhost
        server {
                listen 80;
                listen [::]:80;

                root /var/www/html;

                # Add index.php to the list if you are using PHP
                index index.html index.htm index.nginx-debian.html;

                server_name $APP_NAME;

                location / {
                        # First attempt to serve request as file, then
                        # as directory, then fall back to displaying a 404.
                        proxy_pass http://localhost:$APP_PORT;
                }
        }
EOF

    echo "Creating a symlink of ${APP_NAME}"
    sudo ln -s $Vhost $Sites_Enabled
    sudo nginx -t | grep 'ok' && sudo systemctl restart nginx
    echo "Nginx restarted successfully......"
    
    
elif [ "$OPERATION" == delete ]
then
    sudo unlink /etc/nginx/sites-enabled/$APP_NAME
    sudo rm -f /etc/nginx/sites-available/$APP_NAME
    sudo nginx -t | grep 'ok' && sudo systemctl restart nginx
    echo "Nginx restarted successfully......"
else
    echo "Incorrect Input....."

fi



