---
layout: post
title: "About Categories, Tags and Other YAML organized tutorials"
date:   2016-02-01
authors: [Leah Wasser, Megan A. Jones]
contributors: [Contributor One]
dateCreated: 2015-10-23
lastModified: 2015-12-30
packagesLibraries: [raster, rgdal, dplyr]
workshopSeries: []
categories: [self-paced-tutorial]
tags: [raster, spatial-data-gis]
mainTag: raster
description: "This page overviews the tag and category structure on the NDS site."
code1: 
image:
  feature: remoteSensingBanner.png
  credit: 
  creditlink: 
permalink: /NDS-documentation/categories-and-tags
comments: false
---

{% include _toc.html %}

##About
We can organize pages by categories, tags and other YAML elements. Categories and Tags are build
into the jekyll structure. This creating automated pages can be done as follows:

* Add a tag to a page `tags:  [raster, GIS-spatial-data, raster-ts-wrksp]`
* Edit the tags.yml or categories.yml files located in the `_data` directory. This file is composed of a `YAML` list
of elements. The `slug` is the name used in the YAML front matter. Eg `raster` and `GIS-spatial-data` are both slugs. The `name` is the "pretty" version of the tag that will be rendered on the left hand side of the page.

 <code>
 
	#example of tags.yml content
	
	- slug: GIS-spatial-data
	  name: Spatial Data & GIS
	- slug: HDF5
	  name: Hierarchical Data Formats (HDF5)
	- slug: hyperspectral-remote-sensing
	  name: Hyperspectral Remote Sensing  	  
	- slug: R
	  name: R programming
	- slug: raster
	  name: Raster Data  
	- slug: raster-ts-wrksp
	  name: Raster Time Series Workshop
	- slug: remote-sensing
	  name: Remote Sensing
	- slug: time-series
	  name: Time Series  
	  
</code>
	  
* Finally, each slug needs an associated `*.md` file in the `org/tags/` directory. For example `lidar.md`, 
`time-series.md`, etc. The YAML for each markdown page should include the tag for that particular page, and 
an appropriate `permalink` which is the direct link to the page.

<code>

	---
	layout: post_by_tag
	title: 'Articles tagged with LiDAR'
	tag: lidar
	permalink: lidar/
	image:
	  feature: remoteSensingBanner.png
	  credit: Colin Williams NEON, Inc.
	---

</code>

