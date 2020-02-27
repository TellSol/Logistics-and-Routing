
#---------------------------------------------------------------------------------------------
### THIS R-FILE CONSISTS OF SOLVING THE FOLLOWING FOUR PROBLEMS USING THE GOOGLE MAPS API: ###

###   1. VISUALIZE A ROADMAP OF GERMAY AND MARK MUNICH
###   2. MARK FIVE DISTINCT LOCATIONS ON THE GERMANY MAP
###   3. VISUALIZE A DISTRIBUTION NETWORK FOR A TRUCKING COMPANY IN COLOGNE
###   4. VISUALIZE SEVERAL TRAVELLING ROUTES ON A GLOBE BETWEEN GIVEN LOCATIONS
#---------------------------------------------------------------------------------------------

# LOAD REQUIRED PACKAGES
require("tidyverse")
require("ggmap")
require("ggthemes")
require("mapproj")
require("maps")


# REGISTER API KEY
register_google(key="insert API key here")


# ----------------------------------------------------------------------
## 1. VISUALIZE A ROADMAP OVER GERMANY AND MARK MUNICH WITH A RED CIRCLE
germany <- geocode("germany") 
munich <- geocode("munich") 
ggmap(get_map("germany", zoom = 6)) +
  geom_point(mapping = aes(x = lon, y = lat), 
             color = "red", 
             data = munich, 
             size = 12,
             shape = 21)


# ----------------------------------------------------------------------------------------------------
## 2. LETS ASSUME WE HAVE A DISTRIBUTION CENTER IN HANNOVER AND THE LOGISTICS NETWORK IS DELIVERING TO
#     FOUR OTHER GERMAN CITIES:
placenames <- c("Leipzig", "Dortmund", "Berlin", "Hamburg", "Hannover", 
                "Hannover", "Hannover", "Hannover", "Hannover")
locations <- geocode(placenames)
places <- tibble(name = placenames, lat = locations$lat,
                 lon = locations$lon)
places$grp <- c(1,2,3,4,1,1,2,3,4)


# VISUALIZE THE NETWORK FROM HANNOVER TO THE FOUR CITIES WITH... :

# ROADMAP (WHICH LOOKS KIND OF NOISY)
ggmap(get_map("germany", zoom = 6, maptype = "roadmap")) +
  geom_point(mapping = aes(x = lon, y = lat), color = "darkgreen",
             data = places, size = 12, shape = 21) +
  geom_text(mapping = aes(x = lon, y = lat, label = name),
            color = "red", data = places, nudge_y = 0.3)


# TONER-LITE STYLE
ggmap(get_map("germany", zoom = 6, maptype = "toner-lite")) +
  geom_point(mapping = aes(x = lon, y = lat), color = "darkgreen",
             data = places, size = 12, shape = 21) +
  geom_text(mapping = aes(x = lon, y = lat, label = name),
            color = "red", data = places, nudge_y = 0.3)

# TONER-BACKGROUND STYLE
ggmap(get_map("germany", zoom = 6, maptype = "toner-background")) +
  geom_point(mapping = aes(x = lon, y = lat), color = "darkgreen",
             data = places, size = 12, shape = 21) +
  geom_text(mapping = aes(x = lon, y = lat, label = name),
            color = "red", data = places, nudge_y = 0.3)

# GENERIC LONGITUDE-LATITUDE (2-DIMENSIONAL PLANE WITHOUT MAP)
ggplot(mapping =aes(x = lon, y = lat, group = grp), data = places) +
  geom_point() + 
  geom_text(mapping = aes(x = lon, y = lat, label = name),
            color = "darkgreen", data = places, nudge_y = 0.1)



# ------------------------------------------------------------------------------
## 3. VISUALIZE A TRUCKING NETWORK IN COLOGNE WITH A SOUTHERN AND NORTHERN ROUTE
##    WITH 1. A DISTRIBUTION CENTER DRIVEN NETWORK AND
##         2. A MILK-RUN DRIVEN NETWORK

# INITIAL ACQUISITION OF LONGITUDE-LATITUDE DATA FOR VISUALIZATION
deliveryNorth <- c("Pulheim", "Opladen", "Bergisch Gladbach")
locationsNorth <- geocode(deliveryNorth)
deliveryRouteNorth <- tibble(name = deliveryNorth, lat = locationsNorth$lat,
                             lon = locationsNorth$lon)
deliverySouth <- c("Kerpen", "zülpich", "Bonn", "Siegburg")
locationsSouth <- geocode(deliverySouth)
deliveryRouteSouth <- tibble(name = deliverySouth, lat = locationsSouth$lat,
                             lon = locationsSouth$lon)

