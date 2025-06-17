# NETFLIX  EDA 
# Note: make sure you install this lib : tidyverse, lubridate, tidytext, wordcloud, RColorBrewer, treemapify, stopwords
# and the graphs are saved in the directory update it pls


library(tidyverse)
library(lubridate)
library(tidytext)
library(wordcloud)
library(RColorBrewer)
library(treemapify)
library(stopwords)

setwd("C:/Users/osama_amer/Dropbox/My PC (LAPTOP-1ODVESE8)/Documents")
dir.create("graphs_project", showWarnings = FALSE)

# Load and preprocess
netflix <- read_csv("netflix_titles_2021.csv") %>%
  mutate(across(c(director, cast, country, rating), ~ replace_na(.,"Missing"))) %>%
  drop_na(duration) %>%
  mutate(
    duration_int  = as.numeric(str_extract(duration, "\\d+")),
    duration_unit = str_extract(duration, "[A-Za-z]+") %>% recode("Seasons"="Season"),
    date_added    = mdy(str_trim(date_added)),
    date_added    = if_else(is.na(date_added),
                            ymd(paste0(release_year,"-01-01")),
                            date_added),
    month_added   = factor(month(date_added, label=TRUE, abbr=FALSE),
                           levels=month.name, ordered=TRUE),
    year_added    = year(date_added)
  )

# 1- Content Type Pie Chart
type_counts <- netflix %>%
  count(type) %>%
  mutate(pct = n/sum(n)*100,
         label = paste0(type, "\n", n, " (", sprintf("%.1f%%", pct), ")"))
p1 <- ggplot(type_counts, aes("", y=n, fill=type)) +
  geom_col(width=1, color="white") +
  coord_polar(theta="y") +
  geom_text(aes(label=label), position=position_stack(vjust=0.5), size=4) +
  labs(title="Movies vs. TV Shows on Netflix") +
  theme_void() +
  theme(plot.title=element_text(hjust=0.5))
ggsave("graphs_project/content_type_pie.png", p1, width=6, height=6, bg="white")

# 2- Release Year Histogram
p2 <- ggplot(netflix, aes(release_year)) +
  geom_histogram(fill="steelblue", color="black", bins=30) +
  labs(title="Distribution of Release Years", x="Year", y="Count") +
  theme_minimal() +
  theme(plot.background=element_rect(fill="white", color=NA),
        plot.title=element_text(hjust=0.5))
ggsave("graphs_project/release_year_histogram.png", p2, width=8, height=4, bg="white")

# 3- Movie Duration Boxplot
p3 <- netflix %>%
  filter(duration_unit=="min") %>%
  ggplot(aes(duration_int)) +
  geom_boxplot(fill="gold") +
  labs(title="Movie Durations (min)", x="Duration (minutes)") +
  theme_minimal() +
  theme(plot.background=element_rect(fill="white", color=NA),
        plot.title=element_text(hjust=0.5))
ggsave("graphs_project/movie_duration_boxplot.png", p3, width=6, height=3, bg="white")

# 4- Density of Movie Durations
p4 <- netflix %>%
  filter(duration_unit=="min") %>%
  ggplot(aes(duration_int)) +
  geom_density(fill="purple", alpha=0.6) +
  labs(title="Density of Movie Durations", x="Duration (minutes)", y="Density") +
  theme_minimal() +
  theme(plot.background=element_rect(fill="white", color=NA),
        plot.title=element_text(hjust=0.5))
ggsave("graphs_project/movie_duration_density.png", p4, width=8, height=4, bg="white")

# 5- Top 10 Countries Lollipop
top_countries <- netflix %>%
  count(country, sort=TRUE) %>%
  slice_head(n=10) %>%
  arrange(n)
p5 <- ggplot(top_countries, aes(x=reorder(country,n), y=n)) +
  geom_segment(aes(xend=country, yend=0), color="skyblue") +
  geom_point(size=4, color="darkblue") +
  coord_flip() +
  labs(title="Top 10 Countries Producing Netflix Titles", x=NULL, y="Count") +
  theme_minimal() +
  theme(plot.background=element_rect(fill="white", color=NA),
        plot.title=element_text(hjust=0.5))
ggsave("graphs_project/top_countries_lollipop.png", p5, width=8, height=5, bg="white")

# 6- Word Cloud 
data("stop_words")
title_words <- netflix %>%
  select(title) %>%
  unnest_tokens(word, title) %>%
  anti_join(stop_words, by="word") %>%
  count(word, sort=TRUE) %>%
  filter(n>=5)
png("graphs_project/title_wordcloud.png", width=2000, height=1000, bg="white")
set.seed(42)
wordcloud(words=title_words$word, freq=title_words$n,
          min.freq=5, max.words=100, random.order=FALSE,
          colors=brewer.pal(8,"Dark2"), scale=c(12,2))
dev.off()

# 7- Rating Distribution Bar Chart
p6 <- netflix %>%
  count(rating, sort=TRUE) %>%
  ggplot(aes(x=reorder(rating,n), y=n, fill=rating)) +
  geom_col(show.legend=FALSE) +
  coord_flip() +
  labs(title="Netflix Content Ratings", x=NULL, y="Count") +
  theme_minimal() +
  theme(plot.background=element_rect(fill="white", color=NA),
        plot.title=element_text(hjust=0.5))
ggsave("graphs_project/rating_distribution_bar.png", p6, width=8, height=6, bg="white")
