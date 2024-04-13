import requests

def get_public_ip():
  response = requests.get('https://ifconfig.me')
  return response.text

print(get_public_ip())
