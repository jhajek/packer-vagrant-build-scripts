#!/bin/bash

############################################################################################
# Script to give a dynamic message about the consul DNS upon login
#
# https://ownyourbits.com/2017/04/05/customize-your-motd-login-message-in-debian-and-ubuntu/
#############################################################################################

cat > /etc/update-motd.d/999-consul-dns-message <<'EOF'
#!/bin/sh
echo
echo "############################################################"
echo "# This is an ITM Cloud Lab Elastic Instance."
echo "# This cloud provided dynamic DNS resolution."
echo "# There is a private meta-network attached to each instance at: "
echo "# 0.0.0.0                                                  #"
echo "# Any instance in the cloud can be accessed by attaching the FQDN of *.service.consul #" 
echo "# Your Fully Qualified Domain Name is: "
EOF

chmod a+x /etc/update-motd.d/999-dns-message