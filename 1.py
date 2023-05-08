from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from fake_useragent import UserAgent
import requests
import time

# использование утилиты Faker для генерации фальшивых данных, включая юзер-агенты, referrer, cookies, headers и т.д.
ua = UserAgent() 
header = {'User-Agent':str(ua.random)}

# URL сайта, который нужно обойти защиту
url = "https://shitflare.asia"

# количество запросов
requests_number = 10

# список прокси серверов
proxy_list = ['103.156.141.100:80', '46.35.9.110:80', '136.243.19.90:3128', '23.144.56.65:80', '167.235.203.129:8080', '62.33.207.202:3128', '117.160.250.134:80', '174.138.184.82:35893', '5.196.111.29:20100', '62.33.207.201:80', '213.241.205.2:8080', '87.237.239.95:3128', '103.150.18.218:80', '117.160.250.132:80', '103.133.210.133:80', '213.194.142.223:80', '62.33.207.201:3128', '148.76.97.250:80', '161.35.70.249:8080', '162.223.94.164:80', '5.202.104.22:3128', '18.219.250.99:3128', '65.20.224.193:8080', '103.117.192.14:80', '94.20.183.172:80', '45.77.219.182:80']

# создание объекта опций драйвера
chrome_options = webdriver.ChromeOptions()

# настройки драйвера
chrome_options.add_argument("--start-maximized")
chrome_options.add_argument("--disable-infobars")
chrome_options.add_argument("--disable-extensions")
chrome_options.add_argument('--proxy-server=%s' % proxy_list[0])

def initiate_browser():
    """
    Инициализирует и возвращает объект драйвера
    """
    driver = webdriver.Chrome(chrome_options=chrome_options)
    driver.delete_all_cookies()
    driver.get(url)
    return driver

def change_proxy():
    """
    Меняет прокси на следующий в списке и обновляет драйвер
    """
    proxy_list.append(proxy_list.pop(0))
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument('--proxy-server=%s' % proxy_list[0]) 
    return webdriver.Chrome(chrome_options=chrome_options)

def get_request():
    """
    Выполняет запрос методом GET
    """
    res = requests.get(url, headers=header)
    status_code = res.status_code
    return status_code

def post_request():
    """
    Выполняет запрос методом POST
    """
    res = requests.post(url, headers=header)
    status_code = res.status_code
    return status_code

# Используя цикл while мы обеспечим выполнение скрипта заданное количество раз
i = 0
while i < requests_number:

    driver = initiate_browser() 

    try:
        # Ожидание элемента страницы
        element = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((By.ID, "some_id"))
        )

        cookies = driver.get_cookies()
        for cookie in cookies:
            driver.add_cookie(cookie)

        # Случайно определяется запрос GET или POST
        if i % 2 == 0:
            status_code = get_request()
        else:
            status_code = post_request() 

        print("Status code: {}".format(status_code))

        # Если.statusCode имеет значение отличное от 200, то используется следующий прокси
        if status_code != 200:
            driver.quit()
            driver = change_proxy()
            i -= 1

        # Используется случайная задержка
        time.sleep(1)

    except Exception as e:
        print(e)
        driver.quit()
        
    driver.quit()
    i += 1