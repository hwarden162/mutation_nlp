# Importing Packages ------------------------------------------------------
library(tidyverse)

# Importing Data ----------------------------------------------------------
raw_data <- read.csv("./data/01_data_collection/raw_data.csv", sep = "\t") %>%
  as_tibble()

# Processing Data ---------------------------------------------------------
data <- raw_data %>%
  # Find out how many times each article was returned as a query
  group_by(
    pubmed_id,
    abstract,
    title,
    gene_type
  ) %>%
  summarise(
    count = n()
  ) %>%
  # For each article, find out how many times it was returned from a GOF or LOF query
  pivot_wider(
    id_cols = c(pubmed_id, abstract, title),
    names_from = gene_type,
    values_from = count
  ) %>%
  mutate(
    # Missing values means the article was returned 0 times
    # replace NA's with 0
    LOF = replace_na(LOF, 0),
    GOF = replace_na(GOF, 0),
    # Calculate the log score for each gene
    logScore = log2(GOF/LOF),
    # Calculate new label as to what type of gene the article is referencing
    # For an article to be assigned a type, it must be referenced 4 times more by that type
    # Other articles are labelled as Other
    gene_type = NA,
    gene_type = replace(gene_type, logScore < 2, "LOF"),
    gene_type = replace(gene_type, logScore > 2, "GOF"),
    gene_type = replace(gene_type, is.na(gene_type), "Other")
  ) %>%
  # Select the useful outputs
  select(
    pubmed_id,
    abstract,
    title,
    gene_type
  )

# Saving Data -------------------------------------------------------------
write_delim(data, "./data//02_data_preprocessing/processed_data.csv", delim = "\t")
