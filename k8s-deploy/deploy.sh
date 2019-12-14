aws eks --region eu-west-1 update-kubeconfig --name eks-revolut
kubectl apply -f rbac-role.yaml
kubectl apply -f alb-ingress-controller.yaml
kubectl apply -f app_namespace.yaml
kubectl apply -f app_deployment.yaml
kubectl apply -f app_services.yaml
kubectl apply -f app_ingress.yaml
