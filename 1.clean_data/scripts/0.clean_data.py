#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pathlib

import numpy as np
import pandas as pd

# In[2]:


# set the path to the data
academic_data_path = pathlib.Path(
    "../../data/All_academic_projects_funded_by_NIH_.xlsx"
).resolve(strict=True)
output_data_path = pathlib.Path(
    "../../data/All_academic_projects_funded_by_NIH_cleaned.parquet"
).resolve()
# get the sheet names in the excel file
academic_data = pd.read_excel(academic_data_path, sheet_name="#205C", skiprows=2)
print(academic_data.shape)
academic_data.head()


# In[3]:


# drop activity codes that equal to 'Total'
academic_data = academic_data[academic_data["Activity Code"] != "Total"]
print(academic_data.shape)


# In[4]:


# move the Activity Code to the first column
academic_data.insert(0, "Activity Code", academic_data.pop("Activity Code"))
academic_data.head()


# In[5]:


academic_data["Mechanism/Funding Source"].value_counts()


# In[6]:


# keep only the Other Mechanisms - Direct and RPG - Direct for mechanisms
academic_data = academic_data[
    academic_data["Mechanism/Funding Source"].isin(
        ["Other Mechanisms - Direct", "RPG - Direct"]
    )
]
print(academic_data.shape)
academic_data.head()


# In[7]:


# remove OD COMMON FUND, FIC, OD ORIP
academic_data = academic_data[
    ~academic_data["Institute/Center"].isin(["OD COMMON FUND", "FIC", "OD ORIP"])
]
print(academic_data.shape)
academic_data.head()


# In[8]:


# write the cleaned data to a parquet file
academic_data.to_parquet(output_data_path, index=False)
