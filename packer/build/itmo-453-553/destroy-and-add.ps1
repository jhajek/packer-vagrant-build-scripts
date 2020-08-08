vagrant box destroy -force ub-riemanna
vagrant box destroy -force centos-riemannb
vagrant box destroy -force ub-riemannmc
vagrant box destroy -force ub-graphitea
vagrant box destroy -force centos-graphiteb
vagrant box destroy -force ub-graphitemc



vagrant box add ../ub-riemanna-virtualbox*.box --name ub-riemanna
vagrant box add ../centos-riemannb-virtualbox*.box --name centos-riemannb
vagrant box add ../ub-riemannmc-virtualbox*.box --name ub-riemannmc
vagrant box add ../ub-graphitea-virtualbox*.box --name ub-graphitea
vagrant box add ../centos-graphiteb-virtualbox*.box --name centos-graphiteb
vagrant box add ../ub-graphitemc-virtualbox*.box --name ub-graphitemc


