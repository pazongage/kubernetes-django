# Django Kubernetes Project

This repository contains Kubernetes manifests and configuration for deploying a Django application with a PostgreSQL database.

## Repository Structure

- `configmap.yaml`:
  Defines environment variables for the Django application.
  - Example:
    - `DJANGO_SETTINGS_MODULE`: Specifies the settings module for Django.
    - `ALLOWED_HOSTS`: List of allowed hosts or [*].

- `deployment-django.yaml`:
  Defines the deployment for the Django application, including replicas, container image, ports, and environment variables.

- `deployment-postgres.yaml`:
  Defines the deployment for the PostgreSQL database, including persistent storage and secrets for configuration.

- `ingress.yaml`:
  Configures an Ingress resource to expose the Django application using the hostname `kubernetes-django.com`.

- `namespace.yaml`:
  Creates a namespace `django-app` to isolate resources for the application.

- `pvc-postgres.yaml`:
  Creates a PersistentVolumeClaim for PostgreSQL data storage with a capacity of 5Gi.

- `secret.yaml`:
  Stores sensitive information (e.g., database credentials) as Kubernetes secrets.
  - `POSTGRES_USER`: Base64 encoded database user.
  - `POSTGRES_PASSWORD`: Base64 encoded database password.
  - `POSTGRES_DB`: Base64 encoded database name.

- `service-django.yaml`:
  Defines a ClusterIP service to expose the Django application internally.

- `service-postgres.yaml`:
  Defines a ClusterIP service to expose the PostgreSQL database internally.

## Setup Instructions

### Prerequisites
- Kubernetes cluster (local or cloud-based).
- `kubectl` CLI installed.

### Steps to Deploy the Application

1. **Create the Namespace:**
   ```bash
   kubectl apply -f namespace.yaml
   ```

2. **Create Secrets and ConfigMap:**
   ```bash
   kubectl apply -f secret.yaml
   kubectl apply -f configmap.yaml
   ```

3. **Deploy PostgreSQL:**
   ```bash
   kubectl apply -f pvc-postgres.yaml
   kubectl apply -f deployment-postgres.yaml
   kubectl apply -f service-postgres.yaml
   ```

4. **Deploy Django Application:**
   ```bash
   kubectl apply -f deployment-django.yaml
   kubectl apply -f service-django.yaml
   ```

5. **Set Up Ingress:**
   - Ensure an ingress controller (e.g., Nginx) is installed in your cluster.
     ```bash
     kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
     ```
   - Apply the ingress manifest:
     ```bash
     kubectl apply -f ingress.yaml
     ```

### Accessing the Application

1. **Local Access (Minikube):**
   - Enable the ingress addon:
     ```bash
     minikube addons enable ingress
     ```
   - Get the Minikube IP:
     ```bash
     minikube ip
     ```
   - Add an entry to `/etc/hosts` to map the domain `kubernetes-django.com`:
     ```bash
     echo "<minikube-ip> kubernetes-django.com" | sudo tee -a /etc/hosts
     ```
   - Open `http://kubernetes-django.com` in your browser.

2. **Cloud Access:**
   - Retrieve the external IP of the ingress:
     ```bash
     kubectl get ingress -n django-app
     ```
   - Update your DNS records to point `kubernetes-django.com` to the external IP.

### Useful Commands

- **Check Pod Status:**
  ```bash
  kubectl get pods -n django-app
  ```

- **View Logs for Django:**
  ```bash
  kubectl logs -f deployment/django -n django-app
  ```

- **View Logs for PostgreSQL:**
  ```bash
  kubectl logs -f deployment/postgres -n django-app
  ```

- **Restart Django Deployment:**
  ```bash
  kubectl rollout restart deployment/django -n django-app
  ```

- **Describe Resources:**
  - Pods:
    ```bash
    kubectl describe pod <pod-name> -n django-app
    ```
  - Ingress:
    ```bash
    kubectl describe ingress django-ingress -n django-app
    ```

### Debugging

- Ensure all pods are running:
  ```bash
  kubectl get pods -n django-app
  ```

- Check service connectivity from within the Django pod:
  ```bash
  kubectl exec -it <django-pod-name> -n django-app -- sh
  ping postgres-service
  ```

- Verify ingress rules:
  ```bash
  kubectl get ingress -n django-app
  ```



