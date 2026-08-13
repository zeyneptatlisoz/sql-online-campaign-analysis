WITH all_data AS (
    SELECT
        f.ad_date,
        'Facebook Ads' AS media_source,
        f.spend
    FROM facebook_ads_basic_daily AS f
    LEFT JOIN facebook_adset AS a
        ON f.adset_id = a.adset_id
    LEFT JOIN facebook_campaign AS c
        ON f.campaign_id = c.campaign_id

    UNION ALL

    SELECT
        g.ad_date,
        'Google Ads' AS media_source,
        g.spend
    FROM google_ads_basic_daily AS g
)

SELECT
    ad_date,
    media_source,
    AVG(spend) AS avg_spend,
    MAX(spend) AS max_spend,
    MIN(spend) AS min_spend
FROM all_data
GROUP BY
    ad_date,
    media_source
ORDER BY
    ad_date,
    media_source;
