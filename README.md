[![Continuous Deployment with GitHub Actions & Argo CD](https://github.com/Chinedu-Onyema/docker-image-for-django-application/actions/workflows/argocd_deployment.yml/badge.svg)](https://github.com/Chinedu-Onyema/docker-image-for-django-application/actions/workflows/argocd_deployment.yml)

# Building, Containerizing & Continuously Deploying A Django Application: From Development to Kubernetes

## OVERVIEW

This comprehensive guide is designed for developers and DevOps engineers taking their first steps into the Python web ecosystem. This project is not just about writing code; it is a holistic journey through the modern software development lifecycle (SDLC).

We start by exploring the Django Framework. Django is a high-level Python web framework that encourages rapid development and clean, pragmatic design.
Written by experienced developers, it takes care of much of the hassle of web development, so you can focus on writing your app without needing to reinvent the wheel. It follows the "Batteries Included" philosophy, providing built-in tools for user authentication, database management, admin interfaces, and security right out of the box. Top-tier organizations like Instagram, Spotify, and Dropbox rely on Django to handle their scalability and security needs.

In the first phase of this guide, you will build a foundational Django application, transitioning from a simple "Hello World" HTTP response to rendering a full, static HTML portfolio website.

However, building the application is only half the battle. Modern software needs to run reliably across different environments, for example, from a developer's laptop to production cloud clusters. To achieve this, we will move into Containerization with Docker. You will learn to write a Dockerfile, create efficient multi-stage builds, and utilize Google's Distroless images to create a secure, minimal production image that only contains your application and its dependencies, no shell, no package manager, just your code.

To ensure high availability, scalability, and resilience, we will dive into Orchestration with Kubernetes. Using a development Kubernetes environment like Minikube, you will deploy your containerized Django app, design advanced Service networking (ClusterIP, NodePort, LoadBalancer), implement Ingress routing rules, and monitor live cluster traffic using Kubeshark.

You will deploy and debug (CrashLoopBackOff) your containerized Django application and implement advanced networking in a production Kubernetes environment using OpenShift.

Finally, you will master GitOps with Argo CD and automate continuous deployment/delivery to Argo CD with GitHub Actions.

##### IMPORTANT NOTE: Each phase includes a downloadable PDF guide and a step-by-step video walkthrough to help you follow the deployment process. 


## PHASE 1: CREATING YOUR FIRST DJANGO APPLICATION

### INTRODUCTION
In this phase, we will get started with the Django framework by setting up a Python environment, creating a new Django project structure (portfolio), understanding key configurations (settings.py, urls.py, manage.py), building a custom app (website), handling basic HTTP responses, and rendering a static HTML portfolio complete with CSS stylesheets and assets.

##### ACCESS PROJECT MATERIALS HERE
##### PDF GUIDE: [CREATE YOUR FIRST DJANGO APPLICATION.pdf](https://github.com/user-attachments/files/32013897/1.CREATE.YOUR.FIRST.DJANGO.APPLICATION.pdf)
##### WATCH VIDEO WALKTHROUGH HERE: https://youtu.be/SbO1XAPduZw

1) Initial Setup via GitHub Codespaces.
   Create a new repository in GitHub (e.g., docker-image-for-django-application).
   Launch a Codespace on the main branch.
   Verify Python installation and install Django:
   Check Python version

   <PRE>python --version</PRE>

   Install Django framework
   <PRE>pip install django</PRE>


2) Create a Django Project.
   Create a project named portfolio. This will generate a standard directory structure.
   Initialize project

   <PRE>django-admin startproject portfolio</PRE>

   Understanding Pre-generated Files:
   settings.py: Central configuration for database, installed apps, security keys, and static files.
   
   urls.py: URL routing/traffic directory. Maps URLs to views.
   manage.py: Command-line utility for interacting with the project (running server, migrations).


3) Create Django App (website).
   Create a self-contained module within your project to handle specific features.
   Navigate into project directory.

   <PRE>cd portfolio</PRE>

   Create Django application.
   <PRE>python manage.py startapp website</PRE>

   Create app-specific urls.py.
   <PRE>touch website/urls.py</PRE>


