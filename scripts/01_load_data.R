"Load and clean penguin data.

Usage: 
  01_load_data.R --output_path=<output_path>

Options:
  --output_path=<output_path> Path to save the cleaned data. 
" -> doc

library(docopt)
library(tidyverse)
library(palmerpenguins)

opt <- docopt(doc)

main <- function(output_path){
  data <- penguins

  # Initial cleaning: Remove missing values
  data <- data %>% drop_na()
  write_csv(data, output_path)
}
main(opt$output_path)

