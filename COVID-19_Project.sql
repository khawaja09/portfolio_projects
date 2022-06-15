

select * from
PortfolioProject..covidDeaths$
order by 4

-- max new_cases in a day

--country with heighest infection Rate compared to Population

select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as InfectedRate
from PortfolioProject..covidDeaths$
group by location, population
order by InfectedRate desc

-- showing countries with highest death count per Population

select location, population, max(total_deaths) as HighestInfectionCount, max((total_deaths/population))*100 as DeathRateperPopulation
from PortfolioProject..covidDeaths$
group by location, population
order by DeathRateperPopulation desc

-- breakdown by continent

select location, max(convert(int,total_cases)) as totalCases, max(convert(int,total_deaths)) as totalDeaths
from PortfolioProject..covidDeaths$
where continent is null
group by location

order by totalDeaths desc

-- total deaths and total cases in pakistan

select location, max(convert(int,total_cases)) as totalCases, max(convert(int,total_deaths)) as totalDeaths
from PortfolioProject..covidDeaths$
group by location
having location = 'Pakistan'

-- on which date and location maximum cases recorded

select location, date, max(convert(int,new_cases)) as HighestCasesinSingleDay
from PortfolioProject..covidDeaths$
where continent is not null
group by location, date
order by HighestCasesinSingleDay desc

select * from PortfolioProject..covidDeaths$
where new_cases = (select max(convert(int, new_cases)) from PortfolioProject..covidDeaths$ where continent is not null)

-- INNER JOIN COVID DEATHS AND COVID VACCINATIONS

select dea.continent, dea.population, dea.date, dea.location, vacc.new_vaccinations from
PortfolioProject..covidDeaths$ as dea INNER JOIN PortfolioProject..covidVaccination$ as vacc
ON
dea.date = vacc.date and
dea.location = vacc.location
WHERE dea.continent is not null

-- total population vs vaccination

select dea.continent, dea.location, dea.population, dea.date, vacc.new_vaccinations, 
sum(convert(int,vacc.new_vaccinations)) over (Partition by dea.location Order by dea.location, dea.date) 
from PortfolioProject..covidDeaths$ as dea 
JOIN PortfolioProject..covidVaccination$ as vacc
	ON dea.location = vacc.location
	and dea.date = vacc.date
WHERE dea.continent is not null
order by 2,3

-- CTE

with PopvsVac(Continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.population, dea.date, vacc.new_vaccinations, 
SUM(CAST(vacc.new_vaccinations AS BIGINT)) over (Partition by dea.location Order by dea.location, dea.date) 
as RollingPeopleVaccinated
from PortfolioProject..covidDeaths$ as dea 
JOIN PortfolioProject..covidVaccination$ as vacc
	ON dea.location = vacc.location
	and dea.date = vacc.date
WHERE dea.continent is not null
--order by 2,3
)
select * from PopvsVac

-- CREATE VIEW

CREATE VIEW percentPopulationvaccinated AS 
select dea.continent, dea.location, dea.population, dea.date, vacc.new_vaccinations, 
SUM(CAST(vacc.new_vaccinations AS BIGINT)) over (Partition by dea.location Order by dea.location, dea.date) 
as RollingPeopleVaccinated
from PortfolioProject..covidDeaths$ as dea 
JOIN PortfolioProject..covidVaccination$ as vacc
	ON dea.location = vacc.location
	and dea.date = vacc.date
WHERE dea.continent is not null
--order by 2,3

select * from percentPopulationvaccinated


-- create view for covid data 2022

create view CovidReport22 as
select dea.location, dea.population, dea.date, dea.new_cases, dea.new_deaths, vacc.new_vaccinations 
from PortfolioProject..covidDeaths$ as dea
JOIN PortfolioProject..covidVaccination$ as vacc
	ON dea.location = vacc.location
	and dea.date = vacc.date
WHERE dea.date > '2021-12-31'

select * from CovidReport22


-- display views
SELECT 
OBJECT_SCHEMA_NAME(o.object_id) schema_name,o.name
FROM
sys.objects as o
WHERE
o.type = 'V';


