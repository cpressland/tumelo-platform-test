# Kubernetes deployment makes me crazy

Welcome! Here I'm one more day in the office and I need your help to fix some problems I'm having with a kubernetes deployment.

The error I'm getting when we run `kubectl apply -f bad-deployment.yaml` is as follows:

```
error: unable to recognize "bad-deployment.yaml": no matches for kind "Deploy" in version "apps/v1"
```

The manifest I'm using is the following (I probably have more errors that I haven't noticed):

```yaml
apiVersion: apps/v1
kind: Deploy
metadata:
  name: tumeloapp-deployment
  labels:
    app: tumeloapp
spec:
  containers:
    - name: tumeloapp
      image: paulbouwer/hello-kubernetes:latest
      ports:
        - containerPort: 8080
      resources:
        requests:
          memory: "128Mi"
          cpu: "500m"
        limits:
          memory: "64Mi"
          cpu: "500m"
```

(see `bad-deployment.yaml` file)

In addition to fixing it, I have the following requirements, can you help me?

- It must have three replicas
- Must be exposed in a NodePort on port 32033
- Security and best practices must be taken into account
- Target version is Kubernetes 1.24

_Note: You can use a tool such as kind (https://kind.sigs.k8s.io/docs/user/quick-start/) or minikube (https://minikube.sigs.k8s.io/docs/start/) to test the manifests._
