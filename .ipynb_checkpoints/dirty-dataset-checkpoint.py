# importing necessary libraries/packages
import pandas as pd
import numpy as np

# loading the original dataset
df = pd.read_csv("donations_facility.csv")

# saving a copy of the unprocessed csv
df.to_csv("donations_facility_unprocessed.csv", index=False)

# varify changes made
df.shape
df.describe
df.info()
df.nunique().sum()
df.head(5)

# randomize text casing and introduce some special characters in the 'hospital' column values
special_chars = ["#", "@", "!"]
def randomize_hospital_name(name):
    if pd.notnull(name):
        name = name.lower() if np.random.rand() > 0.5 else name.upper()
        if np.random.rand() > 0.7:
            name += np.random.choice(special_chars)
    return name
df["hospital"] = df["hospital"].apply(randomize_hospital_name)

# randomly duplicate 5 rows
set_duplicates = df.sample(5)
df = pd.concat([df, set_duplicates])

# randomly set 5% of 'daily' column values to NaN
set_null = df.sample(frac=0.05).index
df.loc[set_null, "daily"] = np.nan



