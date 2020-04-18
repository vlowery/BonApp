# from scrapy import Spider
# from bonapp.items import BonappItem
# from bs4 import BeautifulSoup
# import requests

# class BonappSpider(Spider):
#     name = "bonapp_spider"

#     starting_link = "https://www.bonappetit.com/gallery/easy-dinner-recipes"
#     some_link = requests.get(starting_link)
#     recipe_mass_link = BeautifulSoup(some_link.text, 'html.parser')
#     recipe_mass_link = recipe_mass_link.find_all('div', {'class': "gallery-slid-caption__cta-block"})
#     recipe_mass_bin = []
#     for recipe in recipe_mass_link:
#         recipe_mass_bin.append(recipe.a.get('href'))
#     start_urls = [ele for ele in recipe_mass_bin]

#     def parse(self, response):
#         # starting_link = "https://www.bonappetit.com/gallery/easy-dinner-recipes"
#         # some_link = requests.get(starting_link)
#         # recipe_mass_link = BeautifulSoup(some_link.text, 'html.parser')
#         # recipe_mass_link = recipe_mass_link.find_all('div', {'class': "gallery-slid-caption__cta-block"})
#         # for recipe in recipe_mass_link:
#             Name = response.xpath('//a[@name="top"]/text()').extract()
#             rows = response.xpath('//li[@class="ingredient"]') 
#             for row in rows:
#                 Ingredient = row.xpath('.//div/text()').extract()[0]
#                 if row.xpath('./div/a'):
#                     Ingredient = row.xpath('./div/a/text()').extract()[0] + Ingredient

#                 item = BonappItem()
#                 item["Ingredient"] = Ingredient
#                 item["DishTitle"] = Name

#                 yield item