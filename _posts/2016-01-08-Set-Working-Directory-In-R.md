---
layout: post
title: "Download a NEON Teaching Data Subset & Set A Working Directory In R"
date:   2015-12-07
lastModified: 2016-01-08
createddate:   2015-12-07
estimatedTime: 10 Min
authors: Megan A. Jones
packagesLibraries: []
categories: [self-paced-tutorial]
tags: [R, informatics]
mainTag: 
description: "This tutorial explains how to set a working directory in R. The 
working directory points to a directory or folder on the computer where data 
that you wish to work with in R is stored. "
code1: Set-Working-Directory-In-R.R
image:
  feature: coding_R.png
  credit: National Ecological Observatory Network (NEON).
  creditlink: http://www.neoninc.org
permalink: /R/Set-Working-Directory/
comments: false
---

{% include _toc.html %}

##About
This tutorial explains how to set a working directory in `R`. The working 
directory points to a directory or folder on the computer where data that you 
wish to work with in `R` is stored.

**R Skill Level:** Beginner

<div id="objectives" markdown="1">

#Goals / Objectives
After completing this activity, you will:

 * Be able to set the `R` working directory.
 * Be able to download and unzip NEON Teaching Data Subsets. 
 * Know the difference between base and relative paths.  
 * Be able to write out both base and relative paths for a given file or
 directory. 


##Things You’ll Need To Complete This Lesson
To complete this lesson you will need the most current version of R and, 
preferably, RStudio loaded on your computer.

###Download Data
{% include/dataSubsets/_data_Met-Time-Series.html %}

Teaching Data Subset For Challenge Activity: 
{% include/dataSubsets/_data_Site-Layout-Files.html %}

</div>

