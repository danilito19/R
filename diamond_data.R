### explore diamond database

library(ggplot2)

data(diamonds)
?diamonds

###scatterplot of price versus x
ggplot(aes(x=price, y = x), data = diamonds) +
  geom_point() +
  coord_cartesian(ylim= c(3,9.5))

###correlation between variables, detault is pearson
cor.test(diamonds$price, diamonds$x)
cor.test(diamonds$price, diamonds$y)
cor.test(diamonds$price, diamonds$z)
cor.test(diamonds$price, diamonds$depth)

###scatterplot of price versus depth
ggplot(aes(x=price, y = depth), data = diamonds) +
  geom_point(alpha = 1/100) 

###scatterplot of price versus carat, omit top 1% of price and carat
ggplot(aes(x=price, y = carat), data = diamonds) +
  geom_point()
  xlim(0, quantile(diamonds$price, 0.99)) +
  ylim(0, quantile(diamonds$carat, 0.99)) 

###scatterplot of price vs. volume (x * y * z), create volume var, then create new df with volume filtered

diamonds$volume <- diamonds$x * diamonds$y * diamonds$z
diamonds.volume_filtered <- subset(diamonds,diamonds$volume>0 & diamonds$volume<=800)

ggplot(aes(x=price, y =volume), data = diamonds.volume) +
  geom_point()

###correlation of price and volume
cor.test(diamonds.volume$price, diamonds.volume$volume)

###improve previous volume plot
ggplot(aes(x=price, y =volume), data = diamonds.volume) +
  geom_point(alpha = 1/25) +
  geom_smooth(method = "lm")

###used dplyr to create new df of diamonds by clarity grouping and include mean, median, etc price
library(dplyr)
by_clarity <- group_by(diamonds, clarity)
diamondsByClarity <- summarize(by_clarity,
                    n=n(),
                    mean_price = mean(price),
                    median_price = median(price),
                    min_price = min(price),
                    max_price = max(price))

###do the same for color with just mean
by_color <- group_by(diamonds, color)
diamondsByColor <- summarise(by_color, mean_price = mean(price))


###create grids of price of mean color and clarity
library(gridExtra)
p1 <- ggplot(aes(x=mean_price, y = clarity), data = diamondsByClarity) +
  geom_bar(stat = "identity")

p2 <- ggplot(aes(x=mean_price, y = color), data = diamondsByColor) +
  geom_bar(stat = "identity")

grid.arrange(p1, p2, ncol = 2)
###D is best color yet it has the lowest price.

# Create a histogram of diamond prices.
# Facet the histogram by diamond color
# and use cut to color the histogram bars.

ggplot(aes(x=price), data = diamonds) +
  geom_histogram(aes(color = cut)) +
  facet_wrap(~color) +
  scale_fill_brewer(type = 'qual')

# Create a scatterplot of diamond price vs.
# table and color the points by the cut of
# the diamond.

ggplot(aes(x=table, y = price), data= diamonds) +
  geom_point(aes(color = cut))

# Create a scatterplot of diamond price vs.
# volume (x * y * z) and color the points by
# the clarity of diamonds. Use scale on the y-axis
# to take the log10 of price. You should also
# omit the top 1% of diamond volumes from the plot.

diamonds$volume <- diamonds$x*diamonds$y*diamonds$z
diamonds.volume_filtered <- subset(diamonds,diamonds$volume>0 & diamonds$volume<=800)

ggplot(aes(x=volume, y = price), data= diamonds) +
  geom_point(aes(color = clarity)) +
  scale_y_log10() +
  xlim(0, quantile(diamonds$volume, 0.99)) 

# Create a scatter plot of the price/carat ratio
# of diamonds. The variable x should be
# assigned to cut. The points should be colored
# by diamond color, and the plot should be
# faceted by clarity.
###added jitter to make it nicer to see instead of geom_point

diamonds$p.c.ratio <- diamonds$price / diamonds$carat
ggplot(aes(x=cut, y = p.c.ratio), data=diamonds) +
  geom_jitter(aes(color = color)) +
  facet_wrap(~clarity)

