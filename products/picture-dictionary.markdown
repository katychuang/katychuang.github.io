---
date: 2013-04-27 00:00:00
title: Picture Dictionary
tags: [api, django, python]
---

![ScreenShot](https://lh3.googleusercontent.com/-CRsiKgsSFiQ/UYXCiqA0FII/AAAAAAAAINQ/Cm4_7HfymNs/w642-h547/styleA2.png)

#Picture Dictionary

For the Techcrunch Hackathon, I worked on a picture dictionary. This was to help me practice connecting with APIs and displaying them in a useful fashion.

This django app takes photos from common social API's, mashed together with Pearson's dictionary API and NY Times API.

I chose to use Pearson’s api for dictionary definitions of official English language words. Tumblr was selected for displaying photos because it’s known as a hipster platform and because people tag photos with everyday language including slang. I chose to display NY Times articles so that people can read more about the term.

In essence, it’s an educational tool to learn and understand english slang terms.

##Technical Environment:

- Hosted on [Heroku](http://www.heroku.com) Cloud Service
- Python ([Django](https://www.djangoproject.com/), [SimpleJson](https://pypi.python.org/pypi/simplejson/))


**Demo:**
http://blooming-forest-4284.herokuapp.com

**Code:**
https://github.com/katychuang/django-snapbook
