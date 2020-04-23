from scrapy import Spider, Request
from bonapp.items import BonappItem
import re
import pandas as pd
from math import ceil

class BonappSpider(Spider):

    name = "bonapp_spider"
    allowed_domains = ['www.bonappetit.com']
    start_urls = ['https://www.bonappetit.com/search/?content=recipe&issueDate=2020-05-01']


    def parse(self, response):
        
        ## Breaks starting search page into urls per month in date range

        timespan = pd.date_range(start='1/1/2015', end='5/1/2020', freq='MS')
        urls_bymonth = [f'https://www.bonappetit.com/search/?content=recipe&issueDate={date}-01' for date in timespan.strftime('%Y-%m')]
        for url in urls_bymonth[:10]:
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

        Name = response.xpath('//a[@name="top"]/text()').extract()
        
        Published = response.xpath('//div[@class="MonthYear"]/text()').extract()

        ## Some ingredients have hyperlinked words for brands, the following navigates that possibility
        Ingredients = []
        ingred_bin = response.xpath('//div[@class="ingredients__text"]')
        for ingred in ingred_bin:
            if ingred.xpath('./a'):
                Ingredients.append(''.join(ingred.xpath('.//descendant-or-self::*/text()').extract()))
            else:
                Ingredients.append(ingred.xpath('./text()').extract()[0])
        
        ## Newer recipes have a more modern formatting, thus the need for two xpath possibilities
        if response.xpath('//li[@class="step"]//text()').extract():
            Instructions = response.xpath('//li[@class="step"]//text()').extract()
        else:
            Instructions = response.xpath('//ul[@class="steps"]//text()').extract()
        
        rating_string = response.xpath('//div[@class="max-width-container"]/div/img/@alt').extract_first()
        if rating_string:
            Rating = re.search('\d+\.?\d*', rating_string).group(0)
        else:
            Rating = ''

        Reviews = response.xpath('//div[@class="review-body"]//text()').extract()  


        item = BonappItem()
        item["DishTitle"] = Name
        item["Published"] = Published
        item["Ingredients"] = Ingredients
        item["Instructions"] = Instructions
        item["Rating"] = Rating
        item["Reviews"] = Reviews

        yield item






