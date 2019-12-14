#!/bin/bash
curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
chmod +x kubectl; mv kubectl /usr/bin/
aws eks --region "${region}" update-kubeconfig --name test_gui
cd /tmp; curl -o helm-v3.0.1-linux-amd64.tar.gz https://get.helm.sh/helm-v3.0.1-linux-amd64.tar.gz; tar -xzvf helm-v3.0.1-linux-amd64.tar.gz; mv linux-amd64/helm /usr/bin/
yum install git -y; git clone https://github.com/gealmei/_revolut-challenge.git
sed -i 's/DB-URI/${db-uri}/g' /tmp/_revolut-challenge/app/.env; sed -i 's/USER/${db-user}/g' /tmp/_revolut-challenge/app/.env; sed -i 's/PASSWORD/${db-password}/g' /tmp/_revolut-challenge/app/.env
sed -i '/"bridge": "none",/d' /etc/docker/daemon.json; service docker restart
$(aws ecr get-login --no-include-email --region "${region}"); cd /tmp/_revolut-challenge/app ; docker build -t hello . 
docker tag hello:latest "${account-id}".dkr.ecr."${region}".amazonaws.com/"${ecr-name}":"${image-tag}"
docker push ${account-id}.dkr.ecr."${region}".amazonaws.com/"${ecr-name}":"${image-tag}"
