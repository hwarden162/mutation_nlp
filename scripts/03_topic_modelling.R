# Import Packages ---------------------------------------------------------
library(tidyverse)
library(tidytext)

# Load Data ---------------------------------------------------------------
data <- read_delim("./data/02_data_preprocessing/processed_data.csv", delim = "\t")

# Cleaning Data -----------------------------------------------------------
# Transform the data such that each word is on one line
data_words <- data %>%
  unnest_tokens(word, abstract) %>%
  select(pubmed_id, word)

# Filtering out unwanted words
data_words %>%
  # Removing common words
  anti_join(stop_words) %>%
  mutate(
    # Removing whitespace from before and after each word
    word = str_trim(word),
    # Finding the length of each word
    len = str_length(word)
  ) %>%
  filter(
    # Keeping only words that contain at least one letter
    str_detect(word, "[A-Za-z]"),
    # Keeping words with three or more letters
    len > 2,
    # Removing words that start with a number
    str_starts(word, "[0-9]", negate = TRUE),
    # Removing words that contain whitespace
    str_detect(word, "\\s+", negate = TRUE),
    # Removing words containing specific pieces of punctuation
    str_detect(word, "\\.", negate = TRUE),
    str_detect(word, "\\_", negate = TRUE),
    str_detect(word, "\\:", negate = TRUE),
    # Removing any words with 9 or more letters that contain a number
    !(str_detect(word, "[0-9]") & (len > 8))
  )

