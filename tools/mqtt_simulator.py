"""Симулятор датчиків теплиці: публікує значення в MQTT-брокер HiveMQ.

Встановлення:  pip install paho-mqtt
Запуск:        python tools/mqtt_simulator.py
               python tools/mqtt_simulator.py --interval 1 --dry-soil

Топіки (застосунок підписаний на lpnu/kb408/yahusevych/greenhouse/#):
  .../temperature  .../humidity  .../soil  .../light
Payload: JSON {"value": 24.5}
"""
import argparse
import json
import math
import random
import time

import paho.mqtt.client as mqtt

BASE = "lpnu/kb408/yahusevych/greenhouse"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="broker.hivemq.com")
    ap.add_argument("--port", type=int, default=1883)
    ap.add_argument("--interval", type=float, default=2.0)
    ap.add_argument("--dry-soil", action="store_true", help="низька вологість ґрунту")
    args = ap.parse_args()

    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2,
                         client_id=f"sg-sim-{random.randint(0, 99999)}")
    client.connect(args.host, args.port, keepalive=30)
    client.loop_start()
    print(f"Публікація в {args.host}:{args.port} {BASE}/... (Ctrl+C — стоп)")
    t = 0
    try:
        while True:
            values = {
                "temperature": round(24 + 4 * math.sin(t / 10) + random.uniform(-0.3, 0.3), 1),
                "humidity": round(65 + 8 * math.cos(t / 12) + random.uniform(-1, 1), 1),
                "soil": round((32 if args.dry_soil else 55) + random.uniform(-3, 3), 1),
                "light": round(11000 + 3000 * math.sin(t / 20) + random.uniform(-200, 200)),
            }
            for name, value in values.items():
                client.publish(f"{BASE}/{name}", json.dumps({"value": value}))
            print(values)
            t += 1
            time.sleep(args.interval)
    except KeyboardInterrupt:
        pass
    finally:
        client.loop_stop()
        client.disconnect()


if __name__ == "__main__":
    main()
