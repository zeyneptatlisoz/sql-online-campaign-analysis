WITH all_data AS (
    SELECT
        f.ad_date,
        c.campaign_name,
        f.reach
    FROM facebook_ads_basic_daily AS f
    LEFT JOIN facebook_campaign AS c
        ON f.campaign_id = c.campaign_id

    UNION ALL

    SELECT
        g.ad_date,
        g.campaign_name,
        g.reach
    FROM google_ads_basic_daily AS g
),

monthly_data AS (
    SELECT
        DATE_TRUNC('month', ad_date)::date AS ad_month,
        campaign_name,
        SUM(reach) AS monthly_reach
    FROM all_data
    GROUP BY
        DATE_TRUNC('month', ad_date)::date,
        campaign_name
),

growth_data AS (
    SELECT
        ad_month,
        campaign_name,
        monthly_reach,
        monthly_reach - LAG(monthly_reach) OVER (
            PARTITION BY campaign_name
            ORDER BY ad_month
        ) AS monthly_growth
    FROM monthly_data
)

SELECT
    ad_month,
    campaign_name,
    monthly_reach,
    monthly_growth
FROM growth_data
WHERE ad_month = '2022-04-01'
  AND campaign_name = 'Hobbies';
