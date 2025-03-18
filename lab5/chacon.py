import json
import pandas as pd

with open("C:/Users/mikai/Downloads/DS2002-json-practice/data/schacon.repos.json", "r") as file:
    data = json.load(file)

df = pd.json_normalize(data)

df_column = df[["name", "html_url", "updated_at", "visibility"]]

df_column.head(5).to_csv("chacon.csv", index = False, header = False)