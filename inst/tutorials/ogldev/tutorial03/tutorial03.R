library(glfw)

render_scene <- function(window, vbo) {
  gl_clear(GL$COLOR_BUFFER_BIT)
  gl_bind_buffer(GL$ARRAY_BUFFER, vbo)
  gl_enable_vertex_attrib_array(0L)
  gl_vertex_attrib_pointer(0L, 3L, GL$DOUBLE, GL$`FALSE`, 0L, 0L)
  gl_draw_arrays(GL$TRIANGLES, 0L, 3L)
  gl_disable_vertex_attrib_array(0L)
  glfw_swap_buffers(window)
}

create_vertex_buffer <- function() {
  vertices <-
    c(
      -1, -1,  0, # bottom left
       1, -1,  0, # bottom right
       0,  1,  0  # top
      )

  vbo <- gl_gen_buffers(1L)
  gl_bind_buffer(GL$ARRAY_BUFFER, vbo)
  gl_buffer_data(GL$ARRAY_BUFFER, vertices, GL$STATIC_DRAW)
  return(vbo)
}

glfw_init()

width <- 400L
height <- 200L

window <- glfw_create_window(width, height, "Tutorial 03: first triangle")
glfw_make_context_current(window)
glad_load_gl()

gl_clear_color(0, 0, 0, 0)

vbo <- create_vertex_buffer()

while (!glfw_window_should_close(window))
{
  if (glfw_get_key(window, GLFW$KEY_ESCAPE) == GLFW$PRESS)
    glfw_set_window_should_close(window, 1)

  render_scene(window, vbo)
  glfw_poll_events()
}

glfw_destroy_window(window)
glfw_terminate()
