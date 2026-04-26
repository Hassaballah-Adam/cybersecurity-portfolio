import os
from datetime import datetime

DC_IP = "192.168.128.1"
timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
response = os.system(f"ping -c 4 {DC_IP} > /dev/null 2>&1")
status = "DC is UP" if response == 0 else "DC is DOWN"

with open('/var/log/dc_audit.log', 'a') as f:
    f.write(f"[{timestamp}] {status}\n")
print(status)
