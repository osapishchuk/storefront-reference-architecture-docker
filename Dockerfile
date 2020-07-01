# Storefront Reference Architecture deployment Dockerfile

# source of image
FROM node:11

# install packages and update
RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y rsync zip

# TODO add bash script with all the steps from "Progress" section in readme

# this command will confirm node was installed correctly, and fail out if the command fails
CMD [ "node" ]