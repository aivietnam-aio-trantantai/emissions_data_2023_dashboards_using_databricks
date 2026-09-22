-- Global Carbon Emissions by Location Dataset 2023
SELECT
    latitude, 
    longitude, 
    `GHG emissions mtons CO2e` AS emissions
FROM emissions_data_2023

-- Emission_per_person
SELECT
    county_state_name,
    population,
    CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE) / population AS emissions_per_person_mtons
FROM emissions_data_2023
WHERE population > 0
ORDER BY emissions_per_person_mtons DESC

-- Total_emission_per_state
SELECT 
    state_abbr, 
    SUM(CAST(
        REPLACE(`GHG emissions mtons CO2e`, ',', '')
        AS DOUBLE
    )) AS total_emissions
    
FROM emissions_data_2023
GROUP BY state_abbr
ORDER BY total_emissions DESC
LIMIT 10


-- Top 10 states ranked by Greenhouse Gas Emissions Percentage
WITH state_emissions AS (
  SELECT
    state_abbr,
    SUM(CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE)) AS total_emissions
  FROM
    emissions_data_2023
  GROUP BY
    state_abbr
),
national_total AS (
  SELECT
    SUM(total_emissions) AS grand_total
  FROM
    state_emissions
),
top_10 AS (
  SELECT
    SUM(total_emissions) AS top_10_sum
  FROM
    (
      SELECT
        total_emissions
      FROM
        state_emissions
      ORDER BY
        total_emissions DESC
      LIMIT 10
    ) t
)
SELECT
  top_10_sum AS top_10_emissions,
  ROUND(top_10_sum / grand_total * 100, 2) AS top_10_pct_of_national
FROM
  national_total,
  top_10


-- Total_emission_per_state
SELECT 
  state_abbr, 
  SUM(CAST(
    REPLACE(`GHG emissions mtons CO2e`, ',', '')
    AS DOUBLE
  )) AS total_emissions
FROM emissions_data_2023
GROUP BY state_abbr
ORDER BY total_emissions DESC
LIMIT 10


-- County_shaming
SELECT
  `county_state_name`,
  `population`,
  SUM(CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE)) AS total_emissions
FROM
  emissions_data_2023
GROUP BY
  `county_state_name`,
  `population`
ORDER BY
  total_emissions DESC
LIMIT 10