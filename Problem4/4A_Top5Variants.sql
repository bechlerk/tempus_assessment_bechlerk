/* Write a SQL query to identify the top 5 genetic variants that are most strongly associated with
the disease. The association is measured by the difference in the frequency of the variant
between diseased and healthy patients.*/

/* Use COALESCE to address NULL values in full outer join, i.e. cases where a variant might be present in only diseased
or only healthy patients */

SELECT
    COALESCE(d.variant_id, h.variant_id) AS variant_id,
    ROUND(COALESCE(d.diseased_frequency, 0), 3) AS diseased_frequency,
    ROUND(COALESCE(h.healthy_frequency, 0), 3) AS healthy_frequency,
    ROUND(ABS(COALESCE(d.diseased_frequency, 0) - COALESCE(h.healthy_frequency, 0)), 3) AS frequency_difference
FROM
    -- Calculate the frequency of each variant in diseased patients
    (
        SELECT
        variant_id,
        COUNT(*) * 1.0 /(
                SELECT
            COUNT(*)
        FROM
            patients
        WHERE
                    disease_status = 'diseased') AS diseased_frequency
    FROM
        patients
    WHERE
                disease_status = 'diseased'
    GROUP BY
                variant_id
    HAVING
                -- Limit to variants with at least 2 diseased patients to help with edge cases where number of variants is extremely rare.
                COUNT(*) >= 2) d
    FULL OUTER JOIN
    -- Calculate the frequency of each variant in healthy patients
    (
    SELECT
        variant_id,
        COUNT(*) * 1.0 /(
            SELECT
            COUNT(*)
        FROM
            patients
        WHERE
                disease_status = 'healthy') AS healthy_frequency
    FROM
        patients
    WHERE
            disease_status = 'healthy'
    GROUP BY
            variant_id
    HAVING
            -- Limit to varaints with at least 2 healthy patients to help with edge cases where number of variants is extremely rare.
            COUNT(*) >= 2) h ON d.variant_id = h.variant_id
ORDER BY
    -- Take the top 5 frequency_difference
    frequency_difference DESC
    LIMIT 5;

