/*
Procedures are the biggest cost to a hospital. There is a brand new Hospital Director who wants to know what medical specialties are doing the most number of procedures on average. 
Give the hospital director a list of the medical specialties that have an average number of procedure count above 2.5 with the total procedure count above 50.
*/

SELECT
	medical_specialty,
	CAST(ROUND(AVG(num_procedures),1) AS DECIMAL(18,2)) AS avg_num_procedures
FROM
	health
WHERE 
	NOT medical_specialty = '?'
GROUP BY
	medical_specialty
HAVING 
	COUNT(num_procedures) > 50 AND ROUND(AVG(num_procedures),1) > 2.5
ORDER BY
	avg_num_procedures DESC



--The nurse director needs to know if we are subconsciously treating races differently. Show the average number of lab procedures broken down by race.
SELECT
	demographics.race,
	AVG(num_lab_procedures) AS avg_num_lab_procedures
FROM
	health
INNER JOIN demographics
	ON health.patient_nbr = demographics.patient_nbr
GROUP BY
	demographics.race
HAVING
	demographics.race <> '?'
ORDER BY
	avg_num_lab_procedures DESC



--Your boss has asked you to explore the relationship between number of lab procedures and time spent in the hospital. Specifically, they asked for a few, average, and many procedure group.
SELECT
	num_lab_procedures,
	CASE 
		WHEN num_lab_procedures < 25 THEN 'few'
		WHEN num_lab_procedures < 50 THEN 'average'
		ELSE 'many'
	END AS 
		procedure_frequency
FROM 
	health


;WITH cte AS
(
	SELECT
		time_in_hospital,
		CASE 
			WHEN num_lab_procedures < 25 THEN 'few'
			WHEN num_lab_procedures < 50 THEN 'average'
			ELSE 'many'
		END AS 
		procedure_frequency
	FROM 
		health
)
SELECT
	CAST(ROUND(AVG(time_in_hospital),1) AS DECIMAL(18,2)) AS avg_time,
	procedure_frequency
FROM
	cte
GROUP BY
	procedure_frequency
ORDER BY
	avg_time DESC



--Research needs a list of all patient numbers who are African-America or have a "Up" to metformin
SELECT DISTINCT
	demographics.patient_nbr
FROM
	demographics
INNER JOIN health
	ON  demographics.patient_nbr = health.patient_nbr
WHERE
	race = 'AfricanAmerican' OR health.metformin = 'Up' 


SELECT
	patient_nbr
FROM
	demographics
WHERE
	race = 'AfricanAmerican' 
UNION
SELECT
	patient_nbr
FROM
	health
WHERE
	metformin = 'Up'


--Provide a list of all patients who had an emergency but left the hospital faster than the average.
--The Hospital Administrator wants to highlight some of the biggest success stories of the hospital. They are looking for opportunities when patients came into the hospital with an emergency (admission_type_id of 1) but stayed less than the average time in the hospital.
SELECT 
	patient_nbr
FROM
	health
WHERE
	admission_type_id = 1 AND time_in_hospital < (SELECT AVG(time_in_hospital) FROM health)



;WITH cte AS (
	SELECT
		AVG(time_in_hospital) AS avg_time
	FROM
		health
)
SELECT
	patient_nbr
FROM
	health
WHERE
	admission_type_id = 1 AND time_in_hospital < (SELECT * FROM cte)
	


--Our boss has asked us to write a summary for the top 50 medication patients, break any ties with the number of lab procedures  (highest at the top). But they want a written summary.

SELECT TOP 50
	CONCAT('Patient ', patient_nbr, ' had ', SUM(num_medications), ' medications and ', SUM(num_lab_procedures), ' lab_procedures.') AS summary
FROM
	health
GROUP BY
	patient_nbr
ORDER BY
	SUM(num_medications) DESC,
	SUM(num_lab_procedures) DESC