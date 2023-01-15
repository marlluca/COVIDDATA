--1

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_Cases)*100 
as DeathPercentage 
FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
--Group by date
order by 1,2


--2. 
SELECT Location, SUM(Cast(new_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--Where location like '%states%' 
Where continent is null
and location not in ('World', 'European Union' , 'International')
GROUP by Location
order by TotalDeathCount desc


--3 
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_Cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc 

--4 
SELECT Location, Population, date, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by location, Population, date
order by PercentPopulationInfected desc

--5 
SELECT dea.continent, dea.location, dea.date, dea.population
, Max(vac.total_vaccinations) as RollingPeopleVaccinated
-- (RollingPeopleVaccinates/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacs vac
On dea.location = vac.location
and dea.date =vac.date
where dea.continent is not null
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3


--6. 
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as 
DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2 

--7.
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
Order by TotalDeathCount desc

--8 
Select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
Group by Location, Population
Order by PercentPopulationInfected desc

--9
Select Location, date, population, total_cases, total_deaths
FROM PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--10
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVacs vac
ON dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
FROM PopvsVac

--11
SELECT Location, Population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc