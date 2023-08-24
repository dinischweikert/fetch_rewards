-- How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?

WITH BrandRanking AS (
    SELECT
        b.name AS brand_name,
        COUNT(r._id) AS receipts_scanned
    FROM
        receipts r
    JOIN
        rewardsReceiptItemList ri ON r._id = ri.receipt_id
    JOIN
        brands b ON ri.barcode = b.barcode
    WHERE
        r.dateScanned >= DATEADD(MONTH, -1, GETDATE())
    GROUP BY
        b.name
    ORDER BY
        receipts_scanned DESC
    LIMIT 5
)
SELECT
    br.name AS brand_rank_name,
    br.receipts_scanned AS recent_month_scanned,
    COALESCE(pm.receipts_scanned, 0) AS previous_month_scanned,
    CASE
        WHEN br.receipts_scanned > COALESCE(pm.receipts_scanned, 0) THEN 'Higher'
        WHEN br.receipts_scanned < COALESCE(pm.receipts_scanned, 0) THEN 'Lower'
        ELSE 'Same'
    END AS comparison
FROM
    BrandRanking br
LEFT JOIN (
    SELECT
        b.name,
        COUNT(r._id) AS receipts_scanned
    FROM
        receipts r
    JOIN
        rewardsReceiptItemList ri ON r._id = ri.receipt_id
    JOIN
        brands b ON ri.barcode = b.barcode
    WHERE
        r.dateScanned >= DATEADD(MONTH, -2, GETDATE())
        AND r.dateScanned < DATEADD(MONTH, -1, GETDATE())
    GROUP BY
        b.name
) pm ON br.name = pm.name
ORDER BY
    br.receipts_scanned DESC;
