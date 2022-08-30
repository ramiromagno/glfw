## code to prepare `GLFW` dataset goes here
library(tidyverse)
glfw_header <- "/usr/include/GLFW/glfw3.h"
txt_lines <- read_lines(glfw_header)
txt_defines <- grep("^#define GLFW_", txt_lines, value = TRUE)
constants <- sub("#define GLFW_", "", txt_defines)
lst <- str_split(constants, "\\s+")
lst <- setNames(lst, sapply(lst,"[", 1))

# TODO: Make this more automatic, right now is set explicitly
lst$HAT_RIGHT_UP[2] <- bitwOr(as.integer(lst$HAT_RIGHT[2]), as.integer(lst$HAT_UP[2]))
lst$HAT_RIGHT_DOWN[2] <- bitwOr(as.integer(lst$HAT_RIGHT[2]), as.integer(lst$HAT_DOWN[2]))
lst$HAT_LEFT_UP[2] <- bitwOr(as.integer(lst$HAT_LEFT[2]), as.integer(lst$HAT_UP[2]))
lst$HAT_LEFT_DOWN[2] <- bitwOr(as.integer(lst$HAT_LEFT[2]), as.integer(lst$HAT_DOWN[2]))
lst$KEY_LAST[2] <- lst$KEY_MENU[2]
lst$MOUSE_BUTTON_LAST[2] <- lst$MOUSE_BUTTON_8[2]
lst$MOUSE_BUTTON_LEFT[2] <- lst$MOUSE_BUTTON_1[2]
lst$MOUSE_BUTTON_RIGHT[2] <- lst$MOUSE_BUTTON_2[2]
lst$MOUSE_BUTTON_MIDDLE[2] <- lst$MOUSE_BUTTON_3[2]
lst$JOYSTICK_LAST[2] <- lst$JOYSTICK_16[2]
lst$GAMEPAD_BUTTON_LAST[2] <- lst$GAMEPAD_BUTTON_DPAD_LEFT[2]
lst$GAMEPAD_BUTTON_CROSS[2] <- lst$GAMEPAD_BUTTON_A[2]
lst$GAMEPAD_BUTTON_CIRCLE[2] <- lst$GAMEPAD_BUTTON_B[2]
lst$GAMEPAD_BUTTON_SQUARE[2] <- lst$GAMEPAD_BUTTON_X[2]
lst$GAMEPAD_BUTTON_TRIANGLE[2] <- lst$GAMEPAD_BUTTON_Y[2]
lst$GAMEPAD_AXIS_LAST[2] <- lst$GAMEPAD_AXIS_RIGHT_TRIGGER[2]

tbl <- map_dfr(lst, \(el) c(name = el[1], value = el[2]) )

values <-
  map(as.list(as.double(tbl$value)), \(x) if (x >= .Machine$integer.max)
    as.double(x)
    else
      as.integer(x))

GLFW <- setNames(values, tbl$name)
usethis::use_data(GLFW, overwrite = TRUE)
