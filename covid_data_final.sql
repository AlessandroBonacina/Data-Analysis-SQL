# Database

Select*
From Covid.deaths
order by 3,4

# Selection of Data

Select location, date, total_cases, new_cases, total_deaths, population
From Covid.deaths
order by 1,2

# Total Cases vs Total Deaths + Death Percentage (All Countries and One Country)

Select location, MAX(total_cases) as tot_cases, MAX(total_deaths) as tot_deaths, (MAX(total_deaths)/MAX(total_cases))*100 as deaths_percentage
From Covid.deaths
Where continent is not null
Group by location 
order by 1,2

Select location, MAX(total_cases) as tot_cases, MAX(total_deaths) as tot_deaths, (MAX(total_deaths)/MAX(total_cases))*100 as deaths_percentage
From Covid.deaths
Where continent is not null and location like '%Italy%'
Group by location
order by 1,2

# Total Cases vs Population (All Countries and One Country)

Select location, population, MAX(total_cases) as tot_cases,  (MAX(total_cases)/population)*100 as cases_percentage
From Covid.deaths
Where continent is not null
Group by location, population
order by 1,2

Select location, population, MAX(total_cases) as tot_cases,  (MAX(total_cases)/population)*100 as cases_percentage
From Covid.deaths
Where continent is not null and location like '%Italy%'
Group by location, population
order by 1,2

# Countries with highest infection rate compared to the population (All contries and Countries with 1M+ people)

Select location, population, MAX(total_cases) as InfectionCount, MAX((total_cases/population))*100 as cases_percentage
From Covid.deaths
Where continent is not null
GROUP BY location, population
order by cases_percentage desc

Select location, population, MAX(total_cases) as InfectionCount, MAX((total_cases/population))*100 as cases_percentage
From Covid.deaths
Where population > 1000000 and continent is not null
GROUP BY location, population
order by cases_percentage desc

# Countries with highest death count

Select location, population, MAX(total_deaths) as death_count
From Covid.deaths
Where continent is not null
GROUP BY location, population
order by death_count desc

# Continents Data

Select location, population, MAX(total_deaths) as death_count
From Covid.deaths
Where continent is null AND location not like '%income%' and location not like '%World%' and location not like '%Union'
GROUP BY location, population
order by death_count desc

# Data for different levels of income

Select location, population, MAX(total_deaths) as death_count
From Covid.deaths
Where continent is null AND location like '%income%'
GROUP BY location, population
order by death_count desc

# Cases by Day (Global)

Select date, SUM(new_cases) as tot_cases, SUM(new_deaths) as tot_deaths, SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
From Covid.deaths
Where continent is not null AND new_cases > 0
group by date
order by 1,2

# Day with most cases (Global)

Select date, SUM(new_cases) as tot_cases, SUM(new_deaths) as tot_deaths
From Covid.deaths
Where continent is not null
group by date
order by tot_cases desc

# Cases by Year (Global)

Select EXTRACT(YEAR FROM date) as year, SUM(new_cases) as tot_cases, SUM(new_deaths) as tot_deaths
From Covid.deaths
Where continent is not null
group by year
order by 1,2

# Vaccination Data

Select *
From Covid.vax

# Join Tables

Select*
From Covid.deaths
Join Covid.vax
  On deaths.location = vax.location
  and deaths.date = vax.date

# New vaccinations per day

Select deaths.location, deaths.date, deaths.population, vax.new_vaccinations
From Covid.deaths
Join Covid.vax
  On deaths.location = vax.location
  and deaths.date = vax.date
Where deaths.continent is not null
Order by 1,2

# New vaccinations per day summed

Select deaths.location, deaths.date, deaths.population, vax.new_vaccinations, SUM(vax.new_vaccinations) OVER (PARTITION BY deaths.location order by deaths.location, deaths.date) as rolling_vaccinations
From Covid.deaths
Join Covid.vax
  On deaths.location = vax.location
  and deaths.date = vax.date
Where deaths.continent is not null
Order by 1,2

# Population vs Vaccination (with CTE)

With popvsvax as
(
Select deaths.location, deaths.date, deaths.population, vax.new_vaccinations, SUM(vax.new_vaccinations) OVER (PARTITION BY deaths.location order by deaths.location, deaths.date) as rolling_vaccinations
From Covid.deaths
Join Covid.vax
  On deaths.location = vax.location
  and deaths.date = vax.date
Where deaths.continent is not null
)
Select*
From popvsvax

