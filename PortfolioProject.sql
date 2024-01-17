SELECT TOP 3 location, population , MAX(total_cases) as highestInfectionCount, max(total_cases/population)*100 AS InfectionRate
FROM Covid_Deaths
GROUP BY location , population
ORDER BY InfectionRate DESC;

--Showing Countries with the highest death count per population
SELECT location, max(cast(total_deaths as int)) as TotalDeathCount
FROM Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

--Death to case Ratio
SELECT Location , population, cast(total_deaths as int) AS Deaths, cast(totaL_cases as int) AS Cases, cast(total_deaths as float)/cast(total_cases as float) AS DeathRatio
FROM Covid_Deaths
ORDER BY DeathRatio DESC;

--LET'S BREAK THINGS DOWN BY CONTINENT
SELECT continent, max(cast(total_deaths as int)) as TotalDeathCount
FROM Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;


--Showing Countries with the highest death count per population
SELECT location, max(cast(total_deaths as int)) as TotalDeathCount
FROM Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

--Global Numbers
SELECT date,SUM(new_cases) AS NEW_CASES,SUM(new_deaths) AS NEW_DEATHS,
(SUM(new_deaths)/SUM(new_cases))*100 AS DeathPercentages
FROM Covid_Deaths
GROUP BY date
ORDER BY  DeathPercentages Desc;

--Global Numbers
SELECT SUM(new_cases) AS NEW_CASES,SUM(new_deaths) AS NEW_DEATHS,
(SUM(new_deaths)/SUM(new_cases))*100 AS DeathPercentages
FROM Covid_Deaths
ORDER BY  DeathPercentages Desc;

--Looking at Total Population vs Vaccination

SELECT dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
SUM(cast(vacc.new_vaccinations as bigint)) OVER (Partition by dea.location ORDER BY dea.location,dea.date)
FROM Covid_Deaths AS dea
JOIN Covid_vacc AS vacc
ON dea.date = vacc.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

SELECT dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
SUM(cast(vacc.new_vaccinations as bigint)) OVER (Partition by dea.location ORDER BY dea.location,dea.date)
FROM Covid_Deaths AS dea
JOIN Covid_vacc AS vacc
ON dea.date = vacc.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;


--USE CTE

WITH PopvsVac(continent,location,date,population,vaccinated,RollingPeopleVaccinated) AS
(
SELECT dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
SUM(cast(vacc.new_vaccinations as bigint)) OVER (Partition by dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinated
FROM Covid_Deaths AS dea
JOIN Covid_vacc AS vacc
ON dea.date = vacc.date
WHERE dea.continent IS NOT NULL)
SELECT *,(RollingPeopleVaccinated/population)*100 AS VaccineRate
FROM PopvsVac;

--TEMP TABLE

Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),location nvarchar(255),date datetime,population int,vaccinations int,rolling numeric
)

Insert Into  #PercentPopulationVaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
SUM(cast(vacc.new_vaccinations as bigint)) OVER (Partition by dea.location ORDER BY dea.location,dea.date)
FROM Covid_Deaths AS dea
JOIN Covid_vacc AS vacc
ON dea.date = vacc.date
WHERE dea.continent IS NOT NULL

SELECT *
From #PercentPopulationVaccinated;