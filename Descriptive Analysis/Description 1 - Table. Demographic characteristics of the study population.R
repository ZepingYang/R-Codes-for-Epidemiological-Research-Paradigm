# Description 1 - Table. Demographic characteristics of the study population
## Author: YangZeping
## Date: 2025-01-13
## Purpose: Draw the Table1 in epidemiological research
## Tips: Remember to read the tips in the angle brackets <>

# Load Packages ----
{
  library(tidyverse)
  library(sjlabelled)
}

# Set Work Directory ----
Data_dir <- "/<Replace your work directory here>/Data"
Results_dir <- "/<Replace your work directory here>/Results"
setwd(Data_dir)

# Import Data ----
dt <- rio::import("<Replace your dataset here>")
  ## Simulated Data
set.seed(123)
dt <- data.frame(  # <Remove this line when apply to your research>
  Var1_continuous = rnorm(100, mean = 50, sd = 10),  # A normal distribution simulates continuous variables
  Var2_categorized = sample(c(1, 2), size = 100, replace = TRUE),  # Random generation of categorical variables (1 or 2)
  Var3_categorized = sample(c(1, 2, 3), size = 100, replace = TRUE)  # Random generation of categorical variables (1, 2, or 3)
)

# Add Labels for Variables and Variable Values ----

## Var1_continuous ----
dt$Var1_continuous <- set_label(dt$Var1_continuous, label = "Var1_continuous, mean (SD), unit")

## Var2_categorized ----
dt$Var2_categorized <- set_label(dt$Var2_categorized, label = "Var2_categorized, No. (%)")
dt$Var2_categorized <- factor(dt$Var2_categorized, levels = c(1, 2), labels = c("category 1", "category 2"))
levels(dt$Var2_categorized)

## Var3_categorized ----
dt$Var3_categorized <- set_label(dt$Var3_categorized, label = "Var3_categorized, No. (%)")
dt$Var3_categorized <- factor(dt$Var3_categorized, levels = c(1, 2, 3), labels = c("category 1", "category 2", "category 3"))
levels(dt$Var3_categorized)

## <Add more variables here by above template> ----
# Draw Table 1 ----
  # Use moonBook 包
  # Official Tutorial: https://cran.r-project.org/web/packages/moonBook/vignettes/moonBook.html
  # Online Tutorial: https://mp.weixin.qq.com/s/_5ty7gP9CdLaZ3DWNwL4OQ

library(moonBook)

## Table 1 ----
  # <When there are missing values, the proportion is calculated to exclude missing values, and this part of data needs to be manually corrected>

table1 <- mytable( ~ Var1_continuous + Var2_categorized + Var3_categorized, # <Add more your variables here>
                   data = dt, 
                   digits = 2,  # Set the number of decimal places to 2
                   method = 1,  # 1: Normal (Default); 2: Non-normal; 3: Check normality and choose presentation accordingly.
                   catMethod = 0,      # catMethod = 0: Chi-squared test first, then Fisher's exact test if conditions are not met; 1: Chi-squared without continuity correction; 2: Chi-squared with continuity correction; 3: Fisher's exact test; 4: Mantel-Haenszel test
                   show.total = TRUE,  # Include the total column
                   show.all = TRUE)    # Display the statistical method chosen


## Table 1 (Categorized by specific variable) ----
table1_pro <- mytable(Var2_categorized ~ Var1_continuous + Var3_categorized, # <Add more your variables here>
                   data = dt, 
                   digits = 2,
                   method = 1,
                   catMethod = 0,  
                   show.total = TRUE, 
                   show.all = TRUE)

# Export Results ----
setwd(Results_dir)

write.csv(table1, file = "Description 1 - Table. Demographic characteristics of the study population.csv", row.names = FALSE)
mycsv(table1_pro, file = "Description 1 - Table. Demographic characteristics of the study population categrized by Var2.csv") # Although this line reports an error, the table can still be saved to the directory.
