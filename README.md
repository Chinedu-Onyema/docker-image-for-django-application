# Building and Containerizing Your First Django Application: From Development to Kubernetes

## PROJECT OVERVIEW

This comprehensive guide is designed for developers and DevOps engineers taking their first steps into the Python web ecosystem. This project is not just about writing code; it is a holistic journey through the modern software development lifecycle (SDLC).

We start by exploring the Django Framework. Django is a high-level Python web framework that encourages rapid development and clean, pragmatic design.
Written by experienced developers, it takes care of much of the hassle of web development, so you can focus on writing your app without needing to reinvent the wheel. It follows the "Batteries Included" philosophy, providing built-in tools for user authentication, database management, admin interfaces, and security right out of the box. Top-tier organizations like Instagram, Spotify, and Dropbox rely on Django to handle their scalability and security needs.

In the first phase of this guide, you will build a foundational Django application, transitioning from a simple "Hello World" HTTP response to rendering a full, static HTML portfolio website.

However, building the application is only half the battle. Modern software needs to run reliably across different environments—from a developer's laptop to production cloud clusters. To achieve this, we will move into Containerization with Docker. You will learn to write a Dockerfile, create efficient multi-stage builds, and utilize Google's Distroless images to create a secure, minimal production image that only contains your application and its dependencies—no shell, no package manager, just your code.

Finally, to ensure high availability, scalability, and resilience, we will dive into Orchestration with Kubernetes. Using Minikube, you will deploy your containerized Django app, design advanced Service networking (ClusterIP, NodePort, LoadBalancer), implement Ingress routing rules, and monitor live cluster traffic using Kubeshark.


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


4) Create Django App (website)

   I) Create a self-contained module within your project to handle specific features.

   #### Navigate into project directory
   <PRE>cd portfolio</PRE>

   #### Create application
   <PRE>python manage.py startapp website</PRE>

   #### Create app-specific urls.py
   <PRE>touch website/urls.py</PRE>


5) Link App to Project

   I) Open portfolio/settings.py, locate INSTALLED_APPS, and add 'website' to the list:
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

   III) Upload dependencies (7_style.css, 7_EDITED_PIC.jpg) to static/websitefiles/.

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
