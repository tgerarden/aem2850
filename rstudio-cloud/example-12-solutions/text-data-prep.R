renv::load("~/Documents/GitHub/aem2850")

library(tidyverse)
library(harrypotter)

hp <- tibble(book = c("Philosopher's Stone", "Chamber of Secrets", 
                      "Prisoner of Azkaban", "Goblet of Fire", 
                      "Order of the Phoenix", "Half-Blood Prince",
                      "Deathly Hallows"),
             raw_text = list(philosophers_stone, chamber_of_secrets, 
                             prisoner_of_azkaban, goblet_of_fire, 
                             order_of_the_phoenix, half_blood_prince,
                             deathly_hallows)) |> 
  mutate(text_data = map(raw_text, ~{
    tibble(text = .x) |> 
      mutate(chapter = 1:n())
  })) |> 
  select(book, text_data) |> 
  unnest(text_data) |> 
  mutate(book = fct_inorder(book))

save(hp, file = "hp.RData")
