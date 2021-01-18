library(ggplot2); theme_set(theme_void())
library(shadowtext)
library(svglite)

# Create a data.frame of all distinct color names in R
clr = data.frame(colorName = colors(distinct = TRUE))

# I am not interested in the grayscale, so remove those values
clr = clr[!(clr$colorName %in% c("white", "black", "lightgray", "darkgray", 
  paste0("gray", 1:99))),, drop = FALSE]

# Sort them by hue
clr = clr[order(rgb2hsv(col2rgb(clr$colorName))[1,]),, drop = FALSE]

# Make a 40x10 grid for a nice horizontal arrangement
clr = cbind(clr, expand.grid(y = -seq_len(40), x = seq_len(10)))

# Build the plot object
sheet = ggplot(clr, aes(x = x, y = y, fill = colorName, label = colorName)) +
  geom_tile(color = "black") +
  scale_fill_identity() +
  geom_shadowtext(aes(x = x - .45), size = 1.9, fontface = "bold", hjust = 0) +
  ggtitle("# All Built-in Color Names of R") +
  theme(legend.position = "", 
    plot.margin = unit(c(0, -1, -.5, -1), "lines"),
    plot.title = element_text(size = 20, hjust = 0.1, vjust = -2, 
      family = "mono", face = "bold"))

# Create png pdf and svg versions of the plot
ggsave("./output/outlined/R-Colors-Cheatsheet.png", sheet, width = 9.6, 
  height = 5.4, dpi = 400)
ggsave("./output/outlined/R-Colors-Cheatsheet.pdf", sheet, width = 9.6, 
  height = 5.4)
ggsave("./output/outlined/R-Colors-Cheatsheet.svg", sheet, width = 9.6, 
  height = 5.4)


#==============================================================================#
# Alternative version with black and white text labels                         #
#==============================================================================#

# Compute the euclidean RGB distance to black (0,0,0) and define a cutoff 
# between 0 and the max distance (white: 442) to find if the text color printed 
# should be white or black
clr$textColor = ifelse(apply(col2rgb(clr$colorName), 2, 
  function(x) sqrt(sum(x^2))) < 221, "white", "black")

# Create the plot
sheet2 = ggplot(clr, aes(x = x, y = y, fill = colorName, label = colorName)) +
  geom_tile(color = "black") +
  scale_fill_identity() +
  geom_text(aes(x = x - 0.45, color = textColor), size = 2, fontface = "bold", 
    hjust = 0) +
  scale_color_identity() +
  ggtitle("# All Built-in Color Names of R") +
  theme(legend.position = "", 
    plot.margin = unit(c(0, -1, -.5, -1), "lines"),
    plot.title = element_text(size = 20, hjust = 0.1, vjust = -2, 
      family = "mono", face = "bold"))

# Create png pdf and svg versions of the plot
ggsave("./output/bw_text/R-Colors-Cheatsheet.png", sheet2, width = 9.6, 
  height = 5.4, dpi = 400)
ggsave("./output/bw_text/R-Colors-Cheatsheet.pdf", sheet2, width = 9.6, 
  height = 5.4)
ggsave("./output/bw_text/R-Colors-Cheatsheet.svg", sheet2, width = 9.6, 
  height = 5.4)
