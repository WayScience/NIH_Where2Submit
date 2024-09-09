#!/usr/bin/env python
# coding: utf-8

# This notebook retrieves NIH Funding data from static files from the NIH webpage.

# In[1]:


import pathlib

import pandas as pd
import requests

# In[2]:


# set the path to where the data will be stored
data_path = pathlib.Path("../../data/").resolve()
data_path.mkdir(exist_ok=True, parents=True)


# In[3]:


# set a dictionary with the urls of the data
# dictionary makes the download process expandable
data_to_download = {
    "file_name": [],
    "file_url": [],
}
# add the urls to the dictionary
# academic projects funded by NIH
data_to_download["file_name"].append("All_academic_projects_funded_by_NIH_")
data_to_download["file_url"].append(
    "https://report.nih.gov/reportweb/web/displayreport?rId=601"
)


# In[4]:


for file_name, file_url in zip(
    data_to_download["file_name"], data_to_download["file_url"]
):
    # get the xls file from the url and save it to the data folder
    response = requests.get(file_url)
    with open(data_path / f"{file_name}.xlsx", "wb") as f:
        f.write(response.content)
