# Import Packages ---------------------------------------------------------
library(tidyverse)
library(tidytext)

# Load Data ---------------------------------------------------------------
data <- read_delim("./data/02_data_preprocessing/processed_data.csv", delim = "\t")

# Cleaning Data -----------------------------------------------------------
# Transform the data such that each word is on one line
words <- data %>%
  unnest_tokens(word, abstract) %>%
  select(pubmed_id, word)

# Filtering out unwanted words
filtered_words <- words %>%
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

word_count <- filtered_words %>%
  group_by(pubmed_id) %>%
  summarise(
    count = n()
  ) %>%
  left_join(
    data %>% select(pubmed_id, gene_type)
  )

word_count %>%
  group_by(gene_type) %>%
  mutate(
    gene_type = paste0(gene_type, "\n(n=", n(), ")")
  ) %>%
  ggplot(
    aes(
      x = count,
      y = gene_type
    )
  ) +
  geom_boxplot() +
  geom_vline(
    xintercept = mean(word_count$count),
    colour = "red",
    linetype = 2,
    size = 0.6
  ) +
  geom_vline(
    xintercept = mean(word_count$count) + 1.5*sd(word_count$count),
    colour = "blue",
    linetype = 2,
    size = 0.6
  ) +
  geom_vline(
    xintercept = mean(word_count$count) - 1.5*sd(word_count$count),
    colour = "blue",
    linetype = 2,
    size = 0.6
  ) +
  scale_x_log10() +
  theme_bw() +
  guides(
    fill = "none"
  ) +
  labs(
    x = "Number of Filtered Words in Abstract",
    y = "Type of Gene Referenced in Article",
    caption = "Red line represents the mean number of filtered words in abstract\nBlue lines represent one and a half standard deviations\nfrom the mean number of filtered words in abstract"
  ) +
  theme(
    axis.text.y = element_text(hjust = 0.5)
  )