4) Link App to Project.
   Open portfolio/settings.py, locate INSTALLED_APPS, and add 'website' to the list:
```
   INSTALLED_APPS = [
    ...,
    'website',
   ]
```

5) Test Basic HTTP Response.
   Modify website/views.py:
```
from django.shortcuts import HttpResponse

def home(request):
    return HttpResponse("Hello Learner")
```

   Configure website/urls.py:
```  
from django.urls import path
from . import views

urlpatterns = [
    path("", views.home, name="home"),
]
```

   Update project portfolio/urls.py to include the app URLs:
```
from django.urls import path, include

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include("website.urls")),
]
```

   Run the development server:
   Ensure you are in the directory with manage.py
   
   <PRE>python manage.py runserver</PRE>

   Follow the generated URL (usually http://127.0.0.1:8000/) to see "Hello Learner".


6) Create Static Portfolio Website (HTML Templates).
   Set up directory structure for HTML and static files (CSS, Images) within the website app:

   <PRE>cd website</PRE>
   <PRE>mkdir templates static</PRE>
   <PRE>touch templates/index.html</PRE>
   <PRE>mkdir static/websitefiles</PRE>

   Add HTML content to templates/index.html (refer to source provided in instructions for full HTML, ensure {% load static %} is used).
   Upload dependencies (style.css, EDITED_PIC.jpg) to static/websitefiles/.
   Update website/views.py to render the template:

```
from django.shortcuts import render

def home(request):
    return render(request, "index.html")
```

   Run server again and verify the full website renders.

   Save changes to Git:

   <PRE>git add .</PRE>
   <PRE>git commit -m "Django app ready for docker"</PRE>
   <PRE>git push</PRE>



## PHASE 2: CONTAINERIZING WITH MULTI-STAGE BUILD AND DISTROLESS DOCKER IMAGE

### INTRODUCTION
In this phase, you will learn how to optimize and secure your containerized Django application by leveraging Docker multi-stage builds and Google Container Tools' distroless base images (gcr.io/distroless/python3). 

In this phase, you will separate your build dependencies from your final execution environment, strip away unnecessary operating system shells and utilities to minimize attack surfaces, securely copy installed Python packages (/root/.local) and application source code into the distroless layer, configure environment variables (PATH and PYTHONPATH), and build a lightweight, production-ready container image.

##### ACCESS PROJECT MATERIALS HERE
##### PDF GUIDE: [CREATE A MULTI-STAGE BUILD AND DISTROLESS DOCKER IMAGE.pdf](https://github.com/user-attachments/files/32014139/2.CREATE.A.MULTI-STAGE.BUILD.AND.DISTROLESS.DOCKER.IMAGE.pdf)
##### WATCH VIDEO WALKTHROUGH HERE: https://youtu.be/GWAzzeYyqdM

1) Setup Dependencies.
   Create a requirements.txt file in the GitHub root directory to define required Python packages for the container environment.

   <PRE>touch requirements.txt</PRE>
   Inside requirements.txt, add:
```
   Django
   tzdata
```

2) Create Dockerfile.
   Create a file named Dockerfile in the root directory:

3) Build and Run Image

   Build the docker image
   <PRE>docker build .</PRE>

   Identify the image ID
   <PRE>docker images -a</PRE>

   Run container with Port Mapping (Host 8080 -> Container 8000)
   <PRE>docker run -p 8080:8000 -it <YOUR_IMAGE_ID></PRE>

   Access the application via the Codespaces browser on port 8080.


4) To optimize security and size, implement a multi-stage build using a Google Distroless image (Python 3 runtime, no shell).
   Update Dockerfile:
   Build your Docker image with a tag:

   <PRE>docker build -t portfolio-website .</PRE>

   Run the tagged image.
   <PRE>docker run -p 8080:8000 -it portfolio-website:latest</PRE>

