" Performs exploratory data analysis (EDA) and prepare the penguin data for modeling.

Usage:
  02_methods.R --input_path=<input_path> --output_path=<output_path> --result_path=<result_path>

Options:
  --input_path=<input_path> Path to the cleaned data file.
  --output_path=<output_path> Path to save the prepared data.
  --result_path=<result_path> Path to the results directory.
" -> doc

library(docopt)
library(tidyverse)
library(palmerpenguins)

opt <- docopt(doc)

main <- function(input_path, output_path, result_path){

  data <- read_csv(input_path)
  
  # Summary statistics
  glimpse_output <- capture.output(glimpse(data))
  
  # Save the glimpse of the data to a text file
  writeLines(glimpse_output, con = file.path(result_path, "data_glimpse.txt"))
  
  sum_stats <- summarise(data, mean_bill_length = mean(bill_length_mm), mean_bill_depth = mean(bill_depth_mm))
  write.table(sum_stats, file = file.path(result_path, "summary_statistics.txt"), sep = "\t", row.names = FALSE)
  
  # Visualizations
  eda_plot <- ggplot(data, aes(x = species, y = bill_length_mm, fill = species)) +
    geom_boxplot() +
    theme_minimal()
  ggsave(filename = file.path(result_path, "boxplot_bill_length.png"), plot = eda_plot)

  # Prepare data for modeling
  data <- data %>%
    select(species, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
    mutate(species = as.factor(species))
  
  write_csv(data, output_path)
}

main(opt$input_path, opt$output_path, opt$result_path)