# Creating a Dirty Dataset

## Overview
This document describes the process of introducing intentional anomalies into the `donations_facility.csv` dataset obtained from https://github.com/MoH-Malaysia/data-darah-public/blob/main/donations_facility.csv to simulate real-world data issues. The purpose of this process is to fulfil the requirements of a group project for the Programming Course undertaken in University Malaya. Data wrangling to clean the 'dirtied' data is expected to follow after this. 

## Dirtying Process

### 1. Introduced Missing Values
- **Columns Affected:** `daily`
- **Percentage of Missing Values:** 5% randomly removed.
- **Reason:** Missing data is common in real-world datasets due to incomplete records or errors in data entry.

### 2. Added Duplicate Rows
- **Number of Duplicates:** 5 random rows duplicated.
- **Reason:** Duplicate records can occur during data integration from multiple sources.

### 3. Corrupted Text Data
- **Columns Affected:** `hospital`
- **Issues Introduced:**
  - Randomized text case (e.g., upper/lower/mixed casing).
  - Added special characters (e.g., `#`, `@`, `!`).
- **Reason:** Text inconsistencies often arise from manual data entry or system limitations.

## Implementation

### Prerequisites
- **Python Libraries Required:** `pandas`, `numpy`
- Ensure Python and JupyterLab are installed and configured.

### Script to Dirty the Dataset
The script automates the process. Below is a sample workflow:

```python
import pandas as pd
import numpy as np

# Load the original dataset
df = pd.read_csv("donations_facility.csv")

# Save a clean backup (optional)
df.to_csv("donations_facility_unprocessed.csv", index=False)

# Verify changes made
df.shape
df.describe
df.info()
df.nunique().sum()
df.head(5)

# 1. Corrupt Text Data (Column: 'hospital')
# Randomize text casing and introduce some special characters
special_chars = ["#", "@", "!"]
def randomize_hospital_name(name):
    if pd.notnull(name):
        name = name.lower() if np.random.rand() > 0.5 else name.upper()
        if np.random.rand() > 0.7:
            name += np.random.choice(special_chars)
    return name
df["hospital"] = df["hospital"].apply(randomize_hospital_name)

# 2. Add Duplicate Rows
set_duplicates = df.sample(5)
df = pd.concat([df, set_duplicates])

# 3. Introduce Missing Values (Column: 'daily')
set_null = df.sample(frac=0.05).index
df.loc[set_null, "daily"] = np.nan

# Save the dirty dataset
filename = "donations_facility_dirty.csv"
dirty_df = df.to_csv(filename, index=False)
print(f"Dirty dataset saved as {filename}")
```

### Reproducibility
To recreate the dirty dataset:
1. Clone the repository containing this script.
2. Run the script in a Python environment:
   ```bash
   python dirty_dataset.py
   ```

This will generate a file called `donations_facility_dirty.csv` in the project directory.

## Notes
- The original dataset (`donations_facility_unprocessed.csv`) is preserved for comparison, somewhat 'clean' with noted minimal missing data in some columns etc.
- The dirty dataset reflects common data quality issues, making it suitable for testing data cleaning workflows.

