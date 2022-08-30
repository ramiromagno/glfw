#
# OpenGL C preprocessor constants from glad/glad.h
#

library(tidyverse)
glad_header <- here::here("src", "glad", "glad.h")
txt_lines <- read_lines(glad_header)
txt_defines <- grep("^#define GL_", txt_lines, value = TRUE)
constants <- sub("#define GL_", "", txt_defines)
lst <- str_split(constants, " ")
tbl <- map_dfr(lst, \(el) c(name = el[1], value = el[2]) )
values <-
  map(as.list(as.double(tbl$value)), \(x) if (x >= .Machine$integer.max)
    as.double(x)
    else
      as.integer(x))

GL <- setNames(values, tbl$name)
usethis::use_data(GL, overwrite = TRUE)
