# Destroy existing vagrant boxes
Set-Location ub-riemanna
vagrant destroy -f
Remote-Item ./.vagrant -Recurse
Set-Location ../centos-riemannb
vagrant destroy -f
Remote-Item ./.vagrant -Recurse
Set-Location ../ub-riemannmc
vagrant destroy -f
Remote-Item ./.vagrant -Recurse
Set-Location ../ub-graphitea
vagrant destroy -f
Remote-Item ./.vagrant -Recurse
Set-Location ../centos-graphiteb
vagrant destroy -f
Remote-Item ./.vagrant -Recurse
Set-Location ../ub-graphitemc
vagrant destroy -f
Remote-Item ./.vagrant -Recurse
Set-Location ../

# Remove existing vagrant boxes
vagrant box remove -force ub-riemanna
vagrant box remove -force centos-riemannb
vagrant box remove -force ub-riemannmc
vagrant box remove -force ub-graphitea
vagrant box remove -force centos-graphiteb
vagrant box remove -force ub-graphitemc

# Add newly built Vagrant boxes
vagrant box add ../ub-riemanna-virtualbox*.box --name ub-riemanna
vagrant box add ../centos-riemannb-virtualbox*.box --name centos-riemannb
vagrant box add ../ub-riemannmc-virtualbox*.box --name ub-riemannmc
vagrant box add ../ub-graphitea-virtualbox*.box --name ub-graphitea
vagrant box add ../centos-graphiteb-virtualbox*.box --name centos-graphiteb
vagrant box add ../ub-graphitemc-virtualbox*.box --name ub-graphitemc

# Delete existing Vagrant artifacts since they have been added
Remove-Item ../ub-riemanna-virtualbox*.box
Remove-Item ../centos-riemannb-virtualbox*.box
Remove-Item ../ub-riemannmc-virtualbox*.box
Remove-Item ../ub-graphitea-virtualbox*.box
Remove-Item ../centos-graphiteb-virtualbox*.box
Remove-Item ../ub-graphitemc-virtualbox*.box