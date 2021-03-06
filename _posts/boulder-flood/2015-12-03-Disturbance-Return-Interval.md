---
layout: post
title: "Quantifying Disturbance Events: Return Interval"
date:  2015-11-23
authors: [Leah A. Wasser]
dateCreated:  2015-05-18
lastModified: 2015-12-14
categories: [Coding and Informatics]
category: coding-and-informatics
tags: [R, time-series]
mainTag:
scienceThemes: [phenology, disturbance]
description: "About description here."
code1:
image:
  feature: TeachingModules.jpg
  credit: A National Ecological Observatory Network (NEON) - Teaching Module
  creditlink: http://www.neoninc.org
permalink: /R/Boulder-Flood-Overview4/
code1: Boulder-Flood-Data.R
comments: false
---

{% include _toc.html %}



## A 1000 year Flood!!!  Understanding Return Periods

When talking about major disturbance events we often hear "It was a 1000-year
flood" or "That was a 100-year storm".  What does this really mean?  

Major hurricanes are forecast to strike New Orleans, Louisiana once every <a href="http://climatica.org.uk/climate-science-information/return-periods-extreme-events" target="_blank">
20 years</a> . Yet in 2005 New Orleans was pummeled by 4 hurricanes and 1
tropical storm.  Hurricane Cindy in July 2013 caused the worst black out in New
Orleans for 40 years.  Eight weeks later Hurricane Katrina came ashore over New 
Orleans, changed the landscape of the city and became the costliest natural
disaster to date in the United States.  It was frequently called a 100-year
storm. 

If we say the return period is 20 years then how did 4 hurricanes strike New 
Orleans in 1 year?

<iframe width="560" height="315" src="http://www.weather.com/news/weather/video/1000-year-flood-explained" frameborder="0" allowfullscreen></iframe>


The return period of extreme events is also referred to as _recurrence_
_interval_. It is an estimate of the likelihood of an extreme event
based on the statistical analysis of data (including flood records, fire
frequency, historical climatic records) that an event of a given magnitude will 
occur in a given year. The probability can be used to assess the risk of these
events for human populations but can also be used by biologists when creating 
habitat management plans or conservation plans for endangered species. The
concept is based on the _magnitude-frequency_ _principle_, where large magnitude
events (such as major hurricanes) are comparatively less frequent than smaller
magnitude incidents (such as rain showers).  (For more information visit  <a href="http://climatica.org.uk/climate-science-information/return-periods-extreme-events" target="_blank">
Climatica's Return Periods of Extreme Events.</a>)

1.  Your friend is thinking about buying a house near Boulder Creek.  The 
house is above the level of seasonal high water but was flooded in the 2013
flood.  He realizes how expensive flood insurance is and says, "Why do I have to
buy this insurance, a flood like that won't happen for another 100 years? 
I won't live here any more."  How would you explain to him that even though the
flood was a 100-year flood he should still buy the flood insurance?  

