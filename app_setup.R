library("templateDockerShinyPkg")

input_folder <- Sys.getenv("SHINY_INPUT_DIR")
output_folder <- Sys.getenv("SHINY_OUTPUT_DIR")


if((input_folder == '' || !dir.exists(input_folder))) {
  x = faithful$waiting
} else {
  data_obj_path <- file.path(input_folder, "data.rds")
  if(!file.exists(data_obj_path)) {
    x = faithful$waiting
  } else {
    x <- readRDS(data_obj_path)
  }
}

if(output_folder == '' || !dir.exists(output_folder)) {
  app_template <- histogramApp(x)
} else {
  app_template <- histogramAppWithExport(x, outputDir = output_folder )
}

out <- shiny::runApp(app_template, launch.browser = FALSE, port = 3838, host = "0.0.0.0")

if(exists("out")) {
  
  if(output_folder == "" || !dir.exists(output_folder)) {
    # there is data, but the output folder is mis-specified\
    # do nothing
      
   } else {
      saveRDS(out, file = file.path(output_folder, "template_output.rds"))
      write.table(out$log, file = file.path(output_folder, "template_log.tab"), row.names = FALSE, quote = FALSE, col.names = FALSE)
      
  }
} else {
  # do nothing
}
