### Commands To Create
```bash
# Mongo
kubectl create -f mongo/mongo-deployment.yaml
kubectl create -f mongo/mongo-service.yaml

# Redis
kubectl create -f redis/redis-deployment.yaml
kubectl create -f redis/redis-service.yaml

# Tyk Dashboard
kubectl create configmap tyk-dashboard-conf --from-file=tyk/tyk_analytics.conf
kubectl create -f tyk/tyk-dashboard-deployment-v1.3.1.yaml

kubectl create -f tyk/tyk-dashboard-service.yaml

# Tyk Gateway
kubectl create configmap tyk-gateway-conf --from-file=tyk/tyk.conf
kubectl create -f tyk/tyk-gateway-deployment.yaml
kubectl create -f tyk/tyk-gateway-service.yaml

./init.sh

# Open Dashboard
open http://`minikube ip`:30001

# Create an update deployment
kubectl create -f tyk/tyk-dashboard-deployment-v1.3.2.yaml

# Patch the service to point at it
kubectl patch -f tyk/tyk-dashboard-service.yaml -p '{"spec": {"selector": {"version": "v1.3.2"}}}'

```


### Commands To Delete
```bash
kubectl delete -f tyk/tyk-dashboard-service.yaml
kubectl delete -f tyk/tyk-dashboard-deployment-v1.3.1.yaml
kubectl delete -f tyk/tyk-dashboard-deployment-v1.3.2.yaml
kubectl delete configmap tyk-dashboard-conf

kubectl delete -f tyk/tyk-gateway-service.yaml
kubectl delete -f tyk/tyk-gateway-deployment.yaml
kubectl delete configmap tyk-gateway-conf

kubectl delete -f redis/redis-service.yaml
kubectl delete -f redis/redis-deployment.yaml

kubectl delete -f mongo/mongo-service.yaml
kubectl delete -f mongo/mongo-deployment.yaml


```