With popvsvax as
(
Select deaths.location, deaths.date, deaths.population, vax.new_vaccinations, SUM(vax.new_vaccinations) OVER (PARTITION BY deaths.location order by deaths.location, deaths.date) as rolling_vax
From Covid.deaths
Join Covid.vax
  On deaths.location = vax.location
  and deaths.date = vax.date
Where deaths.continent is not null
)
Select*, (rolling_vax/population)*100 as vax_percentage
From popvsvax

# More vaccinations Data

Select*
From Covid.original
Where continent is not null
Order by location, date

Select location, date, total_vaccinations, people_fully_vaccinated, median_age, extreme_poverty, human_development_index
From Covid.original
Where continent is not null
Order by location, date

Select location, population, MAX(total_vaccinations) as total_vax, MAX(people_fully_vaccinated) as people_fully_vaxed, 
From Covid.original
Where continent is not null AND total_vaccinations is not null
GROUP BY location, population
Order by location

# Fully vaccinated people per country with percentage

Select location, population, MAX(people_fully_vaccinated) as people_fully_vaxed, (MAX(people_fully_vaccinated)/population)*100 as fully_vaxed_people_percentage 
From Covid.original
Where continent is not null AND people_fully_vaccinated is not null
GROUP BY location, population
Order by location

# Countries less vaccinated

Select location, population, MAX(people_fully_vaccinated) as people_fully_vaxed, (MAX(people_fully_vaccinated)/population)*100 as fully_vaxed_people_percentage 
From Covid.original
Where continent is not null AND people_fully_vaccinated is not null
GROUP BY location, population
Order by fully_vaxed_people_percentage

# Countries less vaccinated confronting with economic indicators

Select location, population, MAX(people_fully_vaccinated) as people_fully_vaxed, (MAX(people_fully_vaccinated)/population)*100 as fully_vaxed_people_percentage, human_development_index, extreme_poverty, gdp_per_capita
From Covid.original
Where continent is not null AND people_fully_vaccinated is not null
GROUP BY location, population, human_development_index, extreme_poverty, gdp_per_capita
Order by fully_vaxed_people_percentage

# Coutries more vaccinated (population > 500k)

Select location, population, MAX(people_fully_vaccinated) as people_fully_vaxed, (MAX(people_fully_vaccinated)/population)*100 as fully_vaxed_people_percentage, human_development_index, gdp_per_capita, extreme_poverty
From Covid.original
Where continent is not null AND people_fully_vaccinated is not null AND population > 500000
GROUP BY location, population, human_development_index, gdp_per_capita, extreme_poverty
Order by fully_vaxed_people_percentage desc

# Total vaccinations World

Select location, population, MAX(people_fully_vaccinated) as people_fully_vaxed,(MAX(people_fully_vaccinated)/population)*100 as fully_vaxed_people_percentage 
From Covid.original
Where continent is null AND location like '%World%'
GROUP BY location, population
order by location

# Vaccinations per continent

Select location, population, MAX(people_fully_vaccinated) as people_fully_vaxed,(MAX(people_fully_vaccinated)/population)*100 as fully_vaxed_people_percentage 
From Covid.original
Where continent is null and location not like '%income%' and location not like '%European%' and location not like '%World%'
GROUP BY location, population
order by location

# People fully vaccinated per day per country (All countries)

Select location, date, MAX(people_fully_vaccinated) as fully_vaxed, (people_fully_vaccinated/population)*100 as vaxed_percentage
From Covid.original
Where continent is not null
GROUP BY location, date, vaxed_percentage
order by location, date

# People fully vaccinated per day per country (Italy)

Select location, date, MAX(people_fully_vaccinated) as fully_vaxed, (people_fully_vaccinated/population)*100 as vaxed_percentage
From Covid.original
Where continent is not null and location like '%Italy%'
GROUP BY location, date, vaxed_percentage
order by location, date

# People fully vaccinated per day per country (Europe)

Select location, date, MAX(people_fully_vaccinated) as fully_vaxed, (people_fully_vaccinated/population)*100 as vaxed_percentage
From Covid.original
Where continent like '%Europe%'
GROUP BY location, date, vaxed_percentage
order by location, date