locationCenter <- c("Cologne", "Cologne", "Cologne", "Cologne", "Cologne", "Cologne"
                    , "Cologne", "Cologne")
locationCenter <- geocode(locationCenter)
name <- "Cologne"
truckCenter <- cbind(name,locationCenter) %>% 
  as.tibble()

logisticsNetwork <- rbind(deliveryRouteNorth, truckCenter, deliveryRouteSouth)


# VISUALIZATION OF NETWORK WITH ROADMAP
ggmap(get_map("Cologne", zoom = 10, maptype = "roadmap")) +
  geom_point(mapping = aes(x = lon, y = lat), color = "darkgreen",
             data = logisticsNetwork, size = 12, shape = 21) +
  geom_text(mapping = aes(x = lon, y = lat, label = name),
            color = "red", data = places, nudge_y = 0.3)

# GENERIC LONGITUDE LATITUDE ON A 2-DIMENSIONAL PLANE 
ggplot(mapping = aes(x = lon, y = lat), data = logisticsNetwork) +
  geom_point() +
  geom_text(mapping = aes(x = lon, y = lat, label = name),
            color = "black", data = logisticsNetwork, nudge_y = 0.02) +
  theme_few()


# ---------------------------------------
## 3.1 DISTRIBUTION CENTER DRIVEN NETWORK
logisticsNetwork$group <- c(1,2,3,1,2,3,4,5,6,7,7,4,5,6,7)

ggplot(mapping = aes(x = lon, y = lat, group = group), data = logisticsNetwork) +
  geom_point() + geom_line() +
  geom_text(mapping = aes(x = lon, y = lat, label = name),
            color = "black", data = logisticsNetwork, nudge_y = 0.02) +
  theme_few()


# ---------------------------------------
## 3.2 MILK-RUN DRIVEN NETWORK
##     (double locations for connections)
deliveryNorth <- c("Pulheim", "Pulheim", "Opladen", "Opladen", "Bergisch Gladbach", "Bergisch Gladbach")
locationsNorth <- geocode(deliveryNorth)
deliveryRouteNorth <- tibble(name = deliveryNorth, lat = locationsNorth$lat,
                             lon = locationsNorth$lon)

deliverySouth <- c("Kerpen", "Kerpen", "zülpich", "zülpich", "Bonn",  "Bonn", "Siegburg", "Siegburg")
locationsSouth <- geocode(deliverySouth)
deliveryRouteSouth <- tibble(name = deliverySouth, lat = locationsSouth$lat,
                             lon = locationsSouth$lon)

locationCenter <- c("Cologne", "Cologne", "Cologne", "Cologne", "Cologne")
locationCenter <- geocode(locationCenter)
name <- "Cologne"
truckCenter <- cbind(name,locationCenter) %>% 
  as.tibble()

logisticsNetworkMilkRun <- rbind(deliveryRouteNorth, deliveryRouteSouth, truckCenter)
logisticsNetworkMilkRun$group <- c(1,2,2,3,3,4,5,6,6,7,7,8,8,9,1,4,5,9,1)

ggplot(mapping = aes(x = lon, y = lat, group = group), data = logisticsNetworkMilkRun) +
  geom_point() + geom_path() +
  geom_text(mapping = aes(x = lon, y = lat, label = name),
            color = "black", data = logisticsNetworkMilkRun, nudge_y = 0.02) +
  theme_few()



# ----------------------------------------------
## 4. VISUALIZE SEVERAL LOCATIONS ON A WORLD MAP
##    (dashed lines are travelling routes)

cities <- c("Madrid", "Johannesburg", "Istanbul",                
               "Hong Kong", "Kyoto", "Kuala Lumpur", "Bergen")
citiesData <- geocode(cities)

mapData <- cbind(cities,citiesData) %>% 
  as.tibble()

group <- c(2,3,3,3,1,2,1)
mapData1 <- cbind(mapData, group) %>% 
  as.tibble()

world <- map_data("world")

ggplot(mapping = aes(x = lon, y = lat, group = group), data = mapData1) +
  geom_polygon(data = world,  aes(long, lat, group = group),
               fill = "lightblue") +
  geom_point(data = mapData1, aes(lon, lat),
             colour = "red", size = 3, shape = 21) + 
  coord_map("ortho", orientation = c(30, 80, 0)) +
  geom_text(mapping = aes(x = lon, y = lat, label = cities),
            color = "black", data = mapData, nudge_y = 6) +
  geom_line(linetype = "dashed")
  theme_void()









