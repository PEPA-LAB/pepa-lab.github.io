
library(tidyverse)
library(yaml)



pub_richard <- read_delim("https://dial.uclouvain.be/DialExport/Bibliography?method=bibliography&type=classic&author=Lambert,%20Richard&sort=documentType&sortType=asc&format=CSV", delim=';')

pub_alj <- read_delim("https://dial.uclouvain.be/DialExport/Bibliography?method=bibliography&type=classic&author=Jacquemart,%20Anne-Laure&sort=documentType&sortType=asc&format=CSV", delim=';')

pub_xavier <- read_delim("https://dial.uclouvain.be/DialExport/Bibliography?method=bibliography&type=classic&author=Draye,%20Xavier&sort=documentType&sortType=asc&format=CSV", delim=';')

pub_val <- read_delim("https://dial.uclouvain.be/DialExport/Bibliography?method=bibliography&type=classic&author=Couvreur,%20Valentin&sort=documentType&sortType=asc&format=CSV", delim=';')

pub_pierre <- read_delim("https://dial.uclouvain.be/DialExport/Bibliography?method=bibliography&type=classic&author=Bertin,%20Pierre&sort=documentType&sortType=asc&format=CSV", delim=';')

pub_guillaume <- read_delim("https://dial.uclouvain.be/DialExport/Bibliography?method=bibliography&type=classic&author=Lobet,%20Guillaume&sort=documentType&sortType=asc&format=CSV", delim=';')

pub_nico <- read_delim("https://dial.uclouvain.be/DialExport/Bibliography?method=bibliography&type=classic&author=Biot,%20Nicolas&sort=documentType&sortType=asc&format=CSV", delim=';')

pubs_all <- rbind(pub_guillaume, 
                  pub_val, 
                  pub_alj, 
                  pub_pierre, 
                  pub_richard, 
                  pub_xavier, 
                  pub_nico) %>% 
  mutate(type = "journal", 
         year = as.numeric(ANNÉE), 
         authors = `AUTEUR(S)`, 
         title = gsub(pattern = ':', ' ', TITRE), 
         doi = DOI) %>% 
  select(type, year, authors, title, doi) %>% 
  filter(!is.na(doi))%>% 
  filter(year > 2015) %>% 
  arrange(desc(year)) %>% 
  distinct(doi, .keep_all=T)

# Step 2: Convert each row to a list
list_data <- apply(pubs_all, 1, as.list)

# Convert specific columns to numeric
for (i in seq_along(list_data)) {
  list_data[[i]]$year <- as.integer(list_data[[i]]$year)
}

# Step 3: Convert the list of lists to YAML
yaml_content <- as.yaml(list_data)

# Step 3: Write the YAML content to a file
writeLines(yaml_content, "~/Desktop/output_pubs_pepa.yml")

