import requests
import json
from google.cloud import pubsub_v1
from datetime import datetime
import pytz

def fetch_trades(request):
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path("crypto-trade-tracker-1", "crypto-trades")
    
    url = "https://www.okx.com/api/v5/market/trades?instId=BTC-USDT&limit=10"
    response = requests.get(url)
    trades = response.json()["data"]
    trade_data = [{"id": t["tradeId"], "price": float(t["px"]), "qty": float(t["sz"]), 
                   "time": int(t["ts"]), "isBuy": t["side"] == "buy"} for t in trades]
    
    # Generate a timestamp in UTC (ISO 8601 format)
    timestamp = datetime.now(pytz.UTC).isoformat()
    
    # Publish a JSON object with "trades" and "timestamp" fields
    message = {
        "trades": json.dumps(trade_data),
        "timestamp": timestamp
    }
    publisher.publish(topic_path, json.dumps(message).encode("utf-8"))
    return f"Published {len(trade_data)} trades"