5) Ensure data persistence by mounting a Docker volume.
   Create a volume:
   <PRE>docker volume create portfolio-storage</PRE>

   Inspect volume path (usually /var/lib/docker/volumes/...).
   <PRE>docker volume inspect portfolio-storage</PRE>

   Run container with volume mounted to /app.
   <PRE>docker run -d --mount source=portfolio-storage,target=/app portfolio-website:latest</PRE>

   Verify mount in running container.
   <PRE>docker ps</PRE>
   <PRE>docker inspect <CONTAINER_ID></PRE>



## PHASE 3: DESIGN KUBERNETES SERVICE NETWORKING FOR DJANGO APPLICATION AND MONITOR TRAFFIC WITH KUBESHARK

### INTRODUCTION
In this phase, you will master Kubernetes core networking concepts by deploying your distroless Django container within a Minikube cluster. 

You will configure multi-replica Deployments with auto-healing capabilities, establish service discovery using Pod labels and selectors, implement internal routing via ClusterIP, expose applications externally using NodePort and LoadBalancer services (alongside Minikube tunneling), route traffic using Kubernetes Ingress rules and the NGINX Ingress controller, and perform real-time packet inspection and observability using Kubeshark.

##### ACCESS PROJECT MATERIALS HERE
##### PDF GUIDE: [DESIGN KUBERNETES SERVICE NETWORKING FOR DJANGO APPLICATION.pdf](https://github.com/user-attachments/files/32324522/DESIGN.KUBERNETES.SERVICE.NETWORKING.FOR.DJANGO.APPLICATION.pdf)
##### WATCH VIDEO WALKTHROUGH HERE: https://youtu.be/P6_RC3kR6Ww

1) Start Minikube.

   <PRE>minikube start</PRE>
   <PRE>minikube status</PRE>

2) Clone your repo if you are using a local environment.

   <PRE>git clone repo-name</PRE>

3) Prepare docker Image for Minikube.
   Minikube cannot directly access local Docker Desktop images. You must build the image inside the Minikube environment.

   Point terminal CLI to Minikube's Docker daemon.
   <PRE>eval $(minikube docker-env)</PRE>

   Build image inside Minikube.
   <PRE>docker build -t portfolio-website:latest .</PRE>

4) Create a Deployment.
   Create django_deployment.yml (refer to instructions for full YAML) and apply:

   Apply deployment.
   <PRE>kubectl apply -f django_deployment.yml</PRE>

   Verify pods (ensure 2 replicas are running)
   <PRE>kubectl get pods -o wide</PRE>

5) Create NodePort Service (Internal/Dev Access).
   Create django_service.yml defining a NodePort service (port 30007).

   <PRE>kubectl apply -f django_service.yml</PRE>

   Verify Kubernetes services
   <PRE>kubectl get svc</PRE>

   Access via Tunnel (WSL/macOS):
   Because NodePort isn't directly routable on standard WSL/macOS setups, use Minikube's service helper:

   <PRE>minikube service django-app-service</PRE>
   Keep terminal open and access via the provided 127.0.0.1 URL.

6) Create LoadBalancer Service (External Access).
   Simulate production external access.
   Edit existing service:

   <PRE>kubectl edit svc django-app-service</PRE>
   Change type: NodePort to type: LoadBalancer.
   
   Start Minikube tunnel in a separate terminal:

   <PRE>minikube tunnel</PRE>

   Verify External IP assignment and test:

   <PRE>kubectl get svc</PRE>
   <PRE>curl EXTERNAL_IP</PRE>


7) Kubeshark is used for network traffic observability inside the cluster.
   Install Kubeshark.
   Export desired tag:

   <PRE>export TAG=v52.3.92</PRE>

   Apply Kubeshark Kubernetes manifests:
   <PRE>kubectl apply -f https://raw.githubusercontent.com/kubeshark/kubeshark/refs/tags/$TAG/manifests/complete.yaml</PRE>

8) Run Kubeshark.
   Port-forward dashboard

   <PRE>kubectl port-forward service/kubeshark-front 8899:80</PRE>
   Access dashboard at http://127.0.0.1:8899 to visualize real-time packet flow between LoadBalancer and Pods.

