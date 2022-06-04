library(tidyverse)
library(tidytext)
library(drlib)

data <- read_csv("./data/02_data_preprocessing/processed_data.csv")

data_words <- data %>%
  select(
    -gene_type
  ) %>%
  unnest_tokens("word", "abstract") %>%
  anti_join(stop_words) %>%
  count(
    pubmed_id,
    word,
    sort = TRUE
  ) %>%
  filter(
    is.na(as.numeric(word))
  )
