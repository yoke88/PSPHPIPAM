#!/bin/bash
vagrant docker-exec phpipam -- sh -c "/bin/sed -i 's/api_allow_unsafe = false/api_allow_unsafe = true/' /var/www/html/config.php"