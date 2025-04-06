# Crypto-real-time-Price-Tracking---GCP
---------------------------------------------------------------------------------------------------------------------
Crypto Trade Tracker is a real-time cryptocurrency price tracking and alert system for the BTC-USDT trading pair. It leverages Google Cloud Platform (GCP) services to ingest, process, and analyze trade data from the OKX exchange, store it in BigQuery, and visualize it in Looker Studio. The system provides actionable insights through metrics like average price, trade volume, buy/sell ratios, price volatility, and alerts for significant price changes.
-----------------------------------

**Features :** 

- **Real-Time Data Ingestion:** Fetches trade data from the OKX API using Cloud Functions.
- **Data Processing Pipeline:** Processes raw trade data through Pub/Sub and Dataflow, storing it in BigQuery.
- **Metrics Calculation:** Computes metrics such as:
avg_price, total_qty, trade_count, buy_trade_count, high, low
price_volatility, buy_sell_ratio, trade_frequency, cumulative_volume, price_change_direction
alert for price changes exceeding 5% within a minute.
- **Incremental Updates:** Uses scheduled BigQuery MERGE queries to update metrics every minute.
- **Visualization:** Displays metrics in a Looker Studio dashboard with interactive charts and filters.

---------------------------------
**Architecture**
The system follows a serverless, event-driven architecture on GCP:

- **OKX API:** Fetches real-time trade data for BTC-USDT.
- **Cloud Functions (fetch_okx_trades):** Periodically calls the OKX API and publishes raw trade data to Pub/Sub.
- **Pub/Sub:** Acts as a message queue to buffer trade data.
- **Dataflow:** Processes raw trade data and writes it to BigQuery (raw_trades table).
- **BigQuery:**
-- raw_trades: Stores raw trade data.
-- processed: Deduplicated and transformed trade data.
-- metrics: Aggregated metrics updated every minute.
- **Looker Studio:** Visualizes metrics with charts, scorecards, and tables.

---------------------------------------------------------------------------------------------------------------------
Prerequisites
A Google Cloud Platform (GCP) account with billing enabled.
Access to the OKX API (API key, secret, and passphrase).
Basic familiarity with GCP Console, BigQuery, and Looker Studio.