9) Cleanup.

   <PRE>kubectl delete -f https://raw.githubusercontent.com/kubeshark/kubeshark/refs/tags/$TAG/manifests/complete.yaml</PRE>

10) Implement Kubernetes Ingress.
    Implement host-based routing.
    Enable Ingress Controller:

    <PRE>minikube addons enable ingress</PRE>

    Verify controller pods are running:
   
    <PRE>kubectl get pods -n ingress-nginx</PRE>

11) Create Ingress Rule.
    Create django_host_ingress.yml defining routing for host foo.bar.com on path /bar.
    Apply Ingress rule:

    <PRE>kubectl apply -f django_host_ingress.yml</PRE>

    Verify address assignment (may take a minute):
   
    <PRE>kubectl get ingress</PRE>


12) Local DNS Testing (By-passing DNS).
    Update your host machine's hosts file to map the Ingress Controller IP to foo.bar.com.

    View current hosts:
    
    <PRE>sudo cat /etc/hosts</PRE>

    Edit hosts file:
   
    <PRE>sudo vim /etc/hosts</PRE>

    Add a line:
    <PRE>INGRESS_CONTROLLER_IP foo.bar.com</PRE>

    Test connectivity (Note: success depends on network isolation setup in WSL/macOS):
    <PRE>ping foo.bar.com</PRE>



## PHASE 4: HOST A DJANGO APPLICATION ON A PRODUCTION KUBERNETES CLUSTER WITH OPENSHIFT

### INTRODUCTION
In this phase, you will deploy your containerized distroless Django application onto an enterprise Red Hat OpenShift Kubernetes cluster. 

You will authenticate CLI sessions via OpenShift tokens, push container images directly to OpenShift’s internal image registry (default-route-openshift-image-registry), diagnose and resolve CrashLoopBackOff errors triggered by distroless Python version mismatches and non-root Security Context Constraints (SCC), expose internal services via OpenShift Routes (oc expose), and manage Django static file serving across production environments.

Moving from Minikube to a production Red Hat OpenShift cluster requires stricter security and specific workflow changes, including authenticating with OpenShift's internal image registry.

##### ACCESS PROJECT MATERIALS HERE
##### PDF GUIDE: [HOST A DJANGO APPLICATION ON A PRODUCTION KUBERNETES CLUSTER WITH OPENSHIFT.pdf](https://github.com/user-attachments/files/32475456/HOST.A.DJANGO.APPLICATION.ON.A.PRODUCTION.KUBERNETES.CLUSTER.WITH.OPENSHIFT.pdf)
##### WATCH VIDEO WALKTHROUGH HERE: https://youtu.be/nSe7111hMIU


1) Login to OpenShift Cluster via CLI.
   Retrieve your login token from the OpenShift Web Console (Username -> Copy Login Command -> Display Token).

   Example login command:
   
   <PRE>oc login --token=sha256~YOUR_TOKEN --server=https://your-api-url:6443</PRE>

   Switch to your designated project/namespace:
   
   <PRE>oc project techdealer1000-dev</PRE>


2) Build Image Locally and Authenticate Docker.
   Ensure Docker Desktop is running. We will build the image locally and push it to OpenShift's registry.

   Clone the repository if not already present:
   
   <PRE>git clone https://github.com/Chinedu-Onyema/docker-image-for-django-application.git</PRE>
   <PRE>cd docker-image-for-django-application</PRE>

   Build the docker image:
   
   <PRE>docker build -t portfolio-website .</PRE>

   Authenticate local Docker daemon with OpenShift internal registry:
   
   <PRE>oc whoami -t | docker login -u unused --password-stdin default-route-openshift-image-registry.apps.your-cluster-domain.com</PRE>


