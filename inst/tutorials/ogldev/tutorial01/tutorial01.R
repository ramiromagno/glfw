library(glfw)

render_scene_cb <- function(window) {
  gl_clear(GL$COLOR_BUFFER_BIT)
  glfw_swap_buffers(window)
}

glfw_init()
glfw_window_hint(GLFW$CONTEXT_VERSION_MAJOR, 3L)
glfw_window_hint(GLFW$CONTEXT_VERSION_MINOR, 3L)
glfw_window_hint(GLFW$OPENGL_PROFILE, GLFW$OPENGL_CORE_PROFILE)

width <- 1920L
height <- 1080L

window <- glfw_create_window(width, height, "Tutorial 01: open a window")

glfw_make_context_current(window)
glad_load_gl()

x <- 200L
y <- 100L

glfw_set_window_pos(window, x, y)
gl_clear_color(0, 0, 0, 0)

while (!glfw_window_should_close(window))
{
  if (glfw_get_key(window, GLFW$KEY_ESCAPE) == GLFW$PRESS)
    glfw_set_window_should_close(window, 1)

  render_scene_cb(window)
  glfw_poll_events()
}

glfw_destroy_window(window)
glfw_terminate()
