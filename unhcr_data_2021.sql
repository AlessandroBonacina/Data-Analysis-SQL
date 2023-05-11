# UNHCR WORLD DATA ON REFUGEES
# Data Selection

Select*
From UNHCRdata.rdata2021
order by 3 desc, 1

# Refugees per year

Select Year, SUM(Refugees_) as Refugees,
From UNHCRdata.rdata2021
Group by Year
order by 1

# Year with more Refugees

Select Year, SUM(Refugees_) as Refugees,
From UNHCRdata.rdata2021
Group by Year
order by 2 desc

# Filter data for 2021

Select Year, SUM(Refugees_) as Refugees, SUM(Refugees_assisted_by_UNHCR) as Assited_by_UNHCR
From UNHCRdata.rdata2021
Where Year = 2021
Group by Year
order by 1

Select*
From UNHCRdata.rdata2021
Where Year = 2021
order by 3 desc, 1

# Selecting more relevat data

Select Country_or_territory_of_asylum_or_residence as Host, Country_or_territory_of_origin as Origin, Refugees_ as Refugees , Refugees_assisted_by_UNHCR
From UNHCRdata.rdata2021
Where Year = 2021
order by Host

# Total Refugees per Host (2021)

Select Country_or_territory_of_asylum_or_residence as Host, SUM(Refugees_) as Refugees, SUM(Refugees_assisted_by_UNHCR) as Assited_by_UNHCR
From UNHCRdata.rdata2021
Where Year = 2021
Group by Host
order by Host

# Total Refugees per Origin (2021)

Select Country_or_territory_of_origin as Origin, SUM(Refugees_) as Refugees, SUM(Refugees_assisted_by_UNHCR) as Assited_by_UNHCR
From UNHCRdata.rdata2021
Where Year = 2021
Group by Origin
order by Origin

# Most Refugees by Host (2021)

Select Country_or_territory_of_asylum_or_residence as Host, SUM(Refugees_) as Refugees, SUM(Refugees_assisted_by_UNHCR) as Assited_by_UNHCR
From UNHCRdata.rdata2021
Where Year = 2021
Group by Host
order by Refugees desc

# Most Refugees by Origin (2021)

Select Country_or_territory_of_origin as Origin, SUM(Refugees_) as Refugees, SUM(Refugees_assisted_by_UNHCR) as Assited_by_UNHCR
From UNHCRdata.rdata2021
Where Year = 2021
Group by Origin
order by Refugees desc

# Joining with World population data (2021)

Select Country_or_territory_of_asylum_or_residence as Host, _2021_last_updated as population, SUM(Refugees_) as Refugees, SUM(Refugees_assisted_by_UNHCR) as Assited_by_UNHCR
From UNHCRdata.rdata2021
Join UNHCRdata.worldpopulation2021
on rdata2021.Country_or_territory_of_asylum_or_residence = worldpopulation2021.country
Where Year = 2021
Group by rdata2021.Country_or_territory_of_asylum_or_residence, worldpopulation2021._2021_last_updated
order by rdata2021.Country_or_territory_of_asylum_or_residence 

# Percentage of Refugees on Population (2021)

Select Country_or_territory_of_asylum_or_residence as Host, _2021_last_updated as Population, SUM(Refugees_) as Refugees, (((SUM(Refugees_))/_2021_last_updated)*100) as Percentage
From UNHCRdata.rdata2021
Join UNHCRdata.worldpopulation2021
on rdata2021.Country_or_territory_of_asylum_or_residence = worldpopulation2021.country
Where Year = 2021
Group by rdata2021.Country_or_territory_of_asylum_or_residence, worldpopulation2021._2021_last_updated
order by rdata2021.Country_or_territory_of_asylum_or_residence

# Countries with more Refugees on the Population (2021)

Select Country_or_territory_of_asylum_or_residence as Host, _2021_last_updated as Population, SUM(Refugees_) as Refugees, (((SUM(Refugees_))/_2021_last_updated)*100) as Percentage
From UNHCRdata.rdata2021
Join UNHCRdata.worldpopulation2021
on rdata2021.Country_or_territory_of_asylum_or_residence = worldpopulation2021.country
Where Year = 2021 and _2021_last_updated > 100000
Group by rdata2021.Country_or_territory_of_asylum_or_residence, worldpopulation2021._2021_last_updated
order by 4 desc

# With Assisted percentage

Select Year, SUM(Refugees_) as Refugees, SUM(Refugees_assisted_by_UNHCR) as Assited_by_UNHCR, SUM(Refugees_assisted_by_UNHCR)/SUM(Refugees_)*100 as Refugees_assisted_percentage
From UNHCRdata.rdata2021
Where Year = 2021
Group by Year
order by 1

# Total Refugees per Host (2021)

Select Country_or_territory_of_asylum_or_residence as Host, SUM(Refugees_) as Refugees, SUM(Refugees_assisted_by_UNHCR) as Assited_by_UNHCR, SUM(Refugees_assisted_by_UNHCR)/SUM(Refugees_)*100 as Refugees_assisted_percentage
From UNHCRdata.rdata2021
Where Year = 2021 and Refugees_ > 0
Group by Host
order by Refugees desc

# Total Refugees per Origin (2021)

Select Country_or_territory_of_origin as Origin, SUM(Refugees_) as Refugees, SUM(Refugees_assisted_by_UNHCR) as Assited_by_UNHCR, SUM(Refugees_assisted_by_UNHCR)/SUM(Refugees_)*100 as Refugees_assisted_percentage
From UNHCRdata.rdata2021
Where Year = 2021 and Refugees_ > 0
Group by Origin
order by Refugees desc
