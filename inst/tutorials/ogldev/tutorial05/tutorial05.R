library(glfw)

scale <- 0.0
delta <- 0.005

render_scene <- function(window, vbo, g_scale_location) {
  gl_clear(GL$COLOR_BUFFER_BIT)

  scale <<- scale + delta
  if (scale >= 1 || scale <= -1) {
    delta <<- -delta
  }

  gl_uniform_f(g_scale_location, scale)
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

add_shader <- function(shader_program, shader_text, shader_type) {

  shader <- gl_create_shader(shader_type)
  if (!shader)
    stop("Error creating shader type", shader_type)

  gl_shader_source(shader, 1L, shader_text)
  gl_compile_shader(shader)
  if (!gl_get_shader_iv(shader, GL$COMPILE_STATUS)) {
    stop(gl_get_shader_info_log(shader))
  }

  gl_attach_shader(shader_program, shader)
}

compile_shaders <- function(vs_file, fs_file) {
  shader_program <- gl_create_program()
  if (!shader_program)
    stop("Error creating shader program")

  # Vertex shader source code
  vs_txt <- read_shader(vs_file)
  fs_txt <- read_shader(fs_file)

  add_shader(shader_program, vs_txt, GL$VERTEX_SHADER)
  add_shader(shader_program, fs_txt, GL$FRAGMENT_SHADER)

  gl_link_program(shader_program)
  if(!gl_get_program_iv(shader_program, GL$LINK_STATUS)) {
    stop(gl_get_program_info_log(shader_program))
  }

  g_scale_location <- gl_get_uniform_location(shader_program, "gScale")
  if (g_scale_location == -1L)
    stop("Error getting uniform location of 'gScale'")

  gl_validate_program(shader_program)
  if(!gl_get_program_iv(shader_program, GL$VALIDATE_STATUS)) {
    stop(gl_get_program_info_log(shader_program))
  }

  gl_use_program(shader_program)

  return(g_scale_location)
}

glfw_init()

width <- 400L
height <- 200L

window <- glfw_create_window(width, height, "Tutorial 05: uniform variables")
glfw_make_context_current(window)
glad_load_gl()

gl_clear_color(0, 0, 0, 0)

vbo <- create_vertex_buffer()

g_scale_location <-
  compile_shaders(
    vs_file = system.file("tutorials/ogldev/tutorial05/shader.vs", package = "glfw"),
    fs_file = system.file("tutorials/ogldev/tutorial05/shader.fs", package = "glfw")
  )

while (!glfw_window_should_close(window))
{
  if (glfw_get_key(window, GLFW$KEY_ESCAPE) == GLFW$PRESS)
    glfw_set_window_should_close(window, 1)

  render_scene(window, vbo, g_scale_location)
  glfw_poll_events()
}

glfw_destroy_window(window)
glfw_terminate()
