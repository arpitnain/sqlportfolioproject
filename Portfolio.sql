Select *
FROM Portfolio_Project..CovidDeaths
Order By 3,4

--Select *
--From Portfolio_Project..CovidVaccinations
--Order By 3,4

Select location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project..CovidDeaths
Order by 1,2

-- Checking total cases vs total deaths

Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 AS DeathPercantage
FROM Portfolio_Project..CovidDeaths
where location = 'India'
Order by 1,2 desc

-- Checking total cases vs total population

Select location, date,population, total_cases, (total_cases/population)*100 AS InfectedPercentage
FROM Portfolio_Project..CovidDeaths
where location = 'India'
Order by 1,2 

-- Checking country with highest infection rate vs population

Select location,population, max(total_cases) as HighestInfectionCount, (Max(total_cases)/population)*100 AS PercentPopulationInfected
FROM Portfolio_Project..CovidDeaths
Group by location,population
Order by PercentPopulationInfected desc

-- Checking country with highest deathcount per population

Select location,MAX(cast (total_deaths as int)) as TotalDeathCount
FROM Portfolio_Project..CovidDeaths
where continent is not null
Group by location
Order by TotalDeathCount desc

----

--Select total population vs total vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.date,dea.location) as rolling_people_vaccinated
from Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- CTE creation

With PopvsVac (continent,location, date,population,new_vaccinations,rolling_people_vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.date,dea.location) as rolling_people_vaccinated
from Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
Select *,(rolling_people_vaccinated/population)*100
from PopvsVac

--


