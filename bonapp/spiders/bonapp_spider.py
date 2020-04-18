from scrapy import Spider, Request
from bonapp.items import BonappItem
import re

class BonappSpider(Spider):

    name = "bonapp_spider"
    allowed_domains = ['www.bonappetit.com']
    start_urls = ['https://www.bonappetit.com/ingredient/pasta']


    def parse(self, response):

        blog_titles = response.xpath('//div[@class="feature-item-content"]')
        blog_links = [f'https://www.bonappetit.com{lnk}' for lnk in blog_titles.xpath('.//a/@href').extract()]
        for url in blog_links:
            if "/recipe/" in url:
                yield Request(url = url, callback = self.parse_recipe_page)
            else:
                yield Request(url = url, callback = self.parse_gallery_page)
      

    def parse_gallery_page(self, response):

        if bool(response.xpath('//div[@class="content-card-embed__info"]//a/@href').extract()):
            recipe_link = ('https://www.bonappetit.com{lnk}'.format(lnk = response.xpath('//div[@class="content-card-embed__info"]//a/@href').extract_first()))
            yield Request(url = recipe_link, callback = self.parse_recipe_page)
        else:
            recipes_link = response.xpath('//div[@class="gallery-slid-caption__cta-block"]//a/@href').extract()
            for url in recipes_link:
                yield Request(url = url, callback = self.parse_recipe_page)


    def parse_recipe_page(self, response):

        Name = response.xpath('//a[@name="top"]/text()').extract()
        
        Ingredients = []
        ingred_bin = response.xpath('//div[@class="ingredients__text"]')
        for ingred in ingred_bin:
            if ingred.xpath('./a'):
                Ingredients.append(ingred.xpath('./a/text()').extract()[0] + ingred.xpath('./text()').extract()[0])
            else:
                Ingredients.append(ingred.xpath('./text()').extract()[0])
        
        if response.xpath('//li[@class="step"]//text()').extract():
            Instructions = response.xpath('//li[@class="step"]//text()').extract()
        else:
            Instructions = response.xpath('//ul[@class="steps"]//text()').extract()
        
        Reviews = response.xpath('//div[@class="review-body"]//text()').extract()  


        item = BonappItem()
        item["Ingredients"] = Ingredients
        item["DishTitle"] = Name
        item["Instructions"] = Instructions
        item["Reviews"] = Reviews

        yield item






