# Container Image for Cyberchef

This is nothing special. Just a minimal container image for [Cyberchef](gchq/cyberchef).

## Usage
### Install in Kubernetes
This assumes, that your ingress class is called *nginx* and your cert-manager ClusterIssuer for SSL certificates is called *letsencrypt-prod*. 

Additionally, you should change mydomain.tld to something you own.
```
helm repo add cyberchef https://tamcore.github.io/cyberchef/charts

cat <<EOF | helm install cyberchef cyberchef/cyberchef --values -
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: cyberchef.mydomain.tld
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - secretName: cyberchef-tls
      hosts:
        - cyberchef.mydomain.tld
EOF
```

### Deploy via docker-compose
This will bind to port 8080 on your machine and will make Cyberchef accessible via HTTP that way.
```
version: "3"

services:
  cyberchef:
    container_name: cyberchef
    hostname: cyberchef
    image: ghcr.io/tamcore/cyberchef:latest
    restart: unless-stopped
    ports:
      - "8080:8080/tcp"
```

### Run via docker
This will bind to port 8080 on your machine and will make Cyberchef accessible via HTTP that way.
```
docker run --rm -it -p 8080:8080 ghcr.io/tamcore/cyberchef:latest
```
