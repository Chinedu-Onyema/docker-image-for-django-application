#!/bin/bash
set -e                                                # avoid silent failures

git pull origin main                                   # to sync changes made in two different
                                                       # environments together GitHub and git
                                                       # to allow for uniformity

DOCKERHUB_USERNAME="edunaking"           # replace with your dockerhub username 
                                                       # for example edunaking


TAG=$(git rev-parse --short HEAD)                      # use the TAG environment variable to tag 
                                                       # your latest git commit  


docker build -t $DOCKERHUB_USERNAME/portfolio-website:$TAG .     # build and tag your django app image name
                                                                 # with the latest git commit id

docker push $DOCKERHUB_USERNAME/portfolio-website:$TAG           # push your django app image name to dockerhub


# after every new git commit, use the latest git commit id and tag it to the django_deployment.yml file 
sed -i "s|image: .*/portfolio-website:.*|image: $DOCKERHUB_USERNAME/portfolio-website:$TAG|" argocd/django_deployment.yml

git add django_deployment.yml                      # add only the django_deployment.yml file
git commit -m "Deploy new tag to argocd"           # commit the changes made above 
git push                                           # push changes to GitHub