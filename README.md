# Netflix Data Analysis & Visualization

An exploratory data analysis (EDA) of the Netflix Movies and TV Shows dataset using R to uncover content trends through visualization.

## Overview

This project analyzes:
*   Content type distribution (Movies vs. TV Shows).
*   Release year trends.
*   Typical movie durations.
*   Content rating distributions.
*   Common themes in titles via a word cloud.
*   Top content-producing countries.

## Tools Used

*   **R** with packages:
    *   `tidyverse` (`dplyr`, `ggplot2`)
    *   `lubridate`
    *   `tidytext`
    *   `wordcloud`
    *   `RColorBrewer`

## Process

1.  **Load Data:** `netflix_titles_2021.csv`.
2.  **Preprocess:**
    *   Handle missing values (impute/replace with "Missing").
    *   Parse and standardize `duration` (to numeric length and unit "min"/"Season").
    *   Convert `date_added` to date format; impute missing dates from `release_year`.
    *   Tokenize titles and remove stop words for word cloud.
3.  **Visualize:** Create 7 distinct plots (pie, histogram, boxplot, density, lollipop, word cloud, bar chart) to illustrate findings.

## Output

*   R script: `[Your_R_Script_Name.R]`
*   Generated plot images e.g., `content_type_pie.png`, `release_year_histogram.png`, etc. are saved in the `[Your_Output_Folder_Name]` directory.


## Key Insights (Summary)

*   Netflix features more Movies (approx. 70%) than TV Shows.
*   Content is heavily skewed towards recent releases (post-2010).
*   Most movies are 90-100 minutes long.
*   USA and India are top content producers.
*   "Love" and "Christmas" are prominent title themes.
*   TV-MA is the most common rating.

*(For detailed insights and plot justifications, please see the project documentation PDF.)*

## How to Run

1.  R and required packages are installed.
2.  Place `netflix_titles_2021.csv` in the project directory.
3.  Update paths in `[Your_R_Script_Name.R]` if needed.
4.  Run the R script. Plots will be saved to `[Your_Output_Folder_Name]`.
