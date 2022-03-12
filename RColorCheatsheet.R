library(ggplot2); theme_set(theme_void())


# Create a data.frame of all distinct color names in R
clr = data.frame(colorName = colors(distinct = TRUE))

# I am not interested in the grayscale, so remove those values
clr = clr[!(clr$colorName %in% c("white", "black", "lightgray", "darkgray", 
  paste0("gray", 1:99))),, drop = FALSE]

# Sort them by hue
clr = clr[order(rgb2hsv(col2rgb(clr$colorName))[1,]),, drop = FALSE]

# Add the hex value of each color
clr$hex = rgb(t(col2rgb(clr$colorName)), max = 255)

# Compute the euclidean RGB distance to black (0,0,0) and define a cutoff 
# between 0 and the max distance (white: 442) to find if the text color printed 
# should be white or black
clr$textColor = ifelse(apply(col2rgb(clr$colorName), 2, 
  function(x) sqrt(sum(x^2))) < 221, "white", "black")

# Make a 40x10 grid for a nice horizontal arrangement
clr = cbind(clr, expand.grid(y = -seq_len(40), x = seq_len(10)))


#==============================================================================#
# Main version with label and hex values                                       #
#==============================================================================#

(sheet1 = ggplot(clr, aes(x = x, y = y, fill = colorName, label = colorName,
  color = textColor)) +
    geom_tile(color = "black") +
    scale_fill_identity() +
    geom_text(aes(x = x - 0.485, y = y + 0.35), size = 1.9,
      hjust = 0, vjust = 1, fontface = "bold") +
    geom_text(aes(x = x - 0.485, y = y - 0.35, label = hex), size = 1.9,
      hjust = 0, vjust = 0, family = "mono") +
    scale_color_identity() +
    ggtitle("# R Color Cheatsheet") +
    scale_x_continuous(limits = c(0.5, 10.5), expand = c(0, 0)) +
    scale_y_continuous(limits = c(-40.5, -0.5), expand = c(0, 0)) +
    theme(legend.position = "", 
      plot.margin = unit(c(1, 1, 1, 1), "lines"),
      plot.title = element_text(size = 20, family = "mono", face = "bold", 
        margin = unit(c(0, 0, 0.5, 0), "lines")))
)

# Save with DIN paper size (A4: 210x297)
ggsave("./output/standard/R-Colors-Cheatsheet.pdf", sheet1, width = 297, 
  height = 210, units = "mm")
ggsave("./output/standard/R-Colors-Cheatsheet.png", sheet1, width = 297, 
  height = 210, units = "mm", dpi = 600)
# Standard ggsave as svg is inconsistent (fonts, sizes, ...). -> Use inkscape.
system(paste0('inkscape ',
  '--pdf-poppler ',
  '"./output/standard/R-Colors-Cheatsheet.pdf" --export-filename=',
  '"./output/standard/R-Colors-Cheatsheet.svg"'), 
  show.output.on.console = FALSE)


#==============================================================================#
# Alternative version with large labels only                                   #
#==============================================================================#

(sheet2 = ggplot(clr, aes(x = x, y = y, fill = colorName, label = colorName,
  color = textColor)) +
    geom_tile(color = "black") +
    scale_fill_identity() +
    geom_text(size = 2.6, fontface = "bold") +
    scale_color_identity() +
    ggtitle("# R Color Cheatsheet") +
    scale_x_continuous(limits = c(0.5, 10.5), expand = c(0, 0)) +
    scale_y_continuous(limits = c(-40.5, -0.5), expand = c(0, 0)) +
    theme(legend.position = "", 
      plot.margin = unit(c(1, 1, 1, 1), "lines"),
      plot.title = element_text(size = 20, family = "mono", face = "bold", 
        margin = unit(c(0, 0, 0.5, 0), "lines")))
)

ggsave("./output/large/R-Colors-Cheatsheet-large.pdf", sheet2, width = 297, 
  height = 210, units = "mm")
ggsave("./output/large/R-Colors-Cheatsheet-large.png", sheet2, width = 297, 
  height = 210, units = "mm", dpi = 600)
system(paste0('inkscape ',
  '--pdf-poppler ',
  '"./output/large/R-Colors-Cheatsheet-large.pdf" --export-filename=',
  '"./output/large/R-Colors-Cheatsheet-large.svg"'), 
  show.output.on.console = FALSE)
