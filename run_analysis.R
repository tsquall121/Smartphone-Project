# Download the data
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile = "C:/Users/tsqua/Desktop/final_project")

# Read three text files (features.txt, X_test.txt, and X_train.txt)
library(tidyverse)
data_names <- read_table("C:/Users/tsqua/Desktop/final_project/features.txt", 
           col_names = F)
train_data <- read_table("C:/Users/tsqua/Desktop/final_project/train/X_train.txt", col_names = F)
test_data <- read_table("C:/Users/tsqua/Desktop/final_project/test/X_test.txt", col_names = F )


# Transpose the columns of features.txt into rows
library(stringr)
data_names_wider <- data_names %>% 
  mutate(X2 = row_number(), 
         X3 = "X", 
         X4 = as.character(X2), 
         X5 = str_c(X3, X4), 
         X6 = str_split_fixed(X1, pattern = " ", n = 2),
         X7 = X6[,2]) %>% 
  select(X1, X5) %>% 
  pivot_wider(names_from = X5, values_from = X1)

# Merge three datasets
complete_data <- rbind(data_names_wider, train_data, test_data)

# Make the first row as column names
library(janitor)
complete_data <- complete_data %>% 
  row_to_names(row_number = 1, remove_row = T)

# Change all column types from character to numeric
complete_data <- complete_data %>% 
  mutate_if(is.character, as.numeric)
glimpse(complete_data)

# Measurements on Mean and Standard Deviation Only
mean_std_only <- complete_data %>% 
  select(contains("mean()") | contains("std()")) 
glimpse(mean_std_only)

# Independent Tiday Data Set with the Average of each Variable (66 in Total)
tidy_mean <- as_tibble(map_dbl(mean_std_only, mean))
tidy_mean <- tidy_mean %>% 
  rename(avg_each_variable = value)

#Write the Independent Tidy Data
write.table(tidy_mean, 
            file = "C:/Users/tsqua/Desktop/final_project/tidy_data.txt", 
            row.names = F)
