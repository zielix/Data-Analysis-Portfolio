-- Heaviest Hitters --
------ Highest average weight of teams per year -----
SELECT ROUND(AVG(people.weight), 2) AS avg_weight,
    teams.name AS team,
		batting.yearid AS year
FROM people
INNER JOIN batting
		ON people.playerid = batting.playerid
INNER JOIN teams
		ON batting.team_id = teams.id
GROUP BY team, year
ORDER BY avg_weight DESC
LIMIT 5;
------------------------------------------------------

------ The heaviest player ---------------------------
SELECT namefirst AS 'first name',
	namelast AS 'last name',
	MAX(weight) AS weight
FROM people;
--------------- OR --------------

--- PostgreSQL solutions for the heaviest player,
--- because the above query does not work in PostgreSQL
SELECT namefirst AS "first name",
		namelast AS "last name",
    weight
FROM people
WHERE weight = (SELECT MAX(weight)
                FROM people);
-------------- OR ---------------
SELECT namefirst AS "first name",
		namelast AS "last name",
		weight
FROM people
WHERE weight IS NOT NULL
ORDER BY 3 DESC
LIMIT 1;

-----------------------------------------------------------------------------


-- Biggest Spenders --
----- Total salary per team and per year -----
SELECT SUM(salaries.salary) AS total_salary,
		teams.name AS team,
    salaries.yearid AS year
FROM salaries
INNER JOIN teams
		ON salaries.team_id = teams.id
    AND salaries.yearid = teams.yearid
GROUP BY team, year
ORDER BY total_salary DESC
LIMIT 5;
----------------------------------------------

----- The Most Expensive Player -----
WITH top_salary AS (
		SELECT *
		FROM salaries
		ORDER BY salary DESC
		LIMIT 5)
SELECT top_salary.salary AS salary,
	people.namefirst AS first_name,
	people.namelast AS last_name,
	teams.name AS team,
	top_salary.yearid AS year
FROM top_salary
JOIN people
		ON top_salary.playerid = people.playerid
JOIN teams
		ON top_salary.team_id = teams.id
		AND top_salary.yearid = teams.yearid;

-----------------------------------------------------------------------------

-- Most Bang For Their Buck --
--- Total salary of the team divided by the number of wins in a given year --
SELECT ROUND(SUM(salaries.salary) / teams.w) AS cost_per_win,
		teams.name AS team,
		teams.yearid AS year,
		SUM(salaries.salary) AS total_salary,
		teams.w AS wins
FROM salaries
INNER JOIN teams
	ON salaries.teamid = teams.teamid
	AND salaries.yearid = teams.yearid
WHERE teams.yearid >= 2001
GROUP BY team, wins, year
ORDER BY cost_per_win
LIMIT 5;

-----------------------------------------------------------------------------

-- Granny Awards --
----- Oldest player -----
SELECT extract(year from age(finalgame_date, birth_date)) AS age,
		namefirst AS first_name,
		namelast AS last_name,
		birth_date,
		finalgame_date,
		teams.name AS team
FROM people
INNER JOIN appearances
		ON people.playerid = appearances.playerid
		AND extract(year from people.finalgame_date) = appearances.yearid
INNER JOIN teams
		ON appearances.team_id = teams.id
WHERE age(finalgame_date, birth_date) IS NOT NULL
ORDER BY 1 DESC
LIMIT 5;

-----------------------------------------------------------------------------

-- Awards Factory --
----- The sum of the rewards received by players born in the given city -----
SELECT p.birthcity,
    COUNT(a.playerid) AS total_awards
FROM awardsplayers a
JOIN people p
    ON a.playerid = p.playerid
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-----------------------------------------------------------------------------
