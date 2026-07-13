# STAGE 1: BUILD STAGE
#------------------------------------------------------
# Install python dependencies using 
# python slim 3.14 version as the base image
# builder is an alias for python slim 3.14 version
# which will be referenced in the final image build
#------------------------------------------------------
FROM python:3.14-slim AS builder

#------------------------------------------------------
# Set the working directory in the docker image

WORKDIR /app

#-------------------------------------------------------

# Copy the requirements.txt file to the 
# docker image file system dependencies file

COPY requirements.txt /app

#--------------------------------------------------------

# install all the dependencies stated inside this file
# for your django application to function.
# --user installs the dependencies to /root/.local folder 
# instead of /usr/local/lib/ general system python folder.
# this keeps all dependencies in one single directory 
# --no-cache-dir means don't save a cache of the downloaded packages. 
# Normally pip saves a cache in case you need to reinstall later 
# but inside a Docker image you'll never reinstall, 
# so the cache is just wasted space. This keeps the image smaller.

RUN pip install --user --no-cache-dir -r requirements.txt


# STAGE 2: CREATE THE DISTROLESS IMAGE
#------------------------------------------------------------
# Only copy what is needed to run the app
# A minimal docker image with only Python 3 installed 
# no shell, no OS tools, nothing else.

FROM gcr.io/distroless/python3

#--------------------------------------------------------------

# Set working directory in the docker image

WORKDIR /app

#--------------------------------------------------------------

# Copy the installed Python packages from the 
# /root/.local directory from the build stage called builder
# to the /root/.local directory in the distroless image 

COPY --from=builder /root/.local /root/.local

#---------------------------------------------------------------

# Copy Django application code dependencies 
# to the docker image file system

COPY portfolio /app

#----------------------------------------------------------------

# Make sure Python finds the installed packages
# in the /root/.local directory you specified using
# environmental variables


ENV PATH=/root/.local/bin:$PATH
ENV PYTHONPATH=/root/.local/lib/python3.14/site-packages

#-----------------------------------------------------------------

# start the Django application by executing the
# the manage.py file to start our application
# manage.py is used because we are running a django app
# the django app runs on port 8000

CMD ["manage.py", "runserver", "0.0.0.0:8000"]