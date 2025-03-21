import subprocess
import requests
import re

def get_usb_ids():
    output = subprocess.check_output(["lsusb"]).decode("utf-8")
    return re.findall(r"ID (\w+:\w+)", output)

def download_usb_ids():
    response = requests.get("http://www.linux-usb.org/usb.ids")
    return response.text

def parse_usb_ids(content):
    usb_ids = {}
    current_vendor = None
    for line in content.split("\n"):
        if line.startswith("#") or not line.strip():
            continue
        if not line.startswith("\t"):
            vendor_id, vendor_name = line.split("  ", 1)
            current_vendor = vendor_id
            usb_ids[current_vendor] = {"name": vendor_name.strip(), "devices": {}}
        elif current_vendor:
            device_id, device_name = line.strip().split("  ", 1)
            usb_ids[current_vendor]["devices"][device_id] = device_name.strip()
    return usb_ids

def main():
    usb_ids = get_usb_ids()
    usb_database = parse_usb_ids(download_usb_ids())

    for usb_id in usb_ids:
        vendor_id, device_id = usb_id.split(":")
        if vendor_id in usb_database:
            vendor_name = usb_database[vendor_id]["name"]
            if device_id in usb_database[vendor_id]["devices"]:
                device_name = usb_database[vendor_id]["devices"][device_id]
                print(f"Found the USB ID: {vendor_name} {device_name} ({usb_id})")
            else:
                print(f"Found the USB ID: {vendor_name} Unknown Device ({usb_id})")
        else:
            print(f"Not found: {usb_id}")

if __name__ == "__main__":
    main()

