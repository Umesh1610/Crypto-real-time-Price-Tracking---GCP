CREATE TABLE `crypto-trade-tracker-1.trades.processed` (
  trade_time TIMESTAMP,
  price FLOAT,
  qty FLOAT,
  trade_id STRING,
  is_buy BOOLEAN,
  processed_at TIMESTAMP
)