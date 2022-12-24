mouse_callback <- function(window, xpos, ypos)
{

  if (first_mouse)
  {
    last_x <<- xpos
    last_y <<- ypos
    first_mouse <<- FALSE
  }

  xoffset <- xpos - last_x
  yoffset <- last_y - ypos
  last_x <<- xpos
  last_y <<- ypos

  camera <<- process_mouse_movement(camera, xoffset, yoffset)
}

scroll_cb <- function(window, xoffset, yoffset) {
  camera <<- process_mouse_scroll(camera, yoffset)
}

process_input <-
  function(window, delta_time) {
    if (glfw_get_key(window, GLFW$KEY_ESCAPE) == GLFW$PRESS)
      glfw_set_window_should_close(window, 1L)

    if (glfw_get_key(window, GLFW$KEY_W) == GLFW$PRESS)
     camera <- process_keyboard(camera, FORWARD, delta_time)

    if (glfw_get_key(window, GLFW$KEY_S) == GLFW$PRESS)
      camera <- process_keyboard(camera, BACKWARD, delta_time)

    if (glfw_get_key(window, GLFW$KEY_A) == GLFW$PRESS)
      camera <- process_keyboard(camera, LEFT, delta_time)

    if (glfw_get_key(window, GLFW$KEY_D) == GLFW$PRESS)
      camera <- process_keyboard(camera, RIGHT, delta_time)

    return(camera)
  }

fb_size_cb <- function(window, width, height)
  gl_viewport(0L, 0L, width = width, height = height)
