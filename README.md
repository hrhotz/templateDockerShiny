# Goal

The purpose of this repository is to provide a template for dockerizing an existing [shiny application](https://shiny.posit.co/), which handles an input folder containing (non-obligatory)
data and an output folder where any results and log data exported from the app will be placed. 
The shiny app should include an action button to "save and exit", which cleanly closes the app and stops the container.


# Overview of the setup

* The shiny app should be available in an R package. A template for such a package can be found [here](https://github.com/csoneson/templateDockerShinyPkg).

* The docker container is built on top of bioconductor/bioconductor_docker:RELEASE_3_19 and installs the package with the shiny app.

* The shiny app is started by running 'app_setup.R' inside the container.


# The template shiny app 

The template shiny application in the [example package](https://github.com/csoneson/templateDockerShinyPkg) uses the [Old Faithful geyser dataset](https://search.r-project.org/CRAN/refmans/alr4/html/oldfaith.html) as
the basis for creating a simple interactive histogram, for which the user can change the number of bins. The plot can also be saved to disk. Upon exiting the app by clicking the "Stop app" button,
all the user's actions (i.e.: change of bin size using the slider, exporting a plot) are returned in a log variable, which can then be written to a file. 


# The 'app_setup.R' script

The `app_setup.R` script takes care of loading the R package holding the shiny app, reading input data, launching the application and, upon closing the app, writing the returned output to the output directory. 


# Setting up your own app

To start the setup for your own app, first create a local copy of this repository, either by cloning the repository or by downloading its content as a zip file.
Next, adapt the `Dockerfile` and the `app_setup.R` script according to your requirements. 

Some examples of applications can be found in the following repositories: 

* [https://github.com/federicomarini/docker-GeneTonic](https://github.com/federicomarini/docker-GeneTonic)
* [https://github.com/federicomarini/docker-ideal](https://github.com/federicomarini/docker-ideal)
* [https://github.com/federicomarini/docker-isee](https://github.com/federicomarini/docker-isee)
* [https://github.com/csoneson/docker-exploremodelmatrix](https://github.com/csoneson/docker-exploremodelmatrix)


# Building the image

To build the Docker image locally, run the following code from the directory where the `Dockerfile` is located (or change the path accordingly), replacing `templatedockershiny` with a suitable name:

```bash
docker build -t templatedockershiny:latest .
```

# Running the container

To run the container, first (if applicable) create directories for any input and output files for the app, and mount these as `/shiny_input` and `/shiny_output` in the container
(these names should agree with those used to define `SHINY_INPUT_DIR` and `SHINY_OUTPUT_DIR` in the `Dockerfile`).

```bash
mkdir -p /full_path/my_host_inputs/ 
mkdir -p /full_path/my_host_outputs/

docker run -p 8080:3838 -v /full_path/my_host_inputs/:/shiny_input -v /full_path/my_host_outputs/:/shiny_output templatedockershiny
```

The application can then be used by opening a browser and navigating to `http://localhost:8080`.

To launch an interactive session, you can execute:

```bash
docker run  -i -t -p 8080:3838 -v /full_path/my_host_inputs/:/shiny_input -v /full_path/my_host_outputs/:/shiny_output templatedockershiny bash 

Rscript /app_setup.R
```

This allows, e.g., browsing the input and output directories before and after using the app, or running `app_setup.R` interactively. 

# Publishing and deploying the docker image onto quay.io

* Push your repository to GitHub

* Create an account at [quay.io](https://quay.io)

* In [quay.io](https://quay.io):
  - go to your User Settings
  - create a Docker CLI Password (and copy that to your clipboard)

* Back on your GitHub repo
  - Go to your repo Settings → Secrets and variables → Actions
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
  

# Running the published container

```bash
docker run -p 8080:3838 -v /full_path/my_host_inputs/:/shiny_input -v /full_path/my_host_outputs/:/shiny_output quay.io/TBD/templatedockershiny:latest
```



