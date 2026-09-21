# Building, Containerizing & Deploying A Django Application: From Development to Kubernetes

## OVERVIEW

This comprehensive guide is designed for developers and DevOps engineers taking their first steps into the Python web ecosystem. This project is not just about writing code; it is a holistic journey through the modern software development lifecycle (SDLC).

We start by exploring the Django Framework. Django is a high-level Python web framework that encourages rapid development and clean, pragmatic design.
Written by experienced developers, it takes care of much of the hassle of web development, so you can focus on writing your app without needing to reinvent the wheel. It follows the "Batteries Included" philosophy, providing built-in tools for user authentication, database management, admin interfaces, and security right out of the box. Top-tier organizations like Instagram, Spotify, and Dropbox rely on Django to handle their scalability and security needs.

In the first phase of this guide, you will build a foundational Django application, transitioning from a simple "Hello World" HTTP response to rendering a full, static HTML portfolio website.

However, building the application is only half the battle. Modern software needs to run reliably across different environments, for example, from a developer's laptop to production cloud clusters. To achieve this, we will move into Containerization with Docker. You will learn to write a Dockerfile, create efficient multi-stage builds, and utilize Google's Distroless images to create a secure, minimal production image that only contains your application and its dependencies, no shell, no package manager, just your code.

To ensure high availability, scalability, and resilience, we will dive into Orchestration with Kubernetes. Using a development Kubernetes environment like Minikube, you will deploy your containerized Django app, design advanced Service networking (ClusterIP, NodePort, LoadBalancer), implement Ingress routing rules, and monitor live cluster traffic using Kubeshark.

Finally, you will deploy and debug (CrashLoopBackOff) your containerized Django application and implement advanced networking in a production Kubernetes environment using OpenShift.


## ACCESS PROJECT MATERIALS HERE

### 1) CREATE YOUR FIRST DJANGO APPLICATION
#### PDF GUIDE: [CREATE YOUR FIRST DJANGO APPLICATION.pdf](https://github.com/user-attachments/files/32013897/1.CREATE.YOUR.FIRST.DJANGO.APPLICATION.pdf)
#### WATCH VIDEO WALKTHROUGH HERE: https://youtu.be/SbO1XAPduZw


### 2) CREATE A MULTI-STAGE BUILD AND DISTROLESS DOCKER IMAGE
#### PDF GUIDE: [CREATE A MULTI-STAGE BUILD AND DISTROLESS DOCKER IMAGE.pdf](https://github.com/user-attachments/files/32014139/2.CREATE.A.MULTI-STAGE.BUILD.AND.DISTROLESS.DOCKER.IMAGE.pdf)
#### WATCH VIDEO WALKTHROUGH HERE: https://youtu.be/GWAzzeYyqdM


### 3) DESIGN KUBERNETES SERVICE NETWORKING FOR DJANGO APPLICATION
#### PDF GUIDE: [DESIGN KUBERNETES SERVICE NETWORKING FOR DJANGO APPLICATION.pdf](https://github.com/user-attachments/files/32324522/DESIGN.KUBERNETES.SERVICE.NETWORKING.FOR.DJANGO.APPLICATION.pdf)
#### WATCH VIDEO WALKTHROUGH HERE: https://youtu.be/P6_RC3kR6Ww


### 4) DEBUG & DEPLOY DJANGO APPLICATION TO PRODUCTION KUBERNETES CLUSTER WITH OPENSHIFT
#### PDF GUIDE: [HOST A DJANGO APPLICATION ON A PRODUCTION KUBERNETES CLUSTER WITH OPENSHIFT.pdf](https://github.com/user-attachments/files/32475456/HOST.A.DJANGO.APPLICATION.ON.A.PRODUCTION.KUBERNETES.CLUSTER.WITH.OPENSHIFT.pdf)
#### WATCH VIDEO WALKTHROUGH HERE: https://youtu.be/nSe7111hMIU


## Phase 1: Creating Your First Django Application

1) Initial Setup via GitHub Codespaces

   I) Create a new repository in GitHub (e.g., docker-image-for-django-application).

   II) Launch a Codespace on the main branch.

   III) Verify Python installation and install Django:

   #### Check Python version
   <PRE>python --version</PRE>

   #### Install Django framework
   <PRE>pip install django</PRE>


