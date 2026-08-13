WITH all_data AS (
    SELECT
        ad_date,
        spend,
        value
    FROM facebook_ads_basic_daily

    UNION ALL

    SELECT
        ad_date,
        spend,
        value
    FROM google_ads_basic_daily
)

SELECT
    ad_date,
    SUM(spend) AS total_spend,
    SUM(value) AS total_value,
    ROUND(
        (SUM(value) - SUM(spend)) * 100.0
        / NULLIF(SUM(spend), 0),
        2
    ) AS romi_percent
FROM all_data
GROUP BY ad_date
HAVING SUM(spend) > 0
ORDER BY romi_percent DESC
LIMIT 5;
