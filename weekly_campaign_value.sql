WITH all_data AS (
    SELECT
        f.ad_date,
        c.campaign_name,
        f.value
    FROM facebook_ads_basic_daily AS f
    LEFT JOIN facebook_campaign AS c
        ON f.campaign_id = c.campaign_id

    UNION ALL

    SELECT
        ad_date,
        campaign_name,
        value
    FROM google_ads_basic_daily
)

SELECT
    DATE_TRUNC('week', ad_date)::date AS ad_week,
    campaign_name,
    SUM(value) AS total_value
FROM all_data
WHERE ad_date IS NOT NULL
  AND campaign_name IS NOT NULL
  AND value IS NOT NULL
GROUP BY
    ad_week,
    campaign_name
ORDER BY total_value DESC
LIMIT 1;
