"""Простий REST API для лаб. №5: ресурс /devices (GET, POST, PUT, DELETE).

Запуск:  python tools/mock_api_server.py            (порт 8080)
Дані зберігаються у tools/devices_db.json.

Android-емулятор звертається до комп'ютера за адресою http://10.0.2.2:8080
(це адреса за замовчуванням у застосунку). Для телефона в тій самій Wi-Fi:
  flutter run --dart-define=API_URL=http://<IP_комп'ютера>:8080
Перевіряє заголовок Authorization: Bearer <token> (без нього — 401).
"""
import json
import os
import uuid
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

DB = os.path.join(os.path.dirname(os.path.abspath(__file__)), "devices_db.json")
SEED = [
    {"id": "1", "name": "Вентилятор", "zone": "Зона A", "type": "fan", "isOn": True},
    {"id": "2", "name": "Насос поливу", "zone": "Зона B", "type": "pump", "isOn": False},
    {"id": "3", "name": "Фітолампа", "zone": "Зона A", "type": "lamp", "isOn": True},
    {"id": "4", "name": "Обігрівач", "zone": "Зона C", "type": "heater", "isOn": False},
]


def load():
    if not os.path.exists(DB):
        save(SEED)
    with open(DB, encoding="utf-8") as f:
        return json.load(f)


def save(items):
    with open(DB, "w", encoding="utf-8") as f:
        json.dump(items, f, ensure_ascii=False, indent=1)


class Handler(BaseHTTPRequestHandler):
    def _send(self, code, body=None):
        data = b"" if body is None else json.dumps(body, ensure_ascii=False).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def _route(self):
        parts = [p for p in self.path.split("?")[0].split("/") if p]
        if not parts or parts[0] != "devices" or len(parts) > 2:
            self._send(404, {"error": "not found"})
            return None, None
        if not self.headers.get("Authorization", "").startswith("Bearer "):
            self._send(401, {"error": "missing bearer token"})
            return None, None
        return True, (parts[1] if len(parts) == 2 else None)

    def _body(self):
        n = int(self.headers.get("Content-Length", 0))
        return json.loads(self.rfile.read(n) or b"{}")

    def do_GET(self):
        ok, item_id = self._route()
        if not ok:
            return
        items = load()
        if item_id is None:
            return self._send(200, items)
        found = [i for i in items if i["id"] == item_id]
        self._send(200, found[0]) if found else self._send(404, {"error": "no device"})

    def do_POST(self):
        ok, item_id = self._route()
        if not ok:
            return
        item = {**self._body(), "id": uuid.uuid4().hex[:8]}
        items = load()
        save(items + [item])
        self._send(201, item)

    def do_PUT(self):
        ok, item_id = self._route()
        if not ok or item_id is None:
            return
        items = load()
        for i, it in enumerate(items):
            if it["id"] == item_id:
                items[i] = {**it, **self._body(), "id": item_id}
                save(items)
                return self._send(200, items[i])
        self._send(404, {"error": "no device"})

    def do_DELETE(self):
        ok, item_id = self._route()
        if not ok or item_id is None:
            return
        save([i for i in load() if i["id"] != item_id])
        self._send(204)


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    print(f"Mock API: http://0.0.0.0:{port}/devices  (Ctrl+C — стоп)")
    ThreadingHTTPServer(("0.0.0.0", port), Handler).serve_forever()
