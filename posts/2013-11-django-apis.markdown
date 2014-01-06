---
date: 2013-11-04 18:06:57
title: Django + APIs  for online communities
tags: tutorial, pydata
---

No matter how you look at it, building an online community is not easy even if your group members have similar interests. You might ask yourself, how can you build a sense of community when everyone uses a different channel of communication? How can you braid together different channels to let your members have their own voice yet still have the group identity?

![Braided conversations](http://katychuang.files.wordpress.com/2013/11/07c3d-6braid.jpg?w=367&h=374)

That is where an application programming interface (API) becomes important, it is the pattern of your weave that keeps your braid consistent. It is quite easy to set up an application that takes in data with an API, using the Django framework and available API wrappers. The framework helps with the server-client data flow and the API wrapper makes it easier to work with an API.

![My Django-Snapbook Commits](http://katychuang.files.wordpress.com/2013/11/screen-shot-2013-11-05-at-2-01-33-am.png?w=700)

Six months ago was the beginning of my journey in learning how to work with APIs other than Twitter, by making a web application during a hackathon. I created <a href="https://github.com/katychuang/django-snapbook">Django-Snapbook</a>, in effort to show NYC PyLadies how to use various APIs (instagram, twitter, NYTimes, Pearson Dictionary) and do web development in Python. While it was disappointing that nobody showed up to the event, that experience of working with APIs came in useful at another hackathon couple months later where I built another application for showing public education statistics, <a href="https://github.com/katychuang/techsummitpr">Data Joven</a>. My first taste with open data, and using D3.js to display maps. It was awesome.

![Django-Snapbook, search results for DKNY](http://katychuang.files.wordpress.com/2013/11/screen-shot-2013-11-05-at-3-01-26-am.png?w=700&h=540)

In recent months Twitter turned off their version 1, which means that you have to use OAuth to connect with their service. Increases security but still a pain to deal with.  I really wanted to incorporate the voices of PyData Community on twitterverse into the PyData website, because (1) twitter is uniquely designed to let folks have their own voice because of the 1 author write permissions, and (2) twitter is also uniquely designed to show people talking about the same topic with #hashtags.  I ended up using [Django-Twitter-Tag](https://github.com/coagulant/django-twitter-tag) plugin.

![PyData Community (twitterverse embedded into main site)](http://katychuang.files.wordpress.com/2013/11/screen-shot-2013-11-05-at-2-37-11-am.png?w=700&h=543) 


Photos is another great way to have folks contribute yet have their own unique voices. <a href="http://stuvel.eu/flickrapi">flickrapi</a> is a nice wrapper to connect with <a href="http://www.flickr.com/services/api/">Flickr's API</a>, as written up in this <a href="http://www.jjude.com/2008/06/accessing-flickr-photos-with-python/">nifty starter guide</a>.

[Python-Instagram](https://github.com/Instagram/python-instagram) lets you connect to Instagram's database of images, with which you can use to [analyze images](https://github.com/katychuang/Pyladies-ImageAnalysis) or make a slideshow.

![Using instagram API with iPython Notebook, SciKit-Image](http://katychuang.files.wordpress.com/2013/11/screen-shot-2013-11-05-at-2-42-30-am.png?w=500&h=302)

On the front end, you could use a number of javascript plugins, including but not limited to jQuery, Bootstrap, MooTools or plugins built on top of those libraries.