2) Create Django Project

   I) Create a project named portfolio. This will generate a standard directory structure.

   #### Initialize project
   <PRE>django-admin startproject portfolio</PRE>

   II) Understanding Pre-generated Files:

   settings.py: Central configuration for database, installed apps, security keys, and static files.
   
   urls.py: URL routing/traffic directory. Maps URLs to views.

   manage.py: Command-line utility for interacting with the project (running server, migrations).


3) Create Django App (website)
   Create a self-contained module within your project to handle specific features.

   #### Navigate into project directory
   <PRE>cd portfolio</PRE>

   #### Create application
   <PRE>python manage.py startapp website</PRE>

   #### Create app-specific urls.py
   <PRE>touch website/urls.py</PRE>


4) Link App to Project
   Open portfolio/settings.py, locate INSTALLED_APPS, and add 'website' to the list:
   ```
   INSTALLED_APPS = [
    ...,
    'website',
   ]
   ```


5) Test Basic HTTP Response

I) Modify website/views.py:
```
from django.shortcuts import HttpResponse

def home(request):
    return HttpResponse("Hello Learner")
```

II) Configure website/urls.py:
```
from django.urls import path
from . import views

urlpatterns = [
    path("", views.home, name="home"),
]
```

III) Update project portfolio/urls.py to include the app URLs:
```
from django.urls import path, include

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include("website.urls")),
]
```

IV) Run the development server:

  #### Ensure you are in the directory with manage.py
  <PRE>python manage.py runserver</PRE>

  Follow the generated URL (usually http://127.0.0.1:8000/) to see "Hello Learner".


6) Create Static Portfolio Website (HTML Templates)
   
I) Set up directory structure for HTML and static files (CSS, Images) within the website app:

   <PRE>cd website</PRE>
   <PRE>mkdir templates static</PRE>
   <PRE>touch templates/index.html</PRE>
   <PRE>mkdir static/websitefiles</PRE>

II) Add HTML content to templates/index.html (refer to source provided in instructions for full HTML, ensure {% load static %} is used).

III) Upload dependencies (style.css, EDITED_PIC.jpg) to static/websitefiles/.

IV) Update website/views.py to render the template:

```
from django.shortcuts import render

def home(request):
    return render(request, "index.html")
```

V) Run server again and verify the full website renders.

VI) Save changes to Git:

   <PRE>git add .</PRE>
   <PRE>git commit -m "Django app ready for docker"</PRE>
   <PRE>git push</PRE>



## Phase 2: Containerizing with Docker

1) Setup Dependencies
   Create a requirements.txt file in the GitHub root directory to define required Python packages for the container environment.

   <PRE>touch requirements.txt</PRE>
   Inside requirements.txt, add:
```
   Django
   tzdata
```


2) Create Dockerfile
   Create a file named Dockerfile in the root directory:


3) Build and Run Image

   #### Build image
   <PRE>docker build .</PRE>

   #### Identify image ID
   <PRE>docker images -a</PRE>

   #### Run container with Port Mapping (Host 8080 -> Container 8000)
   <PRE>docker run -p 8080:8000 -it <YOUR_IMAGE_ID></PRE>
   Access the application via the Codespaces browser on port 8080.



## Phase 3: Multi-Stage Builds & Distroless Images
To optimize security and size, implement a multi-stage build using a Google Distroless image (Python 3 runtime, no shell)

1) Update Dockerfile:

2) Build your Docker image with a tag:

   <PRE>docker build -t portfolio-website .</PRE>

   #### Run tagged image
   <PRE>docker run -p 8080:8000 -it portfolio-website:latest</PRE>


## Phase 4: Docker Volumes for Persistent Storage

1) Ensure data persistence by mounting a Docker volume.

   #### Create volume
   <PRE>docker volume create portfolio-storage</PRE>

   #### Inspect volume path (usually /var/lib/docker/volumes/...)
   <PRE>docker volume inspect portfolio-storage</PRE>

   #### Run container with volume mounted to /app
   <PRE>docker run -d --mount source=portfolio-storage,target=/app portfolio-website:latest</PRE>

   #### Verify mount in running container
   <PRE>docker ps</PRE>
   <PRE>docker inspect <CONTAINER_ID></PRE>


