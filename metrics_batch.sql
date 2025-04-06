CREATE OR REPLACE TABLE `crypto-trade-tracker-1.trades.metrics` AS
WITH Aggregated AS (
  SELECT
    TIMESTAMP_TRUNC(trade_time, MINUTE) AS window_start,
    AVG(price) AS avg_price,
    SUM(qty) AS total_qty,
    COUNT(*) AS trade_count,
    SUM(IF(is_buy, 1, 0)) AS buy_trade_count,
    MAX(price) AS high,
    MIN(price) AS low,
    STDDEV(price) AS price_volatility,
    SAFE_DIVIDE(SUM(IF(is_buy, qty, 0)), SUM(IF(NOT is_buy, qty, 0))) AS buy_sell_ratio,
    COUNT(*) / 60.0 AS trade_frequency
  FROM `crypto-trade-tracker-1.trades.processed`
  WHERE trade_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 DAY)
  GROUP BY TIMESTAMP_TRUNC(trade_time, MINUTE)
),
EnrichedData AS (
  SELECT
    window_start,
    avg_price,
    total_qty,
    trade_count,
    buy_trade_count,
    high,
    low,
    price_volatility,
    buy_sell_ratio,
    trade_frequency,
    SUM(total_qty) OVER (ORDER BY window_start) AS cumulative_volume,
    IF(
      avg_price > LAG(avg_price) OVER (ORDER BY window_start),
      'up',
      IF(avg_price < LAG(avg_price) OVER (ORDER BY window_start), 'down', 'neutral')
    ) AS price_change_direction,
    IF(
      ABS(
        (avg_price - LAG(avg_price) OVER (ORDER BY window_start))
        / LAG(avg_price) OVER (ORDER BY window_start) * 100
      ) > 5, 'yes', 'no'
    ) AS alert
  FROM Aggregated
)
SELECT * FROM EnrichedData
ORDER BY window_start DESC