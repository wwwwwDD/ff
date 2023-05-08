import requests
from bs4 import BeautifulSoup
import time

url = 'https://shitflare.asia'
proxies = {
  'http': 'http://137.184.245.154:80',
  'https': 'http://24.230.33.96:3128',
}
headers = {
  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'
}

for i in range(10):
  response = requests.get(url, proxies=proxies, headers=headers)
  soup = BeautifulSoup(response.text, 'html.parser')
  print(soup.prettify())
  time.sleep(5)