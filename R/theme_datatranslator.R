dt_navy   <- "#202C39"
dt_grey   <- "#ECF0F4"
dt_teal   <- "#55868C"
dt_coral  <- "#FF4F5C"
dt_amber  <- "#EDAE49"
dt_border <- "#DCE1E7"

dt_systems <- c("#A0BBC0", "#55868C", "#3A5962")

theme_dt <- function(base_size = 12) {
  theme_minimal(base_size = base_size, base_family = "Work Sans") +
    theme(
      text             = element_text(colour = dt_navy),
      plot.title       = element_text(family = "Roboto Mono", face = "bold",
                                      size = rel(1.1)),
      axis.text        = element_text(colour = dt_teal),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(colour = dt_border),
      plot.caption     = element_text(colour = dt_teal, hjust = 0),
      plot.background  = element_rect(fill = dt_grey, colour = NA),
      panel.background = element_rect(fill = dt_grey, colour = NA)
    )
}

scale_fill_dt   <- function(...) scale_fill_manual(values = dt_systems, ...)
scale_colour_dt <- function(...) scale_colour_manual(values = dt_systems, ...)