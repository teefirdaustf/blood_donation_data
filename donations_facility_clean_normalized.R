# installing tidyverse package
install.packages('tidyverse')

# loading libraries
library(tidyverse) # Includes dplyr, ggplot2, and others

# reading/importing the dataset
df <- read.csv("donations_facility_dirty.csv")

# View initial structure
str(df)
summary(df)
glimpse(df) # observation --> $date feature is in <chr> dtype (should be date format)

# finding out current working directory
#getwd()

# since the working directory was wrong initially, setting the correct wd
#setwd('/Users/tengkufirdaus/Desktop/Developments/blood_donation_data/')


# Checking Missing Values

# Count missing values per column
colSums(is.na(df)) #observation --> $daily has 9701 null values, rest are OK
# Percentage of missing values per column
colMeans(is.na(df)) * 100 #observation --> $daily's null values equates to 5% of the data

# Check for duplicate rows

# Check for duplicate rows
sum(duplicated(df)) #observation --> 32674 duplicates found

# Explore numeric columns

# Summary statistics for numeric columns
df %>%
  summarise(across(where(is.numeric), list(mean = mean, sd = sd, min = min, max = max), na.rm = TRUE))
# Boxplots to detect outliers
# observations --> $daily, $donations_new, $location_mobile, $social_civilian and $type_wholeblood seem to have outliers
df %>%
  select(where(is.numeric)) %>%
  gather(key = "variable", value = "value") %>%
  ggplot(aes(x = variable, y = value)) +
  geom_boxplot() +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Rotates the x-axis labels

# Cleaning Process of the Data

#Handling missing values in $daily

# Since $daily is the sum of all 4 bllod types, we replace missing values in 'daily' with the sum of blood types
df <- df %>%
  mutate(daily = ifelse(is.na(daily),
                        blood_a + blood_b + blood_o + blood_ab,
                        daily))

# verify mutation
sum(is.na(df$daily)) #observation --> no more missing values in the data

# Handling duplicate records

df <- df %>% distinct()
#verify change
sum(duplicated(df)) #observation --> 0 duplicates found

#Normalize text data

df$hospital <- df$hospital %>%
  str_replace_all("[@#!]", "") %>% # Remove special characters
  str_to_title()                  # Convert to title case
#verify change
view(df) #observation --> OK

#Normalize numerical data

# Applying min-max scaling to all numeric columns
min_max_scaler <- function(x) {
  (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}

df_scaled <- df %>%
  mutate(across(where(is.numeric), ~ min_max_scaler(.)))
#verify change
summary(df_scaled)

# Reformatting data type

# Convert 'date' to Date format
df$date <- as.Date(df$date, format = "%Y-%m-%d")

# Convert 'hospital' to factor
df$hospital <- as.factor(df$hospital)

# Verify structure
str(df)
