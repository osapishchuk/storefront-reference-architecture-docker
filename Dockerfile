# Storefront Reference Architecture deployment Dockerfile

# source of image
FROM node:12

# install packages and update
RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y rsync zip

# fetch our deploy script and make it executable
# todo add deploy script and data to execute

# this command will confirm node was installed correctly, and fail out if the command fails
CMD [ "node" ]