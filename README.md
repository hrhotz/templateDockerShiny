


a simple shiny app in a docker container


# goal

providing a template for a dockerized shiny app which handles a input folder for (non-obligatory) data and an output folder for results and log data 

the shiny app includs an action button to "save and exit" which cleanly closes the app and stops the container.


# setup

the shiny app is available as a package

the docker container is build on top of bioconductor/bioconductor_docker:RELEASE_3_18 and installs the package for the shiny app

the shiny app is started by 'app_setup.R' called by the docker container



# the template shiny app 

using the faithful datasets [https://search.r-project.org/CRAN/refmans/alr4/html/oldfaith.html]
a simple interactive histogram is plotted where you can change the number of bins

Upon exit, all your actions (i.e.: change of bin side in slider) are logged in the 

The plot can be saved (this action is logged as well)


# the 'app_setup.R' 





# building the container

docker build -t templatedockershiny:latest


# running the container

mkdir -p /full_path/my_host_inputs/ 
mkdir -p /full_path/my_host_outputs/

docker run -p 8080:3838 -v /full_path/my_host_inputs/:/shiny_input -v /full_path/my_host_outputs/:/shiny_output templatedockershiny


for an interactive session, you can execute:

docker run  -i -t -p 8080:3838 -v /full_path/my_host_inputs/:/shiny_input -v /full_path/my_host_outputs/:/shiny_output templatedockershiny bash 

Rscript /app_setup.R


# running the published container

docker run -p 8080:3838 -v /full_path/my_host_inputs/:/shiny_input -v /full_path/my_host_outputs/:/shiny_output quay.io/TBD/templatedockershiny:latest





