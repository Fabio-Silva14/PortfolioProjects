-- first and last agreement signing date
SELECT DISTINCT
	MIN(Agreement_Signing_Date) AS first_agr_date,
	MAX(Agreement_Signing_Date) AS last_agr_date
FROM 
	Finance
WHERE
	Agreement_Signing_Date IS NOT NULL

------------------------------
-- name of regions
SELECT DISTINCT
	Region
FROM
	Finance

-----------------------------
SELECT DISTINCT
	Credit_Status 
FROM
	Finance


-- number of each loan status by region
SELECT
	Region,
	Credit_Status,
	COUNT(Credit_Status) AS amount_credits_in_status 
FROM
	Finance
GROUP BY
	Region,
	Credit_Status
ORDER BY
	Region,
	amount_credits_in_status DESC


-----------------------------
-- number of each loan status
SELECT
	Credit_Status,
	COUNT(Credit_Status) AS amount_credits_in_status 
FROM
	Finance
GROUP BY
	Credit_Status
ORDER BY 
	amount_credits_in_status DESC


-----------------------------
-- sum of original principal amount and average by region 
SELECT
	Region,
	SUM(Original_Principal_Amount) AS sum_original_prin_amount,
	AVG(Original_Principal_Amount) AS avg_original_prin_amount
FROM
	Finance
GROUP BY
	Region
ORDER BY 
	sum_original_prin_amount DESC,
	avg_original_prin_amount DESC


-----------------------------
-- most frequent currency 
SELECT
	Currency_of_Commitment,
	COUNT(Currency_of_Commitment) AS number_times_curr 
FROM
	Finance
GROUP BY
	Currency_of_Commitment
ORDER BY
	number_times_curr DESC


-----------------------------
-- number of times each currency showed by region 
SELECT
	Region,
	Currency_of_Commitment,
	COUNT(Currency_of_Commitment) AS number_times_curr 
FROM
	Finance
GROUP BY
	Region,
	Currency_of_Commitment
ORDER BY
	Region,
	number_times_curr DESC


-----------------------------
-- Amount repaid to IDA by region 
SELECT
	Region,
	SUM(Repaid_to_IDA) AS total_amount_repaid
FROM
	Finance
GROUP BY
	Region
ORDER BY
	total_amount_repaid DESC


-----------------------------
-- Average % amount that was repaid to IDA in relation to the original principal amount by region
SELECT
	Region,
	SUM(Original_Principal_Amount) AS total_original_amount,
	SUM(Repaid_to_IDA) AS total_amount_repaid,
	(SUM(Repaid_to_IDA) / SUM(Original_Principal_Amount)) * 100 AS relation_btw_orig_and_repaid
FROM
	Finance
GROUP BY
	Region
ORDER BY
	relation_btw_orig_and_repaid DESC

