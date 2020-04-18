from scrapy import Spider, Request
from bonapp.items import BonappItem
import re

class BonappSpider(Spider):

    name = "bonapp_spider"
    allowed_domains = ['www.bonappetit.com']
    start_urls = ['https://www.bonappetit.com/ingredient/pasta']


    def parse(self, response):

        blog_titles = response.xpath('//div[@class="feature-item-content"]')
        for article in blog_titles[4:5]:
            if article.xpath('//div[@class="ingredients__text"]/text()').extract():
                recipe_url = [f'https://www.bonappetit.com{lnk}' for lnk in article.xpath('.//a/@href').extract()]
                yield Request(url = recipe_url, callback = self.parse_recipe_page)
            # if re.search('\d+', str(article.xpath('.//a/text()').extract())):
            #     blog_links = [f'https://www.bonappetit.com{lnk}' for lnk in article.xpath('.//a/@href').extract()]
            #     print('='*55)
            #     print(blog_links)
            #     print('='*55)
            #     for url in blog_links:
            #         print('+'*55)
            #         print(url)
            #         print('+'*55)
            #         yield Request(url = url, callback = self.parse_blog_page)
      


    def parse_blog_page(self, response):

        recipe_links = response.xpath('//div[@class="gallery-slid-caption__cta-block"]//a/@href').extract()
        for url in recipe_links:
            yield Request(url = url, callback = self.parse_recipe_page)


    def parse_recipe_page(self, response):

        Name = response.xpath('//a[@name="top"]/text()').extract()
        Ingredients = response.xpath('//div[@class="ingredients__text"]/text()').extract()
        # if response.xpath('./div/a'):
        #     Ingredients.append(response.xpath('./div/a/text()').extract()[0] + Ingredient)

        item = BonappItem()
        item["Ingredients"] = Ingredients
        item["DishTitle"] = Name

        yield item






