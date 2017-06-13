import requests
from lxml import etree, html
import traceback
import time

#If Selenium/Chrome
#from selenium import webdriver
#from selenium.webdriver.common.by import By

class ItemKB():
    def __init__(self):
        # Get a copy of the default headers that requests would use
        self.headers = requests.utils.default_headers()

        self.headers.update({'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.59 Safari/537.36'})  #Need a user agent or they 429 you
        #self.driver = webdriver.Chrome() #If using selenium/chrome #If Selenium/Chrome
        pass

    def getStartingItems(self,heroName,desiredLane):
        try:
            resp = requests.get("https://www.dotabuff.com/heroes/"+heroName+"/guides", headers=self.headers)
            resp.raise_for_status() #throw exception for bad status codes
            hdoc = html.fromstring(resp.content)

            #Get Stats for all players on page
            statBlocks = hdoc.xpath('//div[@class="r-stats-grid"]')

            for statBlock in statBlocks:

                #Get lane
                lane = statBlock.xpath('.//i[contains(@class,"lane-icon")]/../text()')[0].strip()
                if lane != desiredLane:
                    continue

                #Get item purchase sets for player 0
                itemSets =  statBlock.xpath('.//div[@class="kv r-none-mobile"]')

                #starting items are in first itemset slot
                startingItems = [ href.split('/')[-1].replace('-','_') for href in itemSets[0].xpath('.//a/@href')]

                return startingItems

            return None
        except:
            print("Exception Occured:{}".format(traceback.format_exc()))


    #If Selenium/Chrome
    #A Solutoin that works using selenium/Chrome.  Requires lots of setup and latency but unbeatable by scraping detection
    def __chrome_getStartingItems(self,heroName):
        try:
            self.driver.get("https://www.dotabuff.com/heroes/"+heroName+"/guides")
            #time.sleep(2)
            playerStats = self.driver.find_elements(By.XPATH,'//div[@class="r-stats-grid"]')
            itemSets = playerStats[0].find_elements(By.XPATH,'.//div[@class="kv r-none-mobile"]')
            startingItems = [ element.get_attribute('href').split('/')[-1].replace('-','_') for element in itemSets[0].find_elements(By.XPATH,'.//a')]
        except:
            print("Exception Occured:{}".format(traceback.format_exc()))
        finally:
            #self.driver.quit() #If Selenium/Chrome
            pass


    def getNextItem(self):
        pass


if __name__ == "__main__":
    itemkb = ItemKB()
    print(itemkb.getStartingItems("bristleback","Off Lane"))
