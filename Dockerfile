# ARG 

FROM bioconductor/bioconductor_docker:RELEASE_3_19

ENV SHINY_INPUT_DIR="/shiny_input"
ENV SHINY_OUTPUT_DIR="/shiny_output"

# install Bioc
RUN Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); install.packages('BiocManager')" && \
    Rscript -e "BiocManager::install(ask=FALSE)" && \
    # install the package itself
    Rscript -e "BiocManager::install('csoneson/templateDockerShinyPkg')"

USER root

RUN mkdir -p /shiny_input /shiny_output
RUN chown rstudio:rstudio /shiny_input /shiny_output
USER rstudio

ADD app_setup.R /app_setup.R

EXPOSE 3838
CMD Rscript /app_setup.R
