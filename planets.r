# Plot the distance to Earth for Mercury, Venus, and Mars.
#
# Uses data taken from the Jet Propulsion Laboratory's DE432 ephemeris. See
# accompanying Python script to see how the magic happens.
library(dplyr)   # v0.7.8
library(ggplot2) # v3.1.0
library(readr)   # v1.3.0
library(scales)  # v1.0.0
library(stringr) # v1.3.1
library(tidyr)   # v0.8.2


# Import data containing past and future distances of Mercury, Venus, and Mars
# to the Earth. Run `python3 planets.py > planets.csv` to build the CSV file.
planets <- read_csv("planets.csv") %>%
  mutate(planet = str_to_title(str_extract(planet, "[A-Z]+$"))) %>%
  filter(date >= as.Date("2018-01-01")) %>%
  filter(date <= as.Date("2026-12-31"))

# Plot the distance from Mercury, Venus, and Mars to Earth.
planets %>%
  ggplot(aes(date, distance, group = planet, colour = planet)) +
  geom_line(size = .8) +
  scale_x_date(date_breaks = "1 year",
               date_labels = "%Y") +
  scale_y_continuous(breaks = c(0, 1, 2),
                     limits = c(0, 2.75),
                     expand = c(0, 0),
                     labels = unit_format(unit = " au")) +
  scale_colour_manual(values = c("Mercury" = "#4daf4a",
                                 "Venus" = "#377eb8",
                                 "Mars" = "#e41a1c")) +
  labs(title = "Hello neighbour",
       subtitle = "What’s the distance between Earth and its nearest planetary neighbours?",
       x = NULL,
       y = NULL,
       caption = "Source: Jet Propulsion Laboratory") +
  guides(colour = guide_legend(title = NULL))

# Calculate which planet is nearest to Earth on a given day.
nearest_planet <- planets %>%
  spread(planet, distance) %>%
  rowwise() %>%
  mutate(planet = if_else(Mercury == min(Mercury, Venus, Mars), "Mercury", ""),
         planet = if_else(Venus == min(Mercury, Venus, Mars), "Venus", planet),
         planet = if_else(Mars == min(Mercury, Venus, Mars), "Mars", planet),
         distance = if_else(Mercury == min(Mercury, Venus, Mars), Mercury, .0),
         distance = if_else(Venus == min(Mercury, Venus, Mars), Venus, distance),
         distance = if_else(Mars == min(Mercury, Venus, Mars), Mars, distance)) %>%
  select(date, planet, distance)

# Plot the distance between Earth and whichever planet is its nearest
# neighbour.
ggplot() +
  geom_line(data = planets,
            map = aes(date, distance, group = planet, colour = planet),
            alpha = 0.3) +
  geom_line(data = nearest_planet,
            map = aes(date, distance),
            colour = "#000000",
            size = .8) +
  scale_x_date(date_breaks = "1 year",
               date_labels = "%Y") +
  scale_y_continuous(breaks = c(0, 1, 2),
                     limits = c(0, 2.75),
                     expand = c(0, 0),
                     labels = unit_format(unit = " au")) +
  scale_colour_manual(values = c("Mercury" = "#4daf4a",
                                 "Venus" = "#377eb8",
                                 "Mars" = "#e41a1c")) +
  labs(title = "The wanderers of the solar system",
       subtitle = "What’s the distance between Earth and its nearest planetary neighbour?",
       x = NULL,
       y = NULL,
       caption = "Source: Jet Propulsion Laboratory") +
  annotate("text",
           label = "Nearest planet",
           x = as.Date("2021-08-01"),
           y = 1.9,
           size = 4) +
  annotate("segment",
           colour = "black",
           x = as.Date("2021-08-01"),
           xend = as.Date("2021-08-01"),
           y = 1.4,
           yend = 1.75) +
  guides(colour = guide_legend(title = NULL))
