all: data results reports

data: scripts/01_load_data.R scripts/02_methods.R scripts/03_model.R
	Rscript scripts/01_load_data.R \
		--output_path="data/cleaned_penguins.csv"
	Rscript scripts/02_methods.R \
		--input_path="data/cleaned_penguins.csv" \
		--output_path="data/prepared_penguins.csv" \
		--result_path="results"
	Rscript scripts/03_model.R \
		--input_path="data/prepared_penguins.csv" \
		--output_folder="data" \
		--result_folder="results"

results: data/cleaned_penguins.csv data/prepared_penguins.csv data/test_data.csv scripts/04_results.R
	Rscript scripts/04_results.R \
		--input_path="data/test_data.csv" \
		--model_path="results/penguin_model.rds" \
		--result_folder="results"

reports: docs reports/report.qmd
	quarto render reports/report.qmd --to html
	quarto render reports/report.qmd --to pdf
	cp reports/report.html docs/index.html

clean:
	rm -rf results/* data/* 
