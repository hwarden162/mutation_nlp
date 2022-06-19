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

# Finding the number of filtered words in each abstract
word_count <- filtered_words %>%
  group_by(pubmed_id) %>%
  summarise(
    count = n()
  ) %>%
  # Adding gene_type information for each article
  left_join(
    data %>% select(pubmed_id, gene_type)
  )

# Plotting the number of words in each abstract per gene_type
word_count %>%
  group_by(gene_type) %>%
  # Adding in the number of abstracts per gene_type
  mutate(
    gene_type = paste0(gene_type, "\n(n=", n(), ")")
  ) %>%
  # Creating a boxplot
  ggplot(
    aes(
      x = count,
      y = gene_type
    )
  ) +
  geom_boxplot() +
  # Adding a line for the mean
  geom_vline(
    xintercept = mean(word_count$count),
    colour = "red",
    linetype = 2,
    size = 0.6
  ) +
  # Adding lines for 1.5 standard deviations from the mean
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

filtered_articles <- word_count %>%
  filter(
    count < mean(count) + 1.5*sd(count),
    count > mean(count) - 1.5*sd(count)
  )

filtered_words_vector <- filtered_words$word
filtered_articles_vector <- filtered_articles$pubmed_id

word_data <- words %>%
  anti_join(stop_words) %>%
  filter(
    word %in% filtered_words_vector,
    pubmed_id %in% filtered_articles_vector
  )

word_data %>%
  left_join(
    data %>% select(pubmed_id, gene_type)
  ) %>%
  group_by(word, gene_type) %>%
  summarise(
    count = n()
  ) %>%
  ungroup() %>%
  group_by(gene_type) %>%
  mutate(
    prop = count/n()
  ) %>%
  ggplot(
    aes(
      x = count,
      fill = gene_type
    )
  ) +
  geom_histogram() +
  facet_wrap(~ gene_type, ncol = 1, scales = "free") +
  scale_y_continuous(trans = scales::log1p_trans()) +
  scale_x_log10() +
  theme_bw() +
  guides(
    fill = "none"
  ) +
  scale_fill_viridis_d()
