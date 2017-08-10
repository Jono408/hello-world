from selenium import webdriver
from bs4 import BeautifulSoup

phantomjs_driver = 'C:\Code\Dependencies\phantomjs.exe'
driver = webdriver.PhantomJS(executable_path=phantomjs_driver)

driver.get("")
soup = BeautifulSoup(driver.page_source, "html.parser")

search_tag = 'span'
search_type = 'class'
search_tag_name = 'linePrice'

price = soup.find(search_tag, attrs={search_type, search_tag_name}).text
print(price.strip())

driver.get("")
soup = BeautifulSoup(driver.page_source, "html.parser")

search_tag = 'p'
search_type = 'class'
search_tag_name = 'pricePerUnit'

price = soup.find(search_tag, attrs={search_type, search_tag_name}).text
print(price.strip())