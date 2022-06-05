# Importing Packages ------------------------------------------------------
library(tidyverse)

# Importing Data ----------------------------------------------------------
raw_data <- read.csv("./data/01_data_collection/raw_data.csv", sep = "\t") %>%
  as_tibble()

# Processing Data ---------------------------------------------------------
data <- raw_data %>%
  mutate(
    pubmed_id = factor(pubmed_id)
  ) %>%
  group_by(
    pubmed_id,
    abstract,
    gene_type
  ) %>%
  summarise(
    count = n()
  ) %>%
  pivot_wider(
    id_cols = c(pubmed_id, abstract),
    names_from = gene_type,
    values_from = count
  ) %>%
  mutate(
    LOF = replace_na(LOF, 0),
    GOF = replace_na(GOF, 0),
    logScore = log2(GOF/LOF),
    gene_type = NA,
    gene_type = replace(gene_type, logScore > 0, "GOF"),
    gene_type = replace(gene_type, logScore < 0, "LOF")
  ) %>%
  filter(
    abs(logScore) > 2
  ) %>%
  select(
    pubmed_id,
    abstract,
    gene_type
  )

# Saving Data -------------------------------------------------------------
write_csv(data, "./data//02_data_preprocessing/processed_data.csv")
