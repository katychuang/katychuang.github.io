---
date: 2013-03-01 00:00:00
title: Big Data in Fashion
tags: product, pydata, fashion
---

![Screenshot](https://lh4.googleusercontent.com/-KMvgM7jn7_s/UTFgHKksKBI/AAAAAAAAGi0/YV6mOM8SPkI/w650-h426/Screen+Shot+2013-03-01+at+9.12.08+PM.png)

#Fashion Forecasting

<img src="http://katychuang.pythonanywhere.com/static/PythonFashionForecaster.png" style="max-width:200px;float:right;margin-left:20px">
This app is still in pre-alpha. This project was inspired by a book I read about the sociology of fashion. The author argues that fashion is a symbolic cultural product, dimensionally different from discussions on the articles of clothing. In the great words of Yuniya Kawamura, "fashion is not about clothes but is a belief". In her book, she clarifies the difference between a "fashion system" and a "clothing system", where fashion has intangible value yet propagated by cultural infrastructures promoting the activities of perceiving clothing as art.

Reference: Kawamura, Yuniya. 2005. Fashion-ology. Oxford: Berg.

###End Product
Current design ideas for FashionForecaster include these components but are not limited to:

Social stream aggregator - python API packages to crawl social media data related to fashion (i.e. twitter, pinterest)
Web framework to present data - i.e. django combined with jquery
Data analysis - python libraries such as numpy, textmining. This would be the big data portion, and we plan to do this after data is collected.


<img src="https://lh5.googleusercontent.com/-_m9JKnsK5Vs/UTwqSkD24rI/AAAAAAAAGs0/BIeyNL1Q7Uw/w651-h511/Screen+Shot+2013-03-10+at+1.37.39+AM.png" style="float:right; max-width:500px">

##Technical Environment:

- Hosted on [Google App Engine](http://www.appspot.com) Cloud Service
- Python ([Django](https://www.djangoproject.com/), [SimpleJson](https://pypi.python.org/pypi/simplejson/)), and Flask.
- Javascript (D3.js, Flotr2.js, jQuery)
- API comes from Twitter

**Demo of Flask app on Google App Engine:**
http://style-buzz.appspot.com

**Demo of Django app on PythonAnywhere:**
http://katychuang.pythonanywhere.com

**Code**
https://github.com/katychuang/Python-Fashion-Forecaster





###Talks

1. NYC Python Meetup

2. PyData 2013 Silicon Valley ([Slides](https://github.com/katychuang/PyData2013-BigDataFashion))
