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

## Under Review
* Update readme with how to use this repository (done - installation guide added on how to use it and make installation)
* Create docker image with node on linux (preferable to use Node image, so might remove this todo)
* Update configuration file with bash script (done - to be removed in the next release)
* Include build-suite in the solution as "deployment" pipeline for code and data (done - sfcc-ci was used instead)

### Old (DEPRECATED) installation steps to be removed in future releases from the repo.

Manual steps performed before. I masked with `TBC_YOUR_DATA` data for security reason:
1) `docker run -i -t osapishchuk/storefront-reference-architecture-docker`
1)  Open with Desktop Dcoker application CLI for this container
1) `cd home`
1) `mkdir sfcc`
1) `cd sfcc`
1) `git clone https://TBC_YOUR_DATA:TBC_YOUR_DATA@github.com/SalesforceCommerceCloud/storefront-reference-architecture`
1) `cd storefront-reference-architecture`
1) `npm install`
1) `npm run compile:js`
1) `npm run compile:scss`
1) `npm run compile:fonts`
1) Open visual studio code (VSC) using remote container connection
1) Create `dw.json` in the root repository folder of SFRA folder
1) Update manually the file with

```JSON
{
    "hostname": "TBC_YOUR_DATA.sandbox.us01.dx.commercecloud.salesforce.com",
    "username": "TBC_YOUR_DATA",
    "password": "TBC_YOUR_DATA",
    "code-version": "code"
}
```

15) `cd ../`
1) `git clone https://TBC_YOUR_DATA:TBC_YOUR_DATA@github.com/SalesforceCommerceCloud/storefrontdata`
1) `cd storefrontdata`
1) `npm run zipData`
1) `cd ../`
1) `git clone https://TBC_YOUR_DATA:TBC_YOUR_DATA@github.com/SalesforceCommerceCloud/sfcc-ci`
1) `cd sfcc-ci`
1) `npm install`
> Assumption is that OD or regular sandbox already provisioned
23) Manual BM changes:
    1) In BM configure Open Commerce API Settings:

    ```json
    {
          "_v": "19.5",
          "clients":
          [
            {
              "client_id": "TBC_YOUR_DATA",
              "resources":
              [
                {
                  "resource_id": "/code_versions",
                  "methods": ["get"],
                  "read_attributes": "(**)",
                  "write_attributes": "(**)"
                },
                {
                  "resource_id": "/code_versions/*",
                  "methods": ["patch", "delete"],
                  "read_attributes": "(**)",
                  "write_attributes": "(**)"
                },
                {
                  "resource_id": "/jobs/*/executions",
                  "methods": ["post"],
                  "read_attributes": "(**)",
                  "write_attributes": "(**)"
                },
                {
                  "resource_id": "/jobs/*/executions/*",
                  "methods": ["get"],
                  "read_attributes": "(**)",
                  "write_attributes": "(**)"
                },
                { 
                  "resource_id": "/sites/*/cartridges", 
                  "methods": ["post"], 
                  "read_attributes": "(**)", 
                  "write_attributes": "(**)"
                },
                {
                  "resource_id":"/role_search",
                  "methods":["post"],
                  "read_attributes":"(**)",
                  "write_attributes":"(**)"
                },
                {
                  "resource_id":"/roles/*",
                  "methods":["get"],
                  "read_attributes":"(**)",
                  "write_attributes":"(**)"
                },
                {
                  "resource_id":"/roles/*/user_search",
                  "methods":["post"],
                  "read_attributes":"(**)",
                  "write_attributes":"(**)"
                },
                {
                  "resource_id":"/roles/*/users/*",
                  "methods":["put","delete"],
                  "read_attributes":"(**)",
                  "write_attributes":"(**)"
                },
                {
                  "resource_id":"/user_search",
                  "methods":["post"],
                  "read_attributes":"(**)",
                  "write_attributes":"(**)"
                },
                {
                  "resource_id":"/users",
                  "methods":["get"],
                  "read_attributes":"(**)",
                  "write_attributes":"(**)"
                },
                {
                  "resource_id":"/users/*",
                  "methods":["put","get","patch","delete"],
                  "read_attributes":"(**)",
                  "write_attributes":"(**)"
                }
              ]
            }
          ]
        }
    ```

    2) Go to WebDAV Client Application and configure it:

    ```json
    {
    	"clients": [    		
    		{
    			"client_id": "TBC_YOUR_DATA",
    			"permissions": [
    				{
    					"path": "/impex",
    					"operations": [
    						"read_write"
    					]
    				},
    				{
    					"path": "/cartridges",
    					"operations": [
    						"read_write"
    					]
    				},
    				{
    					"path": "/static",
    					"operations": [
    						"read_write"
    					]
    				},
    				{
    					"path": "/catalogs/<your-catalog-id>",
    					"operations": [
    						"read_write"
    					]
    				},
    				{
    					"path": "/libraries/<your-library-id>",
    					"operations": [
    						"read_write"
    					]
    				},
    				{
    					"path": "/dynamic/<your-site-id>",
    					"operations": [
    						"read_write"
    					]
    				}
    			]
    		}
    	]
    }
    ```

24) Create `.env` file in the `storefront-reference-architecture` folder

```bash
SFCC_OAUTH_CLIENT_ID=TBC_YOUR_DATA
SFCC_OAUTH_CLIENT_SECRET=TBC_YOUR_DATA
SFCC_OAUTH_USER_NAME=TBC_YOUR_DATA
SFCC_OAUTH_USER_PASSWORD=TBC_YOUR_DATA
SANDBOX_HOST=TBC_YOUR_DATA.sandbox.us01.dx.commercecloud.salesforce.com
```

25) Run in the console following to deploy code + data + reindex and render url

    ```bash
    # START
    sfcc-ci client:auth $API_KEY $API_SECRET $API_USER $API_USER_PW

    # Package locally
    mkdir -p tmp/code
    cp -R cartridges/* tmp/code
    cd tmp
    zip -r -q code.zip code
    rm -r code

    # Deploy code to instance
    sfcc-ci code:deploy tmp/code.zip -i TBC_YOUR_DATA.sandbox.us01.dx.commercecloud.salesforce.com
    sfcc-ci code:activate code -i TBC_YOUR_DATA.sandbox.us01.dx.commercecloud.salesforce.com

    # Deploy data to instance
    sfcc-ci instance:upload ../storefrontdata/demo_data_sfra.zip -i TBC_YOUR_DATA.sandbox.us01.dx.commercecloud.salesforce.com
    sfcc-ci instance:import demo_data_sfra.zip -i TBC_YOUR_DATA.sandbox.us01.dx.commercecloud.salesforce.com -s

    # Reindex site and rebuild urls
    sfcc-ci job:run Reindex --instance TBC_YOUR_DATA.sandbox.us01.dx.commercecloud.salesforce.com --sync --json
    sfcc-ci job:run RebuildURLs --instance TBC_YOUR_DATA.sandbox.us01.dx.commercecloud.salesforce.com --sync --json
    ```

26) Check website `https://TBC_YOUR_DATA.sandbox.us01.dx.commercecloud.salesforce.com/s/RefArch/home?lang=en_US`


