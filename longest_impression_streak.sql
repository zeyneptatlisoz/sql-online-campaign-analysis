WITH all_data AS (
    SELECT
        f.ad_date,
        a.adset_name,
        f.impressions
    FROM facebook_ads_basic_daily AS f
    LEFT JOIN facebook_adset AS a
        ON f.adset_id = a.adset_id

    UNION ALL

    SELECT
        ad_date,
        adset_name,
        impressions
    FROM google_ads_basic_daily
),

daily_data AS (
    SELECT
        ad_date,
        adset_name,
        SUM(impressions) AS total_impressions
    FROM all_data
    WHERE ad_date IS NOT NULL
      AND adset_name IS NOT NULL
    GROUP BY
        ad_date,
        adset_name
    HAVING SUM(impressions) > 0
),

numbered_data AS (
    SELECT
        ad_date,
        adset_name,
        ROW_NUMBER() OVER (
            PARTITION BY adset_name
            ORDER BY ad_date
        ) AS rn
    FROM daily_data
),

grouped_data AS (
    SELECT
        ad_date,
        adset_name,
        ad_date - rn::int AS group_date
    FROM numbered_data
),

streaks AS (
    SELECT
        adset_name,
        group_date,
        MIN(ad_date) AS streak_start,
        MAX(ad_date) AS streak_end,
        COUNT(*) AS streak_length
    FROM grouped_data
    GROUP BY
        adset_name,
        group_date
)

SELECT
    adset_name,
    streak_start,
    streak_end,
    streak_length
FROM streaks
ORDER BY streak_length DESC
LIMIT 1;
