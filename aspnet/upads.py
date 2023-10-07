import requests

url = ""
authkey_mt = "mt"
files_mt = {"file": open("/index.php", "rb")}
data_mt = {"authKey": authkey_mt}
authkey_ad = "ad"
files_ad = {"file": open("/index.txt", "rb")}
data_ad = {"authKey": authkey_ad}
response_mt = requests.post(url, files=files_mt, data=data_mt)
response_ad = requests.post(url, files=files_ad, data=data_ad)
print("Response (authkey 'mt'):", response_mt.text)
print("Response (authkey 'ad'):", response_ad.text)