## Phase 5: Kubernetes Service Networking for Django
Note: Steps 1-2 assume a local environment with Docker Desktop and Minikube installed.

1) Start Minikube

   <PRE>minikube start</PRE>
   <PRE>minikube status</PRE>

2) Clone your repo if using local environment

   <PRE>git clone repo-name</PRE>

3) Prepare Image for Minikube
   Minikube cannot directly access local Docker Desktop images. You must build the image inside the Minikube environment.

   #### Point terminal CLI to Minikube's Docker daemon
   <PRE>eval $(minikube docker-env)</PRE>

   #### Build image inside Minikube
   <PRE>docker build -t portfolio-website:latest .</PRE>

4) Create Deployment
   Create django_deployment.yml (refer to instructions for full YAML) and apply:

   #### Apply deployment
   <PRE>kubectl apply -f django_deployment.yml</PRE>

   #### Verify pods (ensure 2 replicas are running)
   <PRE>kubectl get pods -o wide</PRE>


5) Create NodePort Service (Internal/Dev Access)

   I) Create django_service.yml defining a NodePort service (port 30007).

   <PRE>kubectl apply -f django_service.yml</PRE>

   #### Verify service
   <PRE>kubectl get svc</PRE>

   II) Access via Tunnel (WSL/macOS): Because NodePort isn't directly routable on standard WSL/macOS setups, use Minikube's service helper:

   <PRE>minikube service django-app-service</PRE>
   Keep terminal open and access via the provided 127.0.0.1 URL.


6) Create LoadBalancer Service (External Access)

   I) Simulate production external access.

   II) Edit existing service: kubectl edit svc django-app-service

   III) Change type: NodePort to type: LoadBalancer.

   IV) Start Minikube tunnel in a separate terminal:

   <PRE>minikube tunnel</PRE>

   V) Verify External IP assignment and test:

   <PRE>kubectl get svc</PRE>
   <PRE>curl EXTERNAL_IP</PRE>


## Phase 6: Monitoring Traffic with Kubeshark
Kubeshark is used for network traffic observability inside the cluster.

1) Install Kubeshark

   #### Export desired tag
   <PRE>export TAG=v52.3.92</PRE>

   #### Apply manifests
   <PRE>kubectl apply -f https://raw.githubusercontent.com/kubeshark/kubeshark/refs/tags/$TAG/manifests/complete.yaml</PRE>


2) Run Kubeshark
   #### Port-forward dashboard
   <PRE>kubectl port-forward service/kubeshark-front 8899:80</PRE>
   Access dashboard at http://127.0.0.1:8899 to visualize real-time packet flow between LoadBalancer and Pods.


3) Cleanup

   <PRE>kubectl delete -f https://raw.githubusercontent.com/kubeshark/kubeshark/refs/tags/$TAG/manifests/complete.yaml</PRE>


## Phase 7: Implementing Kubernetes Ingress

1) Implement host-based routing

2) Enable Ingress Controller

   <PRE>minikube addons enable ingress</PRE>

   #### Verify controller pods are running
   <PRE>kubectl get pods -n ingress-nginx</PRE>

3) Create Ingress Rule
   Create django_host_ingress.yml defining routing for host foo.bar.com on path /bar.

   #### Apply Ingress rule
   <PRE>kubectl apply -f django_host_ingress.yml</PRE>

   #### Verify address assignment (may take a minute)
   <PRE>kubectl get ingress</PRE>


4) Local DNS Testing (By-passing DNS)

   I) Update your host machine's hosts file to map the Ingress Controller IP to foo.bar.com.

   #### View current hosts
   <PRE>sudo cat /etc/hosts</PRE>

   #### Edit hosts file
   <PRE>sudo vim /etc/hosts</PRE>

   II) Add a line:
   <PRE>INGRESS_CONTROLLER_IP foo.bar.com</PRE>

   III) Test connectivity (Note: success depends on network isolation setup in WSL/macOS):
   <PRE>ping foo.bar.com</PRE>



## Phase 8: Hosting Django on Production OpenShift Cluster

