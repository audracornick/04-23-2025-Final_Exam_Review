"Perform knn classification on the penguin data.

Usage:
  03_model.R --input_path=<input_path> --output_folder=<output_folder> --result_folder=<result_folder>

Options: 
  --input_path=<input_path> Path to the prepared data
  --output_folder=<output_folder> Path to data folder
  --result_folder=<result_folder> Rath to the results directory to save the model
" -> doc

library(docopt)
library(tidyverse)
library(palmerpenguins)
library(tidymodels)

opt <- docopt(doc)

main <- function(input_path, output_folder, result_folder){
  set.seed(123)
  
  data <- read_csv(input_path)
  
  data_split <- initial_split(data, strata = species)
  train_data <- training(data_split)
  test_data <- testing(data_split)
  
  # Convert species to a factor (important for classification)
  train_data$species <- as.factor(train_data$species)
  test_data$species <- as.factor(test_data$species)
  
  write_csv(test_data, file.path(output_folder, "test_data.csv"))
  
  # Define model
  penguin_model <- nearest_neighbor(mode = "classification", neighbors = 5) %>%
    set_engine("kknn")
  
  # Create workflow
  penguin_workflow <- workflow() %>%
    add_model(penguin_model) %>%
    add_formula(species ~ .)
  
  # Fit model
  penguin_fit <- penguin_workflow %>%
    fit(data = train_data)
  
  saveRDS(penguin_fit, file.path(result_folder, "penguin_model.rds"))
}
main(opt$input_path, opt$output_folder, opt$result_folder)