3) Tag and Push Image to OpenShift Registry.
   You need your cluster domain and namespace to tag the image correctly.

   Tag your docker image for OpenShift Registry:
   
   <PRE>docker tag <local-image> default-route-openshift-image-registry.<cluster-domain>/<namespace>/<image-name></PRE>
   <PRE>docker tag portfolio-website default-route-openshift-image-registry.apps.rm1.0a51.p1.openshiftapps.com/techdealer1000-dev/portfolio-website</PRE>

   Push the docker image:
   
   <PRE>docker push default-route-openshift-image-registry.apps.rm1.0a51.p1.openshiftapps.com/techdealer1000-dev/portfolio-website</PRE>

   Confirm image stream exists in OpenShift:
   
   <PRE>oc get imagestreams your-namespace</PRE>


4) Deploy to OpenShift.
   Create django_openshift_deployment.yml.
   The image path must point to the internal registry path obtained in the previous step.

   <PRE>kubectl apply -f django_openshift_deployment.yml</PRE>

5) Debugging Openshift Security (NON-ROOT) and Static Files.
   Upon deployment to OpenShift, Pods may enter CrashLoopBackOff or render without static files (images/CSS).
   This phase addresses these common production issues.

   Debugging CrashLoopBackOff (Python Version Mismatch)
   Unlike standard Kubernetes environments, Distroless images on OpenShift require precise synchronization between the build environment and the runtime environment.

   Issue: <PRE>kubectl logs your-pod-name</PRE> shows Cannot import django.
   This often happens if the builder stage in the multi-stage Dockerfile uses a different Python minor version than the final Distroless runtime.

   Solution: Check the Distroless runtime version and update the Dockerfile

   Check runtime Python version in Distroless
   <PRE>docker run --rm --entrypoint python3 gcr.io/distroless/python3 --version</PRE>

   Update Dockerfile (Example if runtime is Python 3.13):
```
   #### BEFORE
   FROM python:3.12-slim AS builder
   ...
   ENV PYTHONPATH=/root/.local/lib/python3.12/site-packages

   #### AFTER
   FROM python:3.13-slim AS builder
   ...
   ENV PYTHONPATH=/root/.local/lib/python3.13/site-packages
```


6) Fixing Security Context (Non-Root Enforcement).
   Issue: OpenShift enforces running containers as a non-root user (random UID).
   If dependencies were installed in /root/.local (as done in Phase 3), the OpenShift user cannot read them, causing startup failure.

   Solution: Re-write Dockerfile to install dependencies in a non-root accessible directory (e.g., /install) and modify PYTHONPATH.

   Updated Dockerfile for OpenShift:
```
   #### STAGE 1: BUILD
   FROM python:3.13-slim AS builder
   WORKDIR /app
   COPY requirements.txt /app

   #### Install to a specific, non-root target directory
   RUN pip install --no-cache-dir --target=/install -r requirements.txt

   #### STAGE 2: PRODUCTION
   FROM gcr.io/distroless/python3
   WORKDIR /app

   #### Copy from build stage
   COPY --from=builder /install /install
   COPY portfolio /app

   #### Set PYTHONPATH to the new directory
   ENV PYTHONPATH=/install

   CMD ["manage.py", "runserver", "0.0.0.0:8000"]
```


7) Rebuild, repush, and restart deployment:

   <PRE>docker build --no-cache -t portfolio-website:latest .</PRE>
   ... (tag and push commands) ...
   <PRE>kubectl rollout restart deployment django-openshift-app-deployment</PRE>


8) Exposing via OpenShift Route.
   Due to cluster restrictions on free tiers, LoadBalancer services may not work. Use OpenShift Routes.
   Ensure a ClusterIP service exists (django_openshift_service.yml).
   Expose the service:

   <PRE>oc expose service django-app-service</PRE>
   <PRE>oc get route django-app-service</PRE>
   Access the application via the generated Hostname URL.


9) Debugging Missing Static Files (DEBUG Mode).
   Issue: Application loads, but images and CSS are missing.
   Reason: In production conditions (DEBUG=False in settings.py), Django's runserver does not serve static files.

   Solution (for development/test on OpenShift): Change DEBUG=True in portfolio/settings.py.
   Note: For true production, a production WSGI server (Gunicorn) and static file server (Nginx) are required.

   settings.py
   ```
   DEBUG = True
   ALLOWED_HOSTS = ['*']    #### Required when debugging on a generated route
   ```
   Rebuild, repush, and restart deployment one final time to see the fully rendered site.
   

