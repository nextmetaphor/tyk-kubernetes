# Tyk Professional Installation on Kubernetes
This guide details how to install a Tyk Professional installation on a `minikube` Kubernetes installation. It also shows how a Grafana dashboard can be used to configured to provide detailed monitoring for environment.

## Getting Started

### Prerequisites
* [minikube](https://kubernetes.io/docs/getting-started-guides/minikube/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)


### Install
See [https://nextmetaphor.io/2017/01/19/local-kubernetes-on-macos/](https://nextmetaphor.io/2017/01/19/local-kubernetes-on-macos/) for details on how to install the prerequisite software onto macOS.

## Deployment 
#### Install InfluxDB
[InfluxDB](https://github.com/influxdata/influxdb) is an open-source time series database that we will use to store the metrics from Tyk. 
```bash
kubectl create configmap influxdb-conf --from-file=influxdb/influxdb.conf
kubectl create -f influxdb/influxdb-deployment.yaml
kubectl create -f influxdb/influxdb-service.yaml
```

We can verify that this has been deployed successfully by executing the following command which will allow us to log into the database.
```
open http://`minikube ip`:30101
```
Note that
* the Port should be set to `30100`
* the Username should be set to `admin`
* the Password should be set to `admin`


#### Install Telegraf
[Telegraf](https://github.com/influxdata/telegraf) is an open-source metrics collection daemon that we will use to collect metrics from Tyk and then store in InfluxDB.
```
kubectl create configmap telegraf-conf --from-file=telegraf/telegraf.conf
kubectl create -f telegraf/telegraf-deployment.yaml
kubectl create -f telegraf/telegraf-service.yaml
```

#### Install Grafana
[Grafana](https://github.com/grafana/grafana) is an open-source metrics dashboard that we will use to visualise the data stored in InfluxDB.
```
kubectl create -f grafana/grafana-deployment.yaml
kubectl create -f grafana/grafana-service.yaml
```

We can verify that this has been deployed successfully by executing the following command which will allow us open the Grafana dashboard and connect to the InfluxDB database.
```
open http://`minikube ip`:30102
```
Note that
* the Username should be set to `admin`
* the Password should be set to `admin`

Once logged in, create a data source with the following options:
* the **Name** should be set to `Gateway`
* the **Type** should be set to `InfluxDB`

Within the **Http settings** section:
* the **Url** should be set to `http://influxdb:8086`
* **Access** should be set to `Proxy`

Leave everything unchecked in the **Http Auth** section.

Within the **InfluxDB Details** section:
* the **Database** should be set to `telegraf`
* the **User** should be set to `admin`
* the **Password** should be set to `admin`

### Install Mongo
Install the Mongo database which stores the Tyk API definitions and long-term analytics information.

```
kubectl create -f mongo/mongo-deployment.yaml
kubectl create -f mongo/mongo-service.yaml
```

### Install Redis
Install the Redis distributed in-memory cache which stores the active API keys and short-term analytics information.

```
kubectl create -f redis/redis-deployment.yaml
kubectl create -f redis/redis-service.yaml
```

### Install Tyk Dashboard
Install the Tyk Dashboard which allow us to administer the API gateway environment.
```
kubectl create configmap tyk-dashboard-conf --from-file=tyk-dashboard/tyk_analytics.conf
kubectl create -f tyk-dashboard/tyk-dashboard-deployment-v1.3.1.yaml
kubectl create -f tyk-dashboard/tyk-dashboard-service.yaml
```

### Install Tyk Gateway
Install the Tyk Gateway nodes themselves.
```
kubectl create configmap tyk-gateway-conf --from-file=tyk-gateway/tyk.conf
kubectl create -f tyk-gateway/tyk-gateway-deployment.yaml
kubectl create -f tyk-gateway/tyk-gateway-service.yaml

./init.sh
```

## Validation

#### Open the Tyk Dashboard
Execute the following command to log into the Tyk Dashboard:
```
open http://`minikube ip`:30001
```
At the login screen:
* the **Username** should be set to `admin@test.com`
* the **Password** should be set to `admin123`


### TODO - Update the Dashboard
```bash
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