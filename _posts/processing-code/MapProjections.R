library(rgdal)
library(ggplot2)
library(rgeos)
setwd("~/Documents/data")
# http://rpsychologist.com/working-with-shapefiles-projections-and-world-maps-in-ggplot
# read shapefile
worldBound <- readOGR(dsn="Global/Boundaries/ne_110m_land", 
                      layer="ne_110m_land")



# convert to dataframe
worldBound_df <- fortify(worldBound)  



# plot map
ggplot(worldBound_df, aes(long,lat, group=group)) +
  geom_polygon() +
  labs(title="World map (longlat)") +
  coord_equal() +
  ggtitle("Geographic - WGS84 Datum")


## add graticules
graticule <- readOGR("Global/Boundaries/ne_110m_graticules_all", layer="ne_110m_graticules_15") 
graticule_df <- fortify(graticule)

bbox <- readOGR("Global/Boundaries/ne_110m_graticules_all", layer="ne_110m_wgs84_bounding_box") 
bbox_df<- fortify(bbox)

#turn off axis elements in ggplot for better visual comparison
newTheme <- list(theme(line = element_blank(),
      text = element_blank(),
      line = element_blank(),
      title = element_blank()))


ggplot(bbox_df, aes(long,lat, group=group)) + 
  geom_polygon(fill="white") +
  geom_polygon(data=worldBound_df, aes(long,lat, group=group, fill=hole)) + 
  geom_path(data=graticule_df, aes(long, lat, group=group, fill=NULL), linetype="dashed", color="grey70") +
  labs(title="World map + graticule (longlat)") + 
  coord_equal() + newTheme +
  scale_fill_manual(values=c("black", "white"), guide="none") # change colors & remove legend


# plot map
ggplot(worldBound_df, aes(long,lat, group=group)) +
  geom_polygon() +
  labs(title="World map (longlat)") +
  coord_equal() +
  ggtitle("Geographic - WGS84 Datum")



# reproject from longlat to robinson
worldBound_robin <- spTransform(worldBound,
                                CRS("+proj=robin"))
worldBound_df_robin <- fortify(wmap_robin)
ggplot(worldBound_df_robin, aes(long,lat, group=group)) +
  geom_polygon() +
  labs(title="World map (robinson)") +
  coord_equal()


#to do this we need to first crop the data to the boundar of mercator which is
# 82 degrees  north and south

xmin        : -180 
xmax        : 180 
ymin        : -90 
ymax        : 83.64513 

extent(worldBound)
newExt <- extent(worldBound)
#redefine the extent to the limits of mercator EPSG 3395
newExt@ymin <- -80
newExt@ymax <- 80
newExt

#crop data to new extent
merc_WorldBound <- crop(worldBound,
                        newExt)

# reproject from longlat to mercator
worldBound_merc <- spTransform(merc_WorldBound,
                          CRS("+init=epsg:3395"))

worldBound_df_merc <- fortify(worldBound_merc)
ggplot(worldBound_df_merc, aes(long,lat, group=group)) +
  geom_polygon() +
  labs(title="World map (Mercator Projection)") +
  coord_equal()