## PHASE 5: GITOPS WITH ARGO CD FOR A DJANGO APPLICATION

### INTRODUCTION
In this phase, you will implement a declarative, automated Continuous Delivery using GitOps principles and Argo CD for your containerized Django application. 

You will provision Argo CD within a dedicated Minikube namespace (argocd), expose the Argo CD API server (argocd-server) via NodePort services, retrieve and decode administrative secrets for UI access, build Git-commit-tagged distroless images to enforce dynamic image tracking in manifest files, automate authentication via GitHub Personal Access Tokens (PAT), and register declarative application synchronization rules using both the Argo CD Web UI and the Argo CD CLI (argocd app create).

##### ACCESS PROJECT MATERIALS HERE
##### PDF GUIDE: [GITOPS WITH ARGO CD FOR DJANGO APPLICATION.pdf](https://github.com/user-attachments/files/33891688/5.GITOPS.WITH.ARGO.CD.FOR.DJANGO.APPLICATION.pdf)
##### WATCH VIDEO WALKTHROUGH HERE: https://youtu.be/b2FSwqro_4s

1) Install Argo CD in Minikube.
   Start your local Kubernetes cluster and install the Argo CD core components inside a dedicated namespace:
   Check Minikube status and start if stopped.

   <PRE>minikube status</PRE>
   <PRE>minikube start</PRE>

   Create the dedicated argocd namespace:
   
   <PRE>kubectl create namespace argocd</PRE>

   Apply official Argo CD manifests:

   <PRE>kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml</PRE>

   Verify that all control plane components are running:

   <PRE>kubectl get pods -n argocd</PRE>

2) Expose and Access the Argo CD Web UI.
   Expose the `argocd-server` service, retrieve the initial admin password, and log in to the management console:
   Change the argocd-server service type from ClusterIP to NodePort:
   
   <PRE>kubectl edit svc argocd-server -n argocd</PRE>
   Locate 'type: ClusterIP' and update it to 'type: NodePort'

   Launch the Minikube service tunnel (keep this terminal window open)
   <PRE>minikube service argocd-server -n argocd</PRE>

   Open a second terminal window to extract and decode the initial administrator password:

   Retrieve the encoded secret:
   
   <PRE>kubectl get secret -n argocd</PRE>

   Decode the admin password

   <PRE>kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode; echo</PRE>

   Username: `admin`
   Password: *(Decoded output from above command)*

3) Prepare Application Manifests and Git Repository.
   Structure your GitHub repository (`docker-image-for-django-application`) to store plain Kubernetes YAML manifests for declarative synchronization:
   Create a directory named `argocd` in your repository root:
   
   <PRE>mkdir argocd && cd argocd</PRE>

   Create `django_deployment.yml`:
   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: django-argocd-app-deployment
     labels:
       app: django-argocd-app
   spec:
     replicas: 2
     selector:
       matchLabels:
         app: django-argocd-app
     template:
       metadata:
         labels:
           app: django-argocd-app
       spec:
         containers:
         - name: django-argocd-application
           image: portfolio-website:latest
           imagePullPolicy: Never
           ports:
           - containerPort: 8000
   ```

 Create `django_service_deployment.yml`:
   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: django-argocd-app-service
   spec:
     selector:
       app: django-argocd-app
     ports:
       - port: 80
         targetPort: 8000
   ```