##NEON Data Skills Tutorials
Many NEON self-paced tutorials, available through the 
[NEON Data Skills portal](http://www.NEONdataskills.org  "NEON Data Skills Portal"),
utilize teaching data subsets which are hosted on the NEON Teaching Data Subsets
fig**share** repository. If a data subset is required for a tutorial it can be 
downloaded at the top of each tutorial in the **Download Data** section.  

Prior to working with any data in `R`, we must set the *working directory* to
the location of the data files.  Setting the working directory tells `R` where 
the data files are located on the computer.  If the working directory is not set
first, when we try to open a file we will get an error telling us that `R` 
cannot find the file.   

<i class="fa fa-star"></i> **Data Tip:** Directory vs Folder. Both of these
words refer to the same thing.  Folder makes a lot of sense when we think of an
isolated folder as a "bin" containing many files. However, the analogy to a
physical file folder falters when we start thinking about the relationship 
between different folders and how we tell a computer to find a specific folder.  
This is why the term directory is often preferred.  Any directory (folder) can 
hold other directories and/or files.  When we set the *working directory*, we 
are telling the computer which directory (or folder) to start with when looking
for other files or directories, or to save any output to.  
{: .notice}

##Download the Data
First, we will download the data to a location on your computer. To download the 
data for this tutorial, select the blue button **Download NEON Teaching Data 
Subset: Meteorological Data for Harvard Forest**.  Note: In other NEON Data
Skills tutorials download all data subsets in the **Download Data** section
prior to starting the lesson.  

<figure>
	<a href="{ site.baseurl }}/images/set-working-dir/download-data-screenshot.png">
	<img src="{ site.baseurl }}/images/set-working-dir/download-data-screenshot.png"></a>
	<figcaption> Screenshot of the <b>Download Data </b> button at the top of 
	NEON Data Skills tutorials. Source: National Ecological Observatory Network
	(NEON)  
	</figcaption>
</figure> 

After clicking on the "Download Data" button, the data will automatically 
download to the computer. 

Second, we need to find the downloaded .zip folder. Many browsers default to 
downloading to the **Downloads** directory on your computer. 
Note: You may have previously specified a specific directory (folder) for files
downloaded from the internet, if so, the .zip file will download there.

<figure>
	<a href="{ site.baseurl }}/images/set-working-dir/downloads_folder.png">
	<img src="{ site.baseurl }}/images/set-working-dir/downloads_folder.png"></a>
	<figcaption> Screenshot of the computer's Downloads folder containing the
	new <b>NEONDSMetTimeSeries.zip </b> file. Source: National Ecological
	Observatory Network (NEON)  
	</figcaption>
</figure> 

Third, we must move the data files to the location we want to work with them.  
We recommend moving the .zip to a dedicated **data** directory within the
**Documents** directory on your computer. This **data** directory can 
then be a repository for all data subset you use for the NEON Data Skills 
tutorials. Note: If you choose not to use the directory ~/Documents/data for 
your data, modify the directions below with the appropriate file path to 
your "data" directory. 

Fourth, we need to unzip/uncompress the file so that the data files can be 
accessed. Use your favorite tool that can unpackage/open .zip files (e.g.,
winzip, Archive Utility, etc). The files will now be accessible in a folder 
named `NEON-DS-Met-Time-Series`. 

Now that we have our data in an accessible format, we can move into `R` to set
the working directory. 


<div id="challenge" markdown="1">
##Challenge: Download and Unzip Teaching Data Subset
Prepare the **Site Layout Shapefiles Teaching Data Subset** so that the files
are accessible and ready to be opened in`R`. 
</div>

##The R Working Directory
In `R` the working directory is the directory where `R` starts when looking for 
any file (or file path) to open and where it save the output.  Why do we want to
do this?  

We could just write our `R` scripts with the full or base path to each file we 
want to open or save.  However, it is more efficient if we have a **base file 
path** set as our **working directory** and then all file paths written in our
scripts only consist of the file paths relative to that base path (a **relative
path**).  

###Base Paths & Relative Paths

<figure>
	<a href="{ site.baseurl }}/images/set-working-dir/mjones01-documents-contents.png">
	<img src="{ site.baseurl }}/images/set-working-dir/mjones01-documents-contents.png"></a>
	<figcaption> Screenshot of the <b>neon</b> directory with the nested 
	<b>Documents</b>, <b>data</b>, <b>NEON-DS-Met-Time-Series</b>, and other 
	directories. Source: National Ecological Observatory Network
	(NEON)  
	</figcaption>
</figure> 

The data downloaded and unzipped in the previous steps are located within a 
nested set of directories:  
 
 * primary-level/home directory:  neon 
	+ This directory isn't obvious as we are within this directory once we logged
	into the computer. 
	+ You will see your own user ID.
 * secondary-level directory:     Documents
 * tertiary-level directory: 	  data
 * quaternary-level directory:    NEON-DS-Met-Time-Series
 * quaternary-level directory:    NEON-DS-Site-Layout-Shapefiles 

####Base Path
The full path is essentially the full "directions" for how to find the desired
directory or file.  It **always** starts with the home directory. A **full path**
can be a **base path** when used to set the working directory to a specific 
directory. The base path for the `NEON-DS-Met-Time-Series` directory would be:

	 /Users/neon/Documents/data/NEON-DS-Met-Time-Series 


<i class="fa fa-star"></i> **Data Tip:** Pathways and the home directory in 
different operating systems will appear slightly different. 
On Linux the path may start `/home/neon/`, on Windows it may be similar to
`C:\Documents and Settings\neon\` or `C:\Users\neon\` (varies by Windows
version), or on Mac OS X it will appear `/Users/neon/`.  If you are working in a
Windows platform, make special note of the direction of the slashes in file 
paths on Windows platforms. This tutorial will show Mac OS X output.  
{: .notice}

<div id="challenge" markdown="1">
##Challenge: Base File Path
Write out the base path for the `NEON-DS-Site-Layout-Shapefiles` directory.  Use
the format of the computer you are currently using.  

Bonus: Write the path in a Linux format (if you are currently using Linux, 
choose one of the other formats). 
</div>

####Relative Path
A relative path is a path to a directory or file that is starts from the
location determined by the working directory. If our working directory is set
to the **data** directory,

	 /Users/neon/Documents/data/

we can then create a relative path for all directories and  files within the
**data** directory. 

<figure>
	<a href="{ site.baseurl }}/images/set-working-dir/data-folder-contents.png">
	<img src="{ site.baseurl }}/images/set-working-dir/data-folder-contents.png"></a>
	<figcaption> Screenshot of the data directory containing the both NEON Data 
	Skills Teaching Subsets. Source: National Ecological Observatory Network
	(NEON)  
	</figcaption>
</figure> 

The relative path for the `meanNDVI_HARV_2011.csv` file would be: 

	 NEON-DS-Met-Time-Series/HARV/NDVI/meanNDVI_HARV_2011.csv

<div id="challenge" markdown="1">
##Challenge: Relative File Path
Use the format of your current operating system:

1. Write out the **full path** to for the `Boundary-US-State-Mass.shp` file. 
2. Write out the **relative path** for the `Boundary-US-State-Mass.shp` file
assuming that the working directory is set to `/Users/neon/Documents/data/`.  

Bonus: Write both paths using an alternate operating system format. 
</div>

###Find a Full Path to File in Unknown Location
If you are unsure of the path to a specific directory or file, you can
find out by right clicking (Mac: control+click) on the file/directory of interest
and select "Properties" or "Get Info". The location information will appear 
as something like: 

Computer > Users > neon > Documents > data > NEON-DS-Met-Time-Series

If you copy and paste this information, it automatically reformats into the base 
path to the directory or file: 

Windows:    C:\\Users\neon\Documents\data\NEON-DS-Met-Time-Series\

Mac OS X:   /Users/neon/Documents/data/NEON-DS-Met-Time-Series

###Determine Current Working Directory
Once we are in the `R` program, we can view the current working directory
using the code `getwd()`.  

    # view current working directory 
    getwd()
    [1] "/Users/neon"

The working directory is currently set to the home directory `/Users/neon` 
(your current working directory will be different).  

This code can be used at any time to determine the current working directory.  


##Set the Working Directory
To set our current working directory to the location where our data is can
either set the working directory in the `R` script or use our current `R` GUI to
select the working directory.

<i class="fa fa-star"></i> **Data Tip:** All NEON Data Skills tutorials are
written assuming the working directory is the parent directory to the downloaded
data.  This allows for multiple data subsets to be accessed in the tutorial 
without resetting the working directory.  
{: .notice} 

We want to set our working directory to the *data* folder.

###Set the Working Directory: Relative Path in Script
We can set the working directory using the code `setwd("PATH")` where PATH is 
the file path to the desired directory.  

Now, set your working directory to the folder where you have the data saved. 
There is no `R` output from `setwd()`. If we want to check that the working
directory is correctly set we can use `getwd()`.  

####Example Mac File Path
	# set the working directory to `data` folder
	setwd("/Users/neon/Documents/data")

	# check to ensure path is correct
	getwd()
	[1] "/Users/neon/Documents/data"

####Example Windows File Path
	# set the working directory to `data` folder
	setwd("C:\Users\neon\Documents\data\")

	# check to ensure path is correct
	getwd()
	[1] "\Users\neon\Documents\data"

Once set you can view the contents of the working directory in the files tab 
in RStudio. 
<figure>
	<a href="{ site.baseurl }}/images/set-working-dir/RStudio-working-directory.png">
	<img src="{ site.baseurl }}/images/set-working-dir/RStudio-working-directory.png"></a>
	<figcaption> The Files tab in RStudio shows the contents of the current
	working directory.  Source: National Ecological Observatory Network
	(NEON)  
	</figcaption>
</figure> 


###Set the Working Directory: Using RStudio GUI
To use the RStudio GUI to set the working directory:

1. go to `Session` in menu bar,
2. select `Select Working Directory`,
3. select `Choose Directory`,
4. in the new window that appears, select the appropriate directory. 

<figure>
	<a href="{ site.baseurl }}/images/set-working-dir/RStudio-GUI-setWD.png">
	<img src="{ site.baseurl }}/images/set-working-dir/RStudio-GUI-setWD.png"></a>
	<figcaption> How to set the working directory using the RStudio GUI.
	Source: National Ecological Observatory Network (NEON)  
	</figcaption>
</figure> 


###Set the Working Directory: Using R GUI

####Windows Operating Systems: 

1. go to the `File` menu bar,
2. select `Change Working Directory`,
3. in the new window that appears, select the appropriate directory.

<figure>
	<a href="{ site.baseurl }}/images/set-working-dir/Windows-RGUI-setWD.png">
	<img src="{ site.baseurl }}/images/set-working-dir/Window-RGUI-setWD.png"></a>
	<figcaption> How to set the working directory using the R GUI in Windows.
	Source: National Ecological Observatory Network (NEON) 
	</figcaption>
</figure> 

####Mac Operating Systems:

1. go to the `Misc` menu, 
2. select `Change Working Directory`,
3. in the new window that appears, select the appropriate directory.

<figure>
	<a href="{ site.baseurl }}/images/set-working-dir/Mac-RGUI-setWD.png">
	<img src="{ site.baseurl }}/images/set-working-dir/Mac-RGUI-setWD.png"></a>
	<figcaption> How to set the working directory using the R GUI in Mac OS X. 
	Source: National Ecological Observatory Network (NEON)   
	</figcaption>
</figure> 