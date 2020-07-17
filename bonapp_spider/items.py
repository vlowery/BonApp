# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/items.html

from scrapy.item import Item, Field


class BonappItem(Item):
    dishtitle = Field()
    published = Field()
    ingredients = Field()
    instructions = Field()
    rating = Field()
    ratings_count = Field()
    review_text = Field()
    review_count = Field()
    url = Field()