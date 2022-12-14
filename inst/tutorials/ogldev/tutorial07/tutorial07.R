library(glfw)

angle_in_radians <- 0.0
delta <- 0.01

render_scene <- function(window, vbo, g_rotation_location) {
  gl_clear(GL$COLOR_BUFFER_BIT)

  angle_in_radians <<- angle_in_radians + delta
  if ((angle_in_radians >= 1.5708) || (angle_in_radians <= -1.5708)) {
    delta <<- -delta
  }

  m <- matrix(
    c(cos(angle_in_radians), -sin(angle_in_radians), 0, 0,
      sin(angle_in_radians), cos(angle_in_radians), 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 1),
    nrow = 4L,
    byrow = TRUE
  )

  gl_uniform_matrix4_fv(g_rotation_location,
                        transpose = GL$`TRUE`,
                        value = m)

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

  g_rotation_location <- gl_get_uniform_location(shader_program, "gRotation")
  if (g_rotation_location == -1L)
    stop("Error getting uniform location of 'gRotation'")

  gl_validate_program(shader_program)
  if(!gl_get_program_iv(shader_program, GL$VALIDATE_STATUS)) {
    stop(gl_get_program_info_log(shader_program))
  }

  gl_use_program(shader_program)

  return(g_rotation_location)
}

glfw_init()

width <- 400L
height <- 400L

window <- glfw_create_window(width, height, "Tutorial 07: rotation transformation")
glfw_make_context_current(window)
glad_load_gl()

gl_clear_color(0, 0, 0, 0)

vbo <- create_vertex_buffer()

g_rotation_location <-
  compile_shaders(
    vs_file = system.file("tutorials/ogldev/tutorial07/shader.vs", package = "glfw"),
    fs_file = system.file("tutorials/ogldev/tutorial07/shader.fs", package = "glfw")
  )

while (!glfw_window_should_close(window))
{
  if (glfw_get_key(window, GLFW$KEY_ESCAPE) == GLFW$PRESS)
    glfw_set_window_should_close(window, 1)

  render_scene(window, vbo, g_rotation_location)
  glfw_poll_events()
}

glfw_destroy_window(window)
glfw_terminate()