4) Configure Application Environment and Image Versioning.
   To ensure unique image identifiers for each Git commit.
   Configure local shell to use Minikube's Docker daemon:

   <PRE>eval $(minikube docker-env)</PRE>

   Extract short SHA tag from latest Git commit:

   <PRE>TAG=$(git rev-parse --short HEAD)</PRE>

   Build distroless image tagged with commit SHA inside Minikube:

   <PRE>docker build -t portfolio-website:$TAG .</PRE>

   Update deployment manifest dynamically with the newly built commit tag:

   <PRE>cd argocd</PRE>
   <PRE>sed -i "s|image: portfolio-website:.*|image: portfolio-website:$TAG|" django_deployment.yml</PRE>
   <PRE>cd ..</PRE>

   Commit and push updated deployment manifests back to GitHub:
   <PRE>git config --global user.email "onyemachinedu45@gmail.com"</PRE>
   <PRE>git config --global user.name "Chinedu Onyema"</PRE>
   <PRE>git add .</PRE>
   <PRE>git commit -m "Deploy $TAG"</PRE>
   <PRE>git push origin main</PRE>

5) Deploy via Argo CD UI.
   Open the Argo CD UI in your browser.

   Click New App and configure:
   Application Name: `plain-argocd-yaml-deployment`
   Project Name: `default`
   Sync Policy: `Automatic`
   Repository URL: `[https://github.com/Chinedu-Onyema/docker-image-for-django-application.git](https://github.com/Chinedu-Onyema/docker-image-for-django-application.git)`
   Path: `argocd`
   Cluster URL: `[https://kubernetes.default.svc](https://kubernetes.default.svc)`
   Namespace: `argocd`

   Click Create. Argo CD will pull manifests from Git and reconcile the cluster state.

6) Deploy via Argo CD CLI.
   Alternatively, install and use the Argo CD CLI to manage deployments declaratively.
   Download and install Argo CD CLI:

   <PRE>curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64</PRE>
   <PRE>sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd</PRE>

   Authenticate with Argo CD server:

   <PRE>argocd login 127.0.0.1:36549 --username admin --password <your-decoded-password> --insecure</PRE>

   Create application via CLI:
```
   argocd app create plain-argocd-yaml-deployment \
  --repo https://github.com/Chinedu-Onyema/docker-image-for-django-application.git \
  --path argocd \
  --dest-namespace argocd \
  --dest-server https://kubernetes.default.svc \
  --directory-recurse \
  --sync-policy automated
```

   Inspect sync status and cluster resources.
   argocd app get plain-argocd-yaml-deployment:
   
   <PRE>kubectl get pods -n argocd</PRE>


## PHASE 6: DESIGN AND AUTOMATE GITOPS FOR CONTINUOUS DELIVERY (CD) WITH GITHUB ACTIONS AND ARGO CD FOR A DJANGO APPLICATION

### INTRODUCTION
In this phase, you will design and execute a fully automated, hands-off Continuous Delivery (CD) pipeline by integrating GitHub Actions CI/CD workflows with Argo CD GitOps reconciliation. 

You will replace manual deployment steps with an automated bash automation script (deploy.sh), build and push Git-SHA-tagged container images directly to Docker Hub (DOCKERHUB_USERNAME/portfolio-website:TAG), manage workflow authentication using encrypted GitHub Repository Secrets (DOCKERHUB_USERNAME, DOCKERHUB_TOKEN), configure workflow elevated write permissions (GITHUB_TOKEN), and automatically trigger deployment manifest updates (django_deployment.yml) that Argo CD detects and continuously syncs to active Kubernetes workloads.

##### ACCESS PROJECT MATERIALS HERE
##### PDF GUIDE: [DESIGN AND AUTOMATE GITOPS FOR CONTINUOUS DELIVERY.pdf](https://github.com/user-attachments/files/33892450/6.DESIGN.AND.AUTOMATE.GITOPS.FOR.CONTINUOUS.DELIVERY.pdf)
##### WATCH VIDEO WALKTHROUGH HERE: https://youtu.be/mjSw4C3A6gg


1) Create Automated Build and Deployment Script (deploy.sh).
   In your repository root (docker-image-for-django-application), create a script to automate Docker image builds, tag assignment based on Git commit SHAs, remote registry pushes, and deployment manifest updates:
   Pull latest code from GitHub:
   
   <PRE>git pull origin main</PRE>

   Create a deploy.sh script:
