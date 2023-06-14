

library("httr")
library("dplyr")
library("jsonlite")
library(stringr)
library(dplyr)

banco_de_alimentos <- function(banco) {
url <- paste0("https://www.givefood.org.uk/api/2/foodbank/", banco ,"/")
request <- GET(url)
respuesta <- content(request) 

nombres <- c()
fecha_acum <- c()
url_s <- c()
for (i in 1:length(respuesta$nearby_foodbanks)) {
  urls <- respuesta$nearby_foodbanks[[i]]$urls$self
  url_s <- c(urls,url_s)
  a <- GET(urls)
  b <- content(a)
  fecha <- b$created
  fecha_acum <- c(fecha,fecha_acum)
  nombre <- b$name
  nombres <- c(nombre, nombres)
  
}

df <- as.data.frame(cbind(nombres, fecha_acum,url_s))
df$fecha_acum <- as.Date(fecha_acum)
Name <- df[which.min(df$fecha_acum),]$nombres
Fecha <- df[which.min(df$fecha_acum),]$fecha_acum
url <- df[which.min(df$fecha_acum),]$url_s

response <- content(GET(url))
necesidades <- response$need$needs

print(paste0("el banco de alimentos mas antiguo es ",Name, " creado en ",Fecha, "y sus necesidades son : ",necesidades))
}

banco_de_alimentos("black-country")
