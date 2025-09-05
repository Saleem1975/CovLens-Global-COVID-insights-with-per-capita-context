CREATE DATABASE COVID_19;
-- Use your target database first
-- USE COVID_19;

IF OBJECT_ID('dbo.CovidDeaths','U') IS NOT NULL
    DROP TABLE dbo.CovidDeaths;

CREATE TABLE dbo.CovidDeaths (
    iso_code                             NVARCHAR(15)  NULL,
    continent                            NVARCHAR(50)  NULL,
    location                             NVARCHAR(150) NULL,
    [date]                               DATE          NOT NULL,

    total_cases                          FLOAT NULL,
    new_cases                            FLOAT NULL,
    new_cases_smoothed                   FLOAT NULL,
    total_deaths                         FLOAT NULL,
    new_deaths                           FLOAT NULL,
    new_deaths_smoothed                  FLOAT NULL,

    total_cases_per_million              FLOAT NULL,
    new_cases_per_million                FLOAT NULL,
    new_cases_smoothed_per_million       FLOAT NULL,
    total_deaths_per_million             FLOAT NULL,
    new_deaths_per_million               FLOAT NULL,
    new_deaths_smoothed_per_million      FLOAT NULL,

    stringency_index                     FLOAT NULL,
    population                           FLOAT NULL,
    population_density                   FLOAT NULL,
    median_age                           FLOAT NULL,
    aged_65_older                        FLOAT NULL,
    aged_70_older                        FLOAT NULL,
    gdp_per_capita                       FLOAT NULL
);

BULK INSERT dbo.CovidDeaths
FROM 'C:\Users\linke\OneDrive - AL-Hussien bin Abdullah Technical University\Desktop\Current research\Data Analytics portfolio\Covid\CovidDeaths.csv'   -- <-- change to your real path
WITH (
    FIRSTROW = 2,                -- skip header row
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',      -- try '0x0d0a' if needed
    FIELDQUOTE = '"',            -- handle quoted fields
    CODEPAGE = '65001',          -- UTF-8
    TABLOCK,
    KEEPNULLS,                   -- keep blanks as NULL
    MAXERRORS = 5000
);

CREATE TABLE dbo.CovidVaccinations (
    iso_code                   NVARCHAR(15)   NULL,
    continent                  NVARCHAR(50)   NULL,
    location                   NVARCHAR(150)  NULL,
    [date]                     DATE           NOT NULL,

    stringency_index           FLOAT NULL,
    population_density         FLOAT NULL,
    median_age                 FLOAT NULL,
    aged_65_older              FLOAT NULL,
    aged_70_older              FLOAT NULL,
    gdp_per_capita             FLOAT NULL,
    extreme_poverty            FLOAT NULL,
    cardiovasc_death_rate      FLOAT NULL,
    diabetes_prevalence        FLOAT NULL,
    handwashing_facilities     FLOAT NULL,
    hospital_beds_per_thousand FLOAT NULL,
    life_expectancy            FLOAT NULL,
    human_development_index    FLOAT NULL
);

BULK INSERT dbo.CovidVaccinations
FROM 'C:\Users\linke\OneDrive - AL-Hussien bin Abdullah Technical University\Desktop\Current research\Data Analytics portfolio\Covid\CovidVaccinations.csv'   -- <-- replace with your real path
WITH (
    FIRSTROW = 2,                -- skip header row
    FIELDTERMINATOR = ',',       -- CSV delimiter
    ROWTERMINATOR = '0x0a',      -- LF; if it fails try '0x0d0a'
    FIELDQUOTE = '"',            -- handle quoted text
    CODEPAGE = '65001',          -- UTF-8 encoding
    TABLOCK,
    KEEPNULLS,
    MAXERRORS = 5000
);
select * from dbo.CovidDeaths