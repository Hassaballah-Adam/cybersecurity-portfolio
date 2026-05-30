import subprocess
from datetime import datetime

timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
result = subprocess.run(['df', '-h'], capture_output=True, text=True)

with open('/var/log/sys_audit.log', 'a') as f:
    f.write(f"\n--- Audit: {timestamp} ---\n")
    f.write(result.stdout)
print("Done.")
