import pyodbc
import re
from selenium import webdriver
from bs4 import BeautifulSoup

class Database:
    def __init__(self, instance_name, database_name):
        self.instance_name = instance_name
        self.database_name = database_name
    
    def connect(self):
        connection_string = "DRIVER={sql_server};SERVER={db_server};DATABASE={db_name};TRUSTED_CONNECTION=yes;".format(sql_server="SQL Server", db_server=self.instance_name, db_name=self.database_name)
        return pyodbc.connect(connection_string)

    def get_items_to_process(self):
        cnxn = self.connect()
        cursor = cnxn.cursor()

        stored_procedure = "{{CALL {stored_procedure_name}}}".format(stored_procedure_name="usp_GetItemsToCompare")
        cursor.execute(stored_procedure)

        items = []

        for row in cursor.fetchall():
            item = ShopItem(row.ShopName, row.ItemName, row.PageURL, row.PriceTag, row.PriceTagType, row.PriceTagName)
            items.append(item)

        return items

    def get_emails():
        pass

    def add_price_history():
        pass

class ShopItem:
    def __init__(self, shop_name, item_name, page_url, page_price_tag, page_price_tag_type, page_price_tag_name):
        self.shop_name = shop_name
        self.item_name = item_name
        self.page_url = page_url
        self.page_price_tag = page_price_tag
        self.page_price_tag_type = page_price_tag_type
        self.page_price_tag_name = page_price_tag_name
        self.price = ""

    def set_price(self, price):
        self.price = price

class Processor:
    def __init__(self, web_driver_path, items_to_process):
        self.web_driver_path = web_driver_path
        self.items_to_process = items_to_process
        self.price_reg_ex_strip = re.compile(r'[^\d.,]+')

    def error_logs(self, error_logs):
        self.error_logs = error_logs

    def process_items(self):
        driver = webdriver.PhantomJS(executable_path=self.web_driver_path)

        for item in self.items_to_process:
            driver.get(item.page_url)
            soup = BeautifulSoup(driver.page_source, "html.parser")

            price = soup.find(item.page_price_tag, attrs={item.page_price_tag_type, item.page_price_tag_name}).text
            item.set_price(self.price_reg_ex_strip.sub('', price))
            print(item.price)

        return items
        
class Formatter:
    def __init__(self, content):
        self.content = content
        self.grouped_items = {}

    def group_content(self):
        for item in self.content:
            if item.item_name not in grouped_items:
                self.grouped_items[item.item_name] = {}

            if item.shop_name not in grouped_items[item.item_name]:
                self.grouped_items[item.item_name][item.shop_name] = {}

            self.grouped_items[item.item_name][item.shop_name] = item.price

    def format_content(self):
        for item in self.grouped_items:
            item.key

class Email:
    def __init__(self, email_addresses, email_content):
        self.email_addresses = email_addresses
        self.email_content = email_content

    def send_emails():
        pass

if __name__== "__main__":
    db = Database("", "ItemComparer")
    items = db.get_items_to_process()

    processor = Processor("C:\phantomjs.exe", items)
    items = processor.process_items()

    formatter = Formatter(items)
    formatter.group_content()
