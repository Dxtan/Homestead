#!/usr/bin/env bash

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl http2;
    server_name .$1;
    root \"$2\";

    index       index.html index.htm index_new.php;

    charset utf-8;

    location / {
        if (!-e \$request_filename) {
            rewrite  ^(.*)$  /index_new.php?s=/$1  last;
            break;
        }
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/\$1-error.log error;

    sendfile off;

    location ~ \.php/ {
        if (\$request_uri ~ ^(.+\.php)(/.+?)($|\?)) { }
        fastcgi_pass unix:/var/run/php/php$5-fpm.sock;
        include fastcgi_params;
        fastcgi_param SCRIPT_NAME     \$1;
        fastcgi_param PATH_INFO       \$2;
        fastcgi_param SCRIPT_FILENAME \$document_root\$1;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass    unix:/var/run/php/php$5-fpm.sock;
        fastcgi_index   index_new.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }

    location ~ /\.ht {
       deny all;
    }

    ssl_certificate     /etc/nginx/ssl/$1.crt;
    ssl_certificate_key /etc/nginx/ssl/$1.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
