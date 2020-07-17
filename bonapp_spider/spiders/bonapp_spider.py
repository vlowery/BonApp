from scrapy import Spider, Request
from bonapp_spider.items import BonappItem
import re
import time
import pandas as pd
from math import ceil
from selenium import webdriver
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import StaleElementReferenceException
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait

class BonappSpider(Spider):

    name = "bonapp_spider"
    allowed_domains = ['www.bonappetit.com']
    start_urls = ['https://www.bonappetit.com/search/?content=recipe&issueDate=2020-08-01']


    def parse(self, response):
        
        ## Breaks starting search page into urls per month in date range

        timespan = pd.date_range(start='1/1/2014', end='8/1/2020', freq='MS')
        urls_bymonth = [f'https://www.bonappetit.com/search/?content=recipe&issueDate={date}-01' for date in timespan.strftime('%Y-%m')]
        for url in urls_bymonth:
            yield Request(url=url, callback=self.parse_monthly_urls)


    def parse_monthly_urls(self, response):

        ## Gathers number of recipe results to parse into total number of search pages

        results_num = response.xpath('//span[@class="matching-count"]/text()').extract_first()
        urls_pagecount = ceil(int(results_num)/18)
        addt_gallery_pages = [f'{response.url}&page={i}'for i in range(1, urls_pagecount + 1)]
        
        for url in addt_gallery_pages:
            yield Request(url=url, callback=self.parse_gallery_page)


    def parse_gallery_page(self, response):

        ## Scrapes result page for recipe links

        recipe_xpaths = response.xpath('//a[@class="photo-link"]')
        recipe_links = [f'https://www.bonappetit.com{lnk}' for lnk in recipe_xpaths.xpath('.//@href').extract()]
        for url in recipe_links:
            yield Request(url = url, callback = self.parse_recipe_page)


    def parse_recipe_page(self, response):

        name = response.xpath('//a[@name="top"]/text()').extract()
        
        published = response.xpath('//div[@class="MonthYear"]/text()').extract()

        ## Some ingredients have hyperlinked words for brands, the following navigates that possibility
        ingredients = []
        ingred_bin = response.xpath('//div[@class="ingredients__text"]')
        for ingred in ingred_bin:
            if ingred.xpath('./a'):
                ingredients.append(''.join(ingred.xpath('.//descendant-or-self::*/text()').extract()))
            else:
                ingredients.append(ingred.xpath('./text()').extract()[0])
        
        ## Newer recipes have a more modern formatting, thus the need for two xpath possibilities
        if response.xpath('//li[@class="step"]//text()').extract():
            instructions = response.xpath('//li[@class="step"]//text()').extract()
        else:
            instructions = response.xpath('//ul[@class="steps"]//text()').extract()
        
        ## Some formats do not include rating/review count, if so a manual average is taken, else 0
        if response.xpath('//div[@class="max-width-container"]/div/img/@alt').extract_first():
            rating = response.xpath('//div[@class="max-width-container"]/div/img/@alt').extract_first().split(" ")[0]
            ratings_count = response.xpath('//span[@class="review-count"]/text()').extract_first().split(' ')[0]
        elif response.xpath('//div[@class="review "]'):
            score_list = [int(review_item.xpath('.//img[@class="review-star"]/@alt').extract_first().strip(" ")[0]) 
                        for review_item in response.xpath('//div[@class="review "]') 
                        if review_item.xpath('.//img[@class="review-star"]/@alt').extract_first()]
            ratings_count = len(score_list)
            rating = sum(score_list)/ratings_count
        else:
            rating = ''
            ratings_count = 0

        ## Reviews may need selenium to click "View More"
        if response.xpath('//button[@class="view-more-btn"]/text()').extract_first() == 'VIEW MORE':
            driver = webdriver.Chrome()
            driver.get(response.request.url)
            scroll_height = 0
            while True:
                scroll_height += 300
                driver.execute_script("window.scrollTo(0, " + str(scroll_height) + ");") 
                try:
                    driver.find_element_by_xpath('//button[@class="view-more-btn"]').click()
                    time.sleep(.5)
                    try:
                        driver.find_element_by_xpath('//button[@class="view-more-btn"]')
                    except:
                        break
                except:
                    pass
                new_height = driver.execute_script("return document.body.scrollHeight")
                if new_height < scroll_height:
                    break
            review_text = response.xpath('//div[@class="review-body"]//text()').extract()  
            review_count = len(response.xpath('//div[@class="review "]'))
            driver.quit()
        else:
            review_text = response.xpath('//div[@class="review-body"]//text()').extract()  
            review_count = len(response.xpath('//div[@class="review "]'))

        item = BonappItem()
        item["dishtitle"] = name
        item["published"] = published
        item["ingredients"] = ingredients
        item["instructions"] = instructions
        item["rating"] = rating
        item["ratings_count"] = ratings_count
        item["review_text"] = review_text
        item["review_count"] = review_count
        item["url"] = response.request.url

        yield item






