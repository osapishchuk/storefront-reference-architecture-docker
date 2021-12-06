# Storefront Reference Architecture (SFRA)
The open-source SFRA (Storefront Reference Architecture) docker image, made with love by Salesforce B2C Commerce community

## Installation guide

Automation added to dockerfile allows to build SFRA code, bundle it with data and push to your sandbox, reindexed it and build urls. Above can be done following this command which should run in the same folder as Dockerfile from this repository:

```bash
docker build --build-arg GITHUBLOGIN="TBC_YOUR_DATA"  \
--build-arg GITHUBTOKEN="TBC_YOUR_DATA"  \
--build-arg SFCCLOGIN="TBC_YOUR_DATA"  \
--build-arg SFCCPWD="TBC_YOUR_DATA"  \
--build-arg SFCCAPIKEY="TBC_YOUR_DATA"  \
--build-arg SFCCAPISECRET="TBC_YOUR_DATA"  \
--build-arg SANDBOXNAME="TBC_YOUR_DATA" .
```
> Please note that above data available during image build, after image is created, data above is not available from the instance scope. In the same time in order to make easy VSC code compatibility with Prophet plugin, we are creating dw.json that will contain your SFCC login, password and sandbox url data as part of the package. That data is sensitive.
> Please use analyze the impact before using this solution.

After you image is ready, run it in order to use with Visual Studio Code (VSC) with following command

```bash
docker run -t -i "CONTAINER_IMAGE_NAME"
```

> Before using prophet with 
After command above connect to running container using VSC and plugin [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers "Remote - Containers").

Recommendation is also to install (at least in the scope of the container) [Prophet plugin](https://marketplace.visualstudio.com/items?itemName=SqrTT.prophet "Prophet plugin"), which OOB will work as all required files were already generated and Prophet will be able to serve OOB all required capabilities.

## TODO
* Update readme with how to contribute to this repository
* Update readme with youtube reference with demo
* Update readme with medium link to blog with overview
* Update readme and introduce Gitflow with release management
* Update readme with examples on Azure ( or alternatives )
* Create gist script with example of deviation to Docker file for project specific setups
* Video with "how to remote connect with VScode and debug" in youtube aka demo
* Adoption videos or tutorials to explain “why?” you might wish to consider it.
* Automate creation of the launch.json
* Add to the project repository "recommended" VSC plugins as json config per VSC documentation


