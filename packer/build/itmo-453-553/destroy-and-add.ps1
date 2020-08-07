vagrant box destroy -force ub-riemanna
vagrant box destroy -force centos-riemannb
vagrant box destroy -force ub-riemannmc
vagrant box destroy -force ub-graphitea
vagrant box destroy -force centos-graphiteb
vagrant box destroy -force ub-graphitemc



vagrant box add ../*.box --name ub-riemanna
vagrant box add ../*.box --name centos-riemannb
vagrant box add ../*.box --name ub-riemannmc
vagrant box add ../*.box --name ub-graphitea
vagrant box add ../*.box --name centos-graphiteb
vagrant box add ../*.box --name ub-graphitemc


