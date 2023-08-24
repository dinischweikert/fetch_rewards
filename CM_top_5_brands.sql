-- Top 5 brands by receipts scanned for the most recent month

SELECT
	b.name AS brand_name,
	COUNT(r._id) AS receipts_scanned
FROM
	receipts r
JOIN
--assuming there is a receipt_id in the rewardsReceiptItemList relational dataset
	rewardsReceiptItemList ri on r._id = ri.receipt_id 
JOIN brands b ON itemList.barcode = b.barcode
WHERE r. dateScanned >= DATEADD(MONTH, -1, GETDATE())
GROUP BY b.name
ORDER BY receipts_scanned DESC
LIMIT 5;

