library(tidyverse)

raw_data <- read.csv("./data/data.csv", sep = "\t") %>%
  as_tibble()

data <- raw_data %>%
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
