# Storefront Reference Architecture deployment Dockerfile

# Source of image
FROM node:12
LABEL maintainer="Oleg Sapishchuk"
LABEL license="MIT"

# Install packages and update
RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y rsync zip

# Build variables
ARG GITHUBLOGIN
ARG GITHUBTOKEN
ARG SANDBOXNAME
ARG SFCCLOGIN
ARG SFCCPWD
ARG SFCCCODEVERSION="code"
ARG SFCCAPIKEY
ARG SFCCAPISECRET
ARG USNO="us01"

#Build Salesforce Commerce Cloud working folder
RUN mkdir home/sfcc
WORKDIR /home/sfcc

# Pull & Build SFRA code
# Prepare dw.json for Prophet plugin
# Package code in the zip bundle
RUN git clone https://"${GITHUBLOGIN}":"${GITHUBTOKEN}"@github.com/SalesforceCommerceCloud/storefront-reference-architecture \
&& cd storefront-reference-architecture \
&& npm install \
&& npm run compile:js \
&& npm run compile:scss \
&& npm run compile:fonts \
&& echo "{" \
        "\"hostname\":\"${SANDBOXNAME}.sandbox.${USNO}.dx.commercecloud.salesforce.com\"," \
        "\"username\":\"${SFCCLOGIN}\"," \
        "\"password\":\"${SFCCPWD}\"," \
        "\"code-version\":\"${SFCCCODEVERSION}\"" \
        "}" > dw.json \
&& mkdir -p tmp/code \
&& cp -R cartridges/* tmp/code \
&& cd tmp \
&& zip -r -q code.zip code \
&& rm -r code

# Pull and Zip SFRA data
RUN git clone https://"${GITHUBLOGIN}":"${GITHUBTOKEN}"@github.com/SalesforceCommerceCloud/storefrontdata \
&& cd storefrontdata && npm run zipData

# Pull and Install SFCC CLI
RUN git clone https://"${GITHUBLOGIN}":"${GITHUBTOKEN}"@github.com/SalesforceCommerceCloud/sfcc-ci \
&& cd sfcc-ci && npm install -g


# Deploy code to instance
RUN sfcc-ci client:auth "${SFCCAPIKEY}" "${SFCCAPISECRET}" \
&& cd storefront-reference-architecture \
&& sfcc-ci code:deploy tmp/code.zip -i "${SANDBOXNAME}.sandbox.us02.dx.commercecloud.salesforce.com" \
&& sfcc-ci code:activate code -i "${SANDBOXNAME}.sandbox.us02.dx.commercecloud.salesforce.com"

# Deploy data to instance
RUN sfcc-ci client:auth "${SFCCAPIKEY}" "${SFCCAPISECRET}" \
&& cd storefrontdata \
&& sfcc-ci instance:upload demo_data_sfra.zip -i "${SANDBOXNAME}.sandbox.us02.dx.commercecloud.salesforce.com" \
&& sfcc-ci instance:import demo_data_sfra.zip -i "${SANDBOXNAME}.sandbox.us02.dx.commercecloud.salesforce.com" -s

# Reindex site and rebuild urls
RUN sfcc-ci client:auth "${SFCCAPIKEY}" "${SFCCAPISECRET}" \
&& sfcc-ci job:run Reindex --instance "${SANDBOXNAME}.sandbox.us02.dx.commercecloud.salesforce.com" --sync --json \
&& sfcc-ci job:run RebuildURLs --instance "${SANDBOXNAME}.sandbox.us02.dx.commercecloud.salesforce.com" --sync --json

# this command will confirm node was installed correctly, and fail out if the command fails
CMD [ "node" ]
