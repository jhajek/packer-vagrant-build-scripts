#!/bin/bash

# Append this to the end of config.php 
# https://docs.moodle.org/dev/Install_Moodle_On_Ubuntu_with_Nginx/PHP-fpm
# Setting Moodle and Nginx to use XSendfile functionality is a big win as it frees PHP from delivering files allowing Nginx to do what it does best, i.e. deliver files. 
# Enable xsendfile for Nginx in Moodles config.php, this is documented in the config-dist.php, a minimal configuration look like this, 
cat <<EOF >> /var/www/html/config.php

\$CFG->xsendfile = 'X-Accel-Redirect';
\$CFG->xsendfilealiases = array(
    '/var/moodledata' => \$CFG->dataroot
);
EOF