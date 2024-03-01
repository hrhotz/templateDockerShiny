


a simple shiny app in a docker container


# goal

providing a template for a dockerized shiny app which handles a input folder for (non-obligatory) data and an output folder for results and log data 

the shiny app includes an action button to "save and exit" which cleanly closes the app and stops the container.


# setup

the shiny app is available as a package

the docker container is build on top of `bioconductor/bioconductor_docker:RELEASE_3_18` and installs the package for the shiny app

the shiny app is started by `app_setup.R` called by the docker container



# the template shiny app 

using the faithful datasets [https://search.r-project.org/CRAN/refmans/alr4/html/oldfaith.html]
a simple interactive histogram is plotted where you can change the number of bins

Upon exit, all your actions (i.e.: change of bin side in slider) are logged in the 

The plot can be saved (this action is logged as well)


# the 'app_setup.R' 





# building the container

```
docker build -t templatedockershiny:latest
```

# running the container

```
mkdir -p /full_path/my_host_inputs/ 
mkdir -p /full_path/my_host_outputs/

docker run -p 8080:3838 -v /full_path/my_host_inputs/:/shiny_input -v /full_path/my_host_outputs/:/shiny_output templatedockershiny
```

for an interactive session, you can execute:

```
docker run  -i -t -p 8080:3838 -v /full_path/my_host_inputs/:/shiny_input -v /full_path/my_host_outputs/:/shiny_output templatedockershiny bash 

Rscript /app_setup.R
```

# How to publish and deploy the docker image onto quay.io

* Create an account at quay.io

* In quay.io:
  - go to your User Settings
  - create a Docker CLI Password (and copy that to your clipboard)

* Back on your github repo
  - Go to your repo Settings -> Secrets and variables -> Actions
  - Create a "New repository secret"
  - Select as Name `QUAY_OAUTH_TOKEN` and as Secret the value of the Docker CLI Password (the one you just copied to clipboard), and click on Add secret
  - This value will be picked up by the GitHub actions defined in the [Github workflows folder](./.github/workflows), specifically `release.yml`
  
* Tag/release your current status of the repo. To do so
  - from your repo `https://github.com/[your_github_username]/[github_repo]/releases`, "Draft a new release"
  - Choose a tag for the version, e.g. `v0.1` for the first version
  - Specify a release title and its description, for completeness
  - Click on "Publish release"
  - This should trigger the build upon tag/release on your repo Actions
  
* Check that the GitHub Action `release-CI` is run and complete. Specifically:
  - The login to quay.io works
  - The image is built correctly
  - The image is pushed to quay.io
  - Check that this has happened by navigating to https://quay.io/repository/[your_quay_username]/[your_quay_repo_name], where `your_quay_repo_name` is specified in the `YOUR_QUAY_REPO_NAME` field of the [release.yml](./.github/workflows/release.yml)
  - Set the Repository Visibility for the quay.io repo to public (from the Settings tab menu)
  - Check the Repository Tags tab to see the docker image being correctly generated
  
  
[optional step: get this into galaxy]
  
  
  










# running the published container

```
docker run -p 8080:3838 -v /full_path/my_host_inputs/:/shiny_input -v /full_path/my_host_outputs/:/shiny_output quay.io/TBD/templatedockershiny:latest
```