```   
   cat << 'EOF' > deploy.sh
   #!/bin/bash
   set -e
   git pull origin main
   DOCKERHUB_USERNAME="edunaking"
   TAG=$(git rev-parse --short HEAD)
   docker build -t $DOCKERHUB_USERNAME/portfolio-website:$TAG .
   docker push $DOCKERHUB_USERNAME/portfolio-website:$TAG
   <PRE>sed -i "s|image: .*/portfolio-website:.*|image: $DOCKERHUB_USERNAME/portfolio-website:$TAG|" argocd/django_deployment.yml
   Stage, commit, and push updated deployment manifest back to GitHub:
   git add argocd/django_deployment.yml
   git commit -m "Deploy new tag $TAG to argocd [skip ci]" || exit 0
   git push origin main
   EOF
```
   Grant execution permissions:
   
   <PRE>chmod +x deploy.sh</PRE>

2) Configure GitHub Actions Workflow (`.github/workflows/argocd_deployment.yml`).
   Create the automation workflow file inside `.github/workflows/` to handle continuous delivery triggers upon code pushes to the `main` branch:
```bash
mkdir -p .github/workflows
cat << 'EOF' > .github/workflows/argocd_deployment.yml
name: Continuous Deployment with GitHub Actions & Argo CD
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Configure Git Identity
        run: |
          git config --global user.email "actions@github.com"
          git config --global user.name "GitHub Actions"

      - name: Log in to Docker Hub
        run: |
          echo "${{ secrets.DOCKERHUB_TOKEN }}" | docker login -u ${{ secrets.DOCKERHUB_USERNAME }} --password-stdin

      - name: Run Deploy Script
        run: |
          chmod +x deploy.sh
          ./deploy.sh
EOF
```

3) Configure Repository Secrets and Workflow Permissions in GitHub.
   Generate Docker Hub Access Token:
   Log in to Docker Hub, Account Settings, Personal Access Tokens and Generate New Token.
   Description: `for GitHub Actions automatic deployment to ArgoCD`.
   Permissions: `Read & Write`.

   Set Repository Secrets in GitHub:
   Navigate to GitHub Repository, Settings, Secrets and variables, Actions and New repository secret.
   Add `DOCKERHUB_USERNAME`: Your Docker Hub account username (e.g., `edunaking`).
   Add `DOCKERHUB_TOKEN`: The Personal Access Token generated from Docker Hub.

   Grant Workflow Write Permissions:
   Go to Settings, Actions, General and Workflow permissions.
   Select Read and write permissions and click Save.

4) Configure Automated Application Sync in Argo CD.
   Launch your local cluster and open the Argo CD console:
   
   <PRE>minikube start</PRE>
   <PRE>minikube service argocd-server -n argocd</PRE>

   In the Argo CD Web UI, create a new application named `automated-django-deployment`:
   Project: `default`
   Sync Policy: `Automatic` (Enables automated cluster state reconciliation)
   Repository URL: `[https://github.com/Chinedu-Onyema/docker-image-for-django-application.git](https://github.com/Chinedu-Onyema/docker-image-for-django-application.git)`
   Path: `argocd`
   Cluster URL: `[https://kubernetes.default.svc](https://kubernetes.default.svc)`
   Namespace: `argocd`

5) Verify End-to-End Automated Pipeline Execution.
   Make a source code change in your local repository (e.g., updating Django settings or static views):
   
   <PRE>git pull origin main</PRE>
   <PRE>git add .</PRE>
   <PRE>git commit -m "Update Django application logic"</PRE>
   <PRE>git push origin main</PRE>

   Monitor GitHub Actions under the Actions tab to confirm the `deploy.sh` execution successfully builds, tags, pushes the image to Docker Hub, and updates `django_deployment.yml`.

   Observe Argo CD automatically detect the Git update and roll out the new image tag to your cluster pods without manual intervention:
   
   <PRE>kubectl get pods -n argocd</PRE>
   <PRE>minikube service django-argocd-app-service -n argocd</PRE>
   
   Embed a live build status badge in your project `README.md` via GitHub Actions (Create status badge).
