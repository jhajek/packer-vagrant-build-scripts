#!/bin/bash

############################################################################################
# Script to give a dynamic message about the consul DNS upon login
#
# https://ownyourbits.com/2017/04/05/customize-your-motd-login-message-in-debian-and-ubuntu/
#############################################################################################

sudo cat > /etc/update-motd.d/999-consul-dns-message <<'EOF'
#!/bin/sh
echo
echo "############################################################"
echo "This is an ITM Cloud Lab Elastic Instance."
echo "This cloud provided dynamic DNS resolution."
echo "Any instance in the cloud can be accessed by attaching the FQDN of *.service.consul #" 
echo "Your Fully Qualified Domain Name is: FQDN"
echo "There is a private meta-network attached to each instance at: "
echo "`hostname  -i | awk '{print $1}'`"
EOF

sudo chmod a+x /etc/update-motd.d/999-consul-dns-message