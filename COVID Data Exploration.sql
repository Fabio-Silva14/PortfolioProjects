-- dates go from 2020-02-24 until 2021-04-30

SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

-- Select data that I'm going to use
SELECT 
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	continent IS NOT NULL
ORDER BY 
	location, date



-- Looking at total cases vs total deaths
-- Shows the likelihood of dying if you contract covid in your country
SELECT 
	location, 
	date, 
	total_cases, 
	total_deaths, 
	(total_deaths/total_cases)*100 AS death_percentage
FROM 
	PortfolioProject..CovidDeaths
WHERE
	location LIKE '%states%' AND continent IS NOT NULL
ORDER BY 
	location, 
	date



-- Looking at total cases vs population
-- Shows what percentage of population got covid
SELECT 
	location, 
	date, 
	population,
	total_cases, 
	(total_cases/population)*100 AS percentage_population_infected
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	continent IS NOT NULL
ORDER BY 
	location, 
	date



-- Looking at countries with highest infection rate compared to population
SELECT 
	location,  
	population,
	MAX(total_cases) AS highest_infection_count, 
	MAX((total_cases/population))*100 AS percentage_population_infected
FROM 
	PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY
	location,
	population
ORDER BY 
	percentage_population_infected DESC



-- LET'S BREAK THINGS DOWN BY CONTINENT

-- Showing continents with the highest death count per population
SELECT 
	continent,  
	MAX(CAST(total_deaths as INT)) AS highest_deaths_count
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	continent IS NOT NULL
GROUP BY
	continent
ORDER BY 
	highest_deaths_count DESC



-- GLOBAL NUMBERS

SELECT 
	SUM(new_cases) AS total_cases,
	SUM(CAST(new_deaths AS INT)) AS total_deaths,
	(SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS total_death_percentage
FROM 
	PortfolioProject..CovidDeaths
WHERE
	continent IS NOT NULL
ORDER BY 
	1,2
	



-- Looking at total population vs vaccinations
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(INT, vac.new_vaccinations)) OVER 
		(PARTITION BY dea.location 
			ORDER BY 
				dea.location, 
				dea.date
	) AS rolling_people_vacinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL
ORDER BY
	2,3


-- USE CTE
WITH PopVsVac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
AS
(
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(INT, vac.new_vaccinations)) OVER 
		(PARTITION BY dea.location 
			ORDER BY 
				dea.location, 
				dea.date
	) AS rolling_people_vacinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL
)
SELECT 
	*,
	(rolling_people_vaccinated/population) * 100
FROM PopVsVac



-- TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent NVARCHAR(255),
location NVARCHAR(255),
population NUMERIC,
date datetime,
new_vaccinations NUMERIC,
rolling_people_vaccinated NUMERIC
)

SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(INT, vac.new_vaccinations)) OVER 
		(PARTITION BY dea.location 
			ORDER BY 
				dea.location, 
				dea.date
	) AS rolling_people_vacinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL


SELECT *,
	(rolling_people_vaccinated/population) * 100
FROM 
	#PercentPopulationVaccinated




-- Create view to store data for later visualizations
CREATE VIEW PercentagePopulationVaccinated AS
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(INT, vac.new_vaccinations)) OVER 
		(PARTITION BY dea.location 
			ORDER BY 
				dea.location, 
				dea.date
	) AS rolling_people_vacinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL
