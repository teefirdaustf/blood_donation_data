import pandas as pd

# loading the original dataset
df = pd.read_csv("donations_facility.csv")

# saving a copy of the unprocessed csv
df.to_csv("donations_facility_unprocessed.csv", index=False)


