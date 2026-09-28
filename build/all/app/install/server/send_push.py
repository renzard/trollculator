#!/usr/bin/env python3
import datetime
import json
import sys
import urllib.request

if len(sys.argv) < 3:
    raise SystemExit("usage: send_push.py TOKEN MESSAGE")

token = sys.argv[1]
message = " ".join(sys.argv[2:])
expiry = (datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(minutes=10)).isoformat().replace("+00:00", "Z")
payload = {
    "appid": "instagram-ut_instagram-ut",
    "expire_on": expiry,
    "token": token,
    "data": {
        "notification": {
            "card": {
                "icon": "notification",
                "summary": "Instagram UT",
                "body": message,
                "popup": True,
                "persist": True
            },
            "vibrate": True,
            "sound": True
        }
    }
}
req = urllib.request.Request(
    "https://push.ubports.com/notify",
    data=json.dumps(payload).encode(),
    headers={"Content-Type": "application/json"},
    method="POST",
)
with urllib.request.urlopen(req, timeout=15) as r:
    print(r.status, r.read().decode())
