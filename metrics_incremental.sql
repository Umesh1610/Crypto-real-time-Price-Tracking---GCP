MERGE INTO `crypto-trade-tracker-1.trades.metrics` AS target
USING (
  WITH SourceData AS (
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
    WHERE trade_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 5 MINUTE)
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
    FROM SourceData
  )
  SELECT * FROM EnrichedData
) AS source
ON target.window_start = source.window_start
WHEN MATCHED THEN
  UPDATE SET
    avg_price = source.avg_price,
    total_qty = source.total_qty,
    trade_count = source.trade_count,
    buy_trade_count = source.buy_trade_count,
    high = source.high,
    low = source.low,
    price_volatility = source.price_volatility,
    buy_sell_ratio = source.buy_sell_ratio,
    trade_frequency = source.trade_frequency,
    cumulative_volume = source.cumulative_volume,
    price_change_direction = source.price_change_direction,
    alert = source.alert
WHEN NOT MATCHED THEN
  INSERT (window_start, avg_price, total_qty, trade_count, buy_trade_count, high, low, alert, price_volatility, buy_sell_ratio, trade_frequency, cumulative_volume, price_change_direction)
  VALUES (
    source.window_start,
    source.avg_price,
    source.total_qty,
    source.trade_count,
    source.buy_trade_count,
    source.high,
    source.low,
    source.alert,
    source.price_volatility,
    source.buy_sell_ratio,
    source.trade_frequency,
    source.cumulative_volume,
    source.price_change_direction
  )