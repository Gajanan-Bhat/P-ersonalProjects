use [PortfolioProject]
go
select * from [dbo].[CovidVaccinations]

select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
where continent is not null
order by 1,2

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%ndia' 
order by 1,2

select location,date,total_cases,population,(total_cases/population)*100 as Percentage
from CovidDeaths
where location like '%states'
order by 1,2

select location, population, max(total_cases) as HighestInfectionCount,max((total_cases/population))*100 as PercentagePopulationInfected 
from CovidDeaths
group by location,population
order by 1,2

select max(total_cases) 
from CovidDeaths
where location = 'Afghanistan'

select * from CovidDeaths

select location, max(total_deaths) as HighestDeathCount
from CovidDeaths
where continent is not null
group by location
order by HighestDeathCount 

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

---select continent,max(cast(total_deaths as int)) as TotalContinentDeath
select continent,max(total_deaths) as TotalContinentDeath
from CovidDeaths
where continent is not null
group by continent
order by 1,2
alter table CovidDeaths
add ToalDeathConti int

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

select * from CovidDeaths

select * from CovidVaccinations

select dea.location, dea.date,dea.total_cases, dea.population, vac.new_vaccinations
from CovidDeaths as dea
join CovidVaccinations as vac
on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
order by 1,2

select * from CovidVaccinations

select dea.location, dea.date,dea.population, sum(convert(int,vacsi.total_vaccinations)), OVER (Partition by dea.Location Order by dea.location, dea.Date),(sum(convert(int,vacsi.total_vaccinations))/dea.population) 
from CovidDeaths as dea
join CovidVaccinations as vacsi
on dea.location = vacsi.location
   and dea.date = vacsi.date
where dea.continent is not null
order by dea.location, dea.date

--using CTE
with PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac




create table #PercentPopulationVaccinated
(
Continent nvarchar(200),
Location nvarchar(200),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

select * from PercentPopulationVaccinated

















