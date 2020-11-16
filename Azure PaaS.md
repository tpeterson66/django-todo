# Azure PaaS Services to Host a Django App

This example will use Django, a Python framework as the programming language and will setting up a new Azure App Service, and Azure Postgres database.

## Building the Database

This can be done a few different ways including through the portal, using AZ CLI, Azure Powershell Modules, and even Terraform. There's some information that is required before building the new server and adding databases.

```bash
# Configure a new Postgres server
az postgres server create -l eastus -g Django-demo -n django-app-db-01 -u postgres -p thisSuperSECUREPassword2020! --sku-name B_Gen5_2 --ssl-enforcement Disabled --public-network-access Enabled --backup-retention 10 --geo-redundant-backup Enabled --storage-size 51200 --version 11

# Configure the TodoDB
az postgres db create --name TodoDB --server-name django-demo-db --resource-group Django-app
```

I ran into errors when using AZ CLI through cloud shell to deploy the server and ultimately used the portal to create the database server. Once the server is created, I was able to use AZ CLI to create the database. I did not see any option to create the database from the portal.

Once the database is created, there are a few configuration options that must be set.

1. Connection Security - This is used to protect the server from the Internet or unauthorized users. If you're going to use an Azure service such as a App Service, you will need to enable the "Allow access to Azure services" by setting it you "Yes". If you want to allow access to the database from outside of Azure, you can add the allowed IP addresses to the firewall rules. Even though network access is allowed, you still need valid credentials to connect to the databse.
2. SSL Enforcement - This setting is present in the connection settings blade. For my example, I did not use SSL, however, it is considered a best practice to enable SSL and set the correct level of TLS for your application for data in transit. This setting may result in some additional configuration within the application as well.

## Building the App Service

The App Service is a Azure PaaS used to host web applications using either the native language/runtime or hosting a container. For this example, I used the container method. The container method removes the complexity around dependency management and provides solution to host your container without having to manage the underlying infrastructure.

Azure app services can be created many different ways, including the portal, AZ CLI, Azure Powershell modules, etc. In this example, I created the app serivce through the portal and choose the following settings.

* Select your resource group where the app service will be deployed
* provide a globally unique name for your app service
* Choose the "Docker Container" option for the publish setting
* Choose "Linux" for the operating system setting
* Choose the proper location for the application service
* Allow the app service to create a new app service plan, you can update the name as needed
* Choose the corret size for your environment. If this is just a POC, choose the Free F1 size to reduce cost
* Continue to the next screen
* For the docker section, choose the single container option using Docker Hub
* Identify if your image is public or private, for this example, choose public
* Provide the image and tag (tpeterson66/django-todo:latest) or your location
* Ignore the startup command option - this is not needed for this container
* Continue to review and create

This can of course be automated or added to Terraform, however, for a POC, it's good to know which options are available to choose from.

Once the application serivce is created, you can add your application settings or environment variables.

### Adding Environment Variables

The application settings or environment variables are settings that can be passed to the container for settings including DB connection info. 

In the portal, application settings can be found under configuration. In the configuration blade, there is a section for Application Settings. You can add an application setting for the following items:

* POSTGRES_HOST
* POSTGRES_NAME
* POSTGRES_PASSWORD
* POSTGRES_PORT
* POSTGRES_USER

These settings tell the application about the Postgres database. All of these settings can be found in the database section and provided. The host is the server name of the Postgres server, the username must include the username@hostname including the FQDN. The port, by default is 5432 and the username was provided when creating the server.
