"
Performs model evaluation and prediction.

Usage:
  04_results.R --input_path=<input_path> --model_path=<model_path> --result_folder=<result_folder>

Options:
  --input_path=<input_path> Path to the test data file.
  --model_path=<model_path> Path to the trained model.
  --result_path=<result_folder> Path to save the results.
" -> doc

library(docopt)
library(tidymodels)
library(readr)
library(ggplot2)
library(yardstick)

opt <- docopt(doc)

main <- function(input_path, model_path, result_folder){
  
  test_data <- read_csv(input_path)
  
  model <- readRDS(model_path)
  
  # Predict on test data
  predictions <- predict(model, test_data, type = "class") %>%
    bind_cols(test_data) %>%
    mutate(
      species = factor(species),
      .pred_class = factor(.pred_class, levels = levels(species))
    )
  
  # Confusion matrix
  cm <- conf_mat(predictions, truth = species, estimate = .pred_class)
  
  # Plot and save
  p <- autoplot(cm)
  ggsave(filename = file.path(result_folder, "confusion_matrix.png"), plot = p)
}
main(opt$input_path, opt$model_path, opt$result_folder)