from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
import os
import json

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    driver = None
    try:
        reqObj = json.loads(req)
        options = webdriver.ChromeOptions()

        image_width = os.getenv('image_width', '1920')
        image_height = os.getenv('image_height', '1080')
        options.add_argument(f"window-size={image_width},{image_height}")

        options.add_argument('--headless')
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-dev-shm-usage')

        if "proxy" in reqObj:
            proxy = reqObj["proxy"]
            options.add_argument('--proxy-server=%s' % proxy)
        

        driver = webdriver.Chrome(chrome_options=options)
        
        if "url" in reqObj:
            driver.get(reqObj["url"])
        else:
            raise Exception('Not url attribute in input JSON')
        return driver.get_screenshot_as_base64()
    except Exception as e:
        print(e)
    finally:
        if driver:
            driver.close()
            driver.quit()
    
    raise Exception("Not valid url")
    
    
