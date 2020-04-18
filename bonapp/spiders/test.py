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







            # if bool(article.xpath('//div[@class="ingredients__text"]/text()').extract()):
            #     recipe_url = [f'https://www.bonappetit.com{lnk}' for lnk in article.xpath('.//a/@href').extract()]
            #     print('blog_links______'*10)
            #     print(recipe_url)
            #     print('blog_links______'*10)
            #     yield Request(url = recipe_url, callback = self.parse_recipe_page)
            
            # elif bool(article.xpath('//div[@class="content-card-embed__info"]//a/@href').extract()):
            #     blog_url = [f'https://www.bonappetit.com{lnk}' for lnk in article.xpath('.//a/@href').extract()]
            #     print('____blog_url'*10)
            #     print(blog_url)
            #     print('____blog_url'*10)                
            #     yield Request(url = blog_url, callback = self.parse_recipe_page)
            
            # elif re.search('\d+', str(article.xpath('.//a/text()').extract())):