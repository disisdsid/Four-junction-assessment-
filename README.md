# Four-junction-assessment-
commands used in the whole process:-
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml(domain/no-domain)
kubectl get deployments
kubectl get pods
kubectl get services
kubectl get ingress
kubectl get svc -n <namespace-of-ingress-controller>
<ingress-controller-ip> dummy-host.local(configure in /etc/hosts file in local development when you are going for dummy domain configuration)
http://dummy-host.local(to check whether your deployment is up and running or not)


in case you don't want to use nodeport to avoid single point of failure and instead want to use load balancer type service, you can create the service.yaml file accordingly and access your app using the external ip you get.