Moving from Minikube to a production Red Hat OpenShift cluster requires stricter security and specific workflow changes, including authenticating with OpenShift's internal image registry.

1) Login to OpenShift Cluster via CLI
   Retrieve your login token from the OpenShift Web Console (Username -> Copy Login Command -> Display Token).

   #### Example login command
   <PRE>oc login --token=sha256~YOUR_TOKEN --server=https://your-api-url:6443</PRE>

   #### Switch to your designated project/namespace
   <PRE>oc project techdealer1000-dev</PRE>


2) Build Image Locally and Authenticate Docker
   Ensure Docker Desktop is running. We will build the image locally and push it to OpenShift's registry.

   #### Clone the repository if not already present
   <PRE>git clone https://github.com/Chinedu-Onyema/docker-image-for-django-application.git</PRE>
   <PRE>cd docker-image-for-django-application</PRE>

   #### Build the local image
   <PRE>docker build -t portfolio-website .</PRE>

   #### Authenticate local Docker daemon with OpenShift internal registry
   <PRE>oc whoami -t | docker login -u unused --password-stdin default-route-openshift-image-registry.apps.your-cluster-domain.com</PRE>


3) Tag and Push Image to OpenShift Registry
   You need your cluster domain and namespace to tag the image correctly.

   #### Tag image for OpenShift Registry
   #### Format: <PRE>docker tag <local-image> default-route-openshift-image-registry.<cluster-domain>/<namespace>/<image-name></PRE>
   <PRE>docker tag portfolio-website default-route-openshift-image-registry.apps.rm1.0a51.p1.openshiftapps.com/techdealer1000-dev/portfolio-website</PRE>

   #### Push image
   <PRE>docker push default-route-openshift-image-registry.apps.rm1.0a51.p1.openshiftapps.com/techdealer1000-dev/portfolio-website</PRE>

   #### Confirm image stream exists in OpenShift
   <PRE>oc get imagestreams your-namespace</PRE>


4) Deploy to OpenShift
   Create django_openshift_deployment.yml.
   The image path must point to the internal registry path obtained in the previous step.

   <PRE>kubectl apply -f django_openshift_deployment.yml</PRE>



## Phase 9: Debugging OpenShift Security (Non-Root) and Static Files

Upon deployment to OpenShift, Pods may enter CrashLoopBackOff or render without static files (images/CSS). 
This phase addresses these common production issues.

1) Debugging CrashLoopBackOff (Python Version Mismatch)
   Unlike standard Kubernetes environments, Distroless images on OpenShift require precise synchronization between the build environment and the runtime environment.

   Issue: <PRE>kubectl logs your-pod-name</PRE> shows Cannot import django.
   This often happens if the builder stage in the multi-stage Dockerfile uses a different Python minor version than the final Distroless runtime.

   Solution: Check the Distroless runtime version and update the Dockerfile

   #### Check runtime Python version in Distroless
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


2) Fixing Security Context (Non-Root Enforcement)
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


3) Rebuild, repush, and restart deployment:

   <PRE>docker build --no-cache -t portfolio-website:latest .</PRE>
   #### ... (tag and push commands) ...
   <PRE>kubectl rollout restart deployment django-openshift-app-deployment</PRE>


4) Exposing via OpenShift Route
   Due to cluster restrictions on free tiers, LoadBalancer services may not work. Use OpenShift Routes.

   I) Ensure a ClusterIP service exists (django_openshift_service.yml).

   II) Expose the service:

   <PRE>oc expose service django-app-service</PRE>
   <PRE>oc get route django-app-service</PRE>
   Access the application via the generated Hostname URL.


5) Debugging Missing Static Files (DEBUG Mode)
   Issue: Application loads, but images and CSS are missing.Reason: In production conditions (DEBUG=False in settings.py), Django's runserver does not serve static files.

   Solution (for development/test on OpenShift): Change DEBUG=True in portfolio/settings.py.
   Note: For true production, a production WSGI server (Gunicorn) and static file server (Nginx) are required.

   #### settings.py
   ```
   DEBUG = True
   ALLOWED_HOSTS = ['*']    #### Required when debugging on a generated route
   ```
   Rebuild, repush, and restart deployment one final time to see the fully rendered site.
   
