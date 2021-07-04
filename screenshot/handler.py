from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    driver = webdriver.Chrome()
    
    driver.get(req)
    screenshot = driver.get_screenshot_as_base64()
    
    driver.close()

    return screenshot
