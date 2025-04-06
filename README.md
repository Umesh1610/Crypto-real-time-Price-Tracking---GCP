# 🚀 Crypto Trade Tracker

![Crypto Trade Tracker Architecture](https://raw.githubusercontent.com/your-username/crypto-trade-tracker/main/path-to-image/Crypto_Trade_Architecture.png)

> A real-time, serverless cryptocurrency trade tracking and alerting system built with Google Cloud Platform 🧠💹

---

## 📌 Description

**Crypto Trade Tracker** is a real-time BTC-USDT price tracking and alert system designed to monitor market trends and trigger alerts for significant changes. It fetches trade data from the OKX exchange and utilizes a full GCP pipeline for processing, storing, and visualizing data.

Built for analysts, crypto enthusiasts, and data engineers looking to integrate real-time insights with dashboards and alerts.

---

## ✨ Features

✅ **Real-Time Data Ingestion** — Automatically fetches BTC-USDT trade data via OKX API  
✅ **Serverless Architecture** — Fully cloud-native on GCP using Pub/Sub, Dataflow, and BigQuery  
✅ **Live Metrics & Alerts** — Detects anomalies like price spikes > 5% in a minute  
✅ **Looker Studio Dashboard** — Interactive, filterable real-time visualizations  
✅ **Scalable + Incremental** — Metrics update every minute using scheduled BigQuery queries  

---

## 🧱 Architecture Overview

📦 This event-driven pipeline includes:

1. **🔁 OKX API**  
   - Fetches BTC-USDT trade data.

2. **⚙️ Cloud Functions**  
   - Scheduled function sends data to Pub/Sub.

3. **🧩 Pub/Sub**  
   - Streams data to Dataflow.

4. **🛠️ Dataflow**  
   - Parses and transforms the data.

5. **🧮 BigQuery**  
   - Stores raw data + calculates metrics using scheduled SQL jobs.

6. **📊 Looker Studio**  
   - Visualizes KPIs in real time.

---

## 📈 Metrics Tracked

| Metric Name             | Description                                               |
|------------------------|-----------------------------------------------------------|
| `avg_price`            | Average price within the 1-min window                     |
| `total_qty`            | Total trade volume                                        |
| `trade_count`          | Number of trades                                          |
| `buy_trade_count`      | Number of buy-side trades                                 |
| `high` / `low`         | Highest and lowest prices in window                       |
| `price_volatility`     | Std. deviation of price                                   |
| `buy_sell_ratio`       | Ratio of buy volume to sell volume                        |
| `trade_frequency`      | Trades per second                                         |
| `cumulative_volume`    | Running total of volume                                   |
| `price_change_direction` | 'up', 'down', or 'neutral'                              |
| `alert`                | Triggered if price shifts > 5% within 1 minute            |

---

## 📊 Dashboard Preview

**Looker Studio Dashboard** includes:

- 📉 **Line Charts** for volatility, cumulative volume, and avg. price  
- 📊 **Bar Charts** for trade count and volume  
- 🧾 **Tables** for deep-dive analysis of raw and processed metrics  
- 📌 **Scorecards** for current state KPIs  
- 🔍 **Filters** for date, alert status, and direction  

> 🌐 Access the dashboard: [Crypto Trade Dashboard](#) *(update with real URL)*

---

## 🧪 How It Works

```mermaid
graph TD;
    A[OKX API] -->|BTC-USDT Trades| B[Cloud Function]
    B --> C[Pub/Sub]
    C --> D[Dataflow Pipeline]
    D --> E[BigQuery - Raw Table]
    E --> F[BigQuery - Aggregated Metrics]
    F --> G[Looker Studio Dashboard]
