k8s py example
==============

This repo will explain you how to deploy a basic python application into
kubernetes and how to rolling update it.

First thing first, you will need to build your application, for the sake of
simplicity we are going to to build the application twice here (one for each
version):

    docker build -t agonzalezro/k8s-py-example .

The above command is going to create a docker image of your python application
living into `src/`. We will tag it as version `0.1`:

    docker tag agonzalezro/k8s-py-example:latest agonzalezro/k8s-py-example:0.1

You could have use the layer id as well, but this one is more straigh forward.

Now do some changes on `src/app.py` to differentiate both apps. When you are
done, build and tag your "new" app:

    docker build -t agonzalezro/k8s-py-example .
    docker tag agonzalezro/k8s-py-example:latest agonzalezro/k8s/py-example:0.2

When you are done push them to the hub, remember to create the project before
hand:

    docker push agonzalezro/k8s-py-example

Ok, now we are ready to deploy it into kubernetes. There are three important
files in this repo:

- **rc-0.1.yml**: the replication controller for the first version.
- **rc-0.2.yml**: the replication controller for the second version.
- **service.yml**: the service for both.

Let's create a RC and a service for the first version:

    kubectl -f rc-0.1.yml -f service.yml --validate=false
    # The validate tag is just needed because of a bug in current k8s

Now if you do:

    kubectl get services

You should be seeing something like this:

    flaskapp-service 10.91.246.233 104.197.30.229 80/TCP name=web 1m

The second IP is your external IP for the version 1 of your app. You can visit
it and you will see your awesome app running!

We have the version 0.1 running, I always want to run last versions of
everything so I will update it:

    kubectl rolling-update flaskapp-rc -f rc-0.2.yml

BOOM! Your app was gracefully deployed to the new version.

Nice k8s commands
-----------------

    kubectl config view
    kubectl cluster-info # Check that UI, it's pretty cool!

Some footnotes
--------------

I did this small tutorial in part based on [@ipedrazas
work](https://github.com/ipedrazas/k8s-lskp-demo). You should read it as well!
