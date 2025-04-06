INSERT INTO `crypto-trade-tracker-1.trades.processed` (trade_time, price, qty, trade_id, is_buy, processed_at)
SELECT
  TIMESTAMP_SECONDS(DIV(SAFE_CAST(JSON_EXTRACT_SCALAR(data, '$.time') AS INT64), 1000)) AS trade_time,
  CAST(JSON_EXTRACT_SCALAR(data, '$.price') AS FLOAT64) AS price,
  CAST(JSON_EXTRACT_SCALAR(data, '$.qty') AS FLOAT64) AS qty,
  CAST(JSON_EXTRACT_SCALAR(data, '$.id') AS STRING) AS trade_id,
  JSON_EXTRACT_SCALAR(data, '$.isBuy') = 'true' AS is_buy,
  CURRENT_TIMESTAMP() AS processed_at
FROM `crypto-trade-tracker-1.trades.raw_trades`,
UNNEST(JSON_EXTRACT_ARRAY(data)) AS data
WHERE NOT EXISTS (
  SELECT 1
  FROM `crypto-trade-tracker-1.trades.processed`
  WHERE trade_id = CAST(JSON_EXTRACT_SCALAR(data, '$.id') AS STRING)
)
AND TIMESTAMP_SECONDS(DIV(SAFE_CAST(JSON_EXTRACT_SCALAR(data, '$.time') AS INT64), 1000)) >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 5 MINUTE)