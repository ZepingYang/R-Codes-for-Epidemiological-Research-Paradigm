# Description 2 - Table. Distribution of particulate matter (PM) levels by time windows
## Author: YangZeping
## Date: 2025-01-13
## Purpose: Draw the descriptive table for the distributions of PM concentrations
## Tips: Remember to read the tips in the angle brackets <>

# Load Packages ----
{
  library(tidyverse)
}

# Set Work Directory ----
Data_dir <- "/<Replace your work directory here>/Data"
Results_dir <- "/<Replace your work directory here>/Results"
setwd(Data_dir)

# Import Data ----
dt <- rio::import("<Replace your dataset here>")
  ## Simulated Data
set.seed(123)  # Set random seeds to ensure the results reproducible
dt <- data.frame(
  PM25_post_1st_trimester = rnorm(100, mean = 25, sd = 5),
  PM25_post_2nd_trimester = rnorm(100, mean = 27, sd = 6),
  PM25_post_3rd_trimester = rnorm(100, mean = 30, sd = 7),
  PM25_whole_pregnancy = rnorm(100, mean = 28, sd = 5),
  PM10_post_1st_trimester = rnorm(100, mean = 50, sd = 10),
  PM10_post_2nd_trimester = rnorm(100, mean = 55, sd = 12),
  PM10_post_3rd_trimester = rnorm(100, mean = 60, sd = 15),
  PM10_whole_pregnancy = rnorm(100, mean = 58, sd = 10),
  PM25_10_post_1st_trimester = rnorm(100, mean = 10, sd = 2),
  PM25_10_post_2nd_trimester = rnorm(100, mean = 12, sd = 2.5),
  PM25_10_post_3rd_trimester = rnorm(100, mean = 15, sd = 3),
  PM25_10_whole_pregnancy = rnorm(100, mean = 13, sd = 2)
)


# Draw the Table ----
  # Variables Included: 
  # Mean
  # SD
  # Min
  # Q1 (Percentiles 25)
  # Median (Percentiles 50)
  # Q3 (Percentiles 75)
  # Max
  # IQR (Q3 - Q1)

# Create a function to compute various statistics
calc_stats <- function(x) {
  c(
    Mean = mean(x, na.rm = TRUE),
    SD = sd(x, na.rm = TRUE),
    Min = min(x, na.rm = TRUE),
    Q1 = quantile(x, 0.25, na.rm = TRUE)[1], 
    Median = median(x, na.rm = TRUE),
    Q3 = quantile(x, 0.75, na.rm = TRUE),
    Max = max(x, na.rm = TRUE),
    IQR = IQR(x, na.rm = TRUE)
  )
}

# List all required variables
vars <- c("PM25_post_1st_trimester", "PM25_post_2nd_trimester", "PM25_post_3rd_trimester", "PM25_whole_pregnancy",
          "PM10_post_1st_trimester", "PM10_post_2nd_trimester", "PM10_post_3rd_trimester", "PM10_whole_pregnancy",
          "PM25_10_post_1st_trimester", "PM25_10_post_2nd_trimester", "PM25_10_post_3rd_trimester", "PM25_10_whole_pregnancy")

# Define a combination of Air Pollutants and Time Windows
exposures <- c("PM25 (μg/m3)", "PM10 (μg/m3)", "PM2.5_10 (μg/m3)")
time_windows <- c("First trimester", "Second trimester", "Third trimester", "Whole pregnancy")

# Create an empty data box to store the results
result <- tibble(Exposure = character(),
                 Window = character(),
                 Mean = numeric(),
                 SD = numeric(),
                 Min = numeric(),
                 Q1 = numeric(),
                 Median = numeric(),
                 Q3 = numeric(),
                 Max = numeric(),
                 IQR = numeric())

# The statistics of each pollutants in each time window are calculated through a loop
for (i in 1:3) {
  exposure_vars <- vars[(i - 1) * 4 + (1:4)]  # Extract the corresponding variable
  
  for (j in 1:4) {
    # Extract the variables under this time window
    var <- exposure_vars[j]
    
    # calculate statistics
    stats <- calc_stats(dt[[var]])
    
    # Adds the statistic to the result table
    result <- result %>%
      add_row(
        Exposure = exposures[i],
        Window = time_windows[j],
        Mean = stats["Mean"],
        SD = stats["SD"],
        Min = stats["Min"],
        Q1 = stats["Q1.25%"], # P.S: The quantile function forces the suffix to be added to the value name
        Median = stats["Median"],
        Q3 = stats["Q3.75%"], # P.S: The quantile function forces the suffix to be added to the value name
        Max = stats["Max"],
        IQR = stats["IQR"]
      )
  }
}

# Export Results ----
setwd(Results_dir)

rio::export(result, "Description 2 - Table. Distribution of particulate matter (PM) levels by time windows.xlsx")
