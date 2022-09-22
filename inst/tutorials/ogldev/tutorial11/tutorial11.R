library(glfw)

scale_transform <- function(vec3) {
  glm_scale(diag(1, nrow = 4), c(vec3, 1))
}

# angle3: 3-element vector of three rotation angles (in degrees)
rotate_transform <- function(angle3) {
  # Rotation around the x-axis
  rot_x <- glm_rotate(diag(1, nrow = 4), glm_rad(angle3[1]), c(1, 0, 0))

  # Rotation around the y-axis
  rot_y <- glm_rotate(diag(1, nrow = 4), glm_rad(angle3[2]), c(0, 1, 0))
  # patch
  # waiting for reply on https://github.com/emeiri/ogldev/issues/14
  rot_y[1, 3] <- -rot_y[1, 3]
  rot_y[3, 1] <- -rot_y[3, 1]


  # Rotation around the z-axis
  rot_z <- glm_rotate(diag(1, nrow = 4), glm_rad(angle3[3]), c(0, 0, 1))

  rot_x %*% rot_y %*% rot_z
}

translation_transform <- function(vec3) {
  glm_translate(diag(1, nrow = 4), v = vec3)
}

world_transform <- function(scale3, world_pos3, rotation3) {
  translation_transform(world_pos3) %*% rotate_transform(rotation3) %*% scale_transform(scale3)
}

render_scene <- function(window, vbo, ibo, g_world_location, scale)
{

  gl_clear(GL$COLOR_BUFFER_BIT)
  scale <- scale + 0.01
  scale3 <- sin(0.1 * rep(scale, 3))
  world_pos3 <- c(sin(scale), 0, 0)
  rotation3 <- sin(rep(scale, 3)) * 90
  world <- world_transform(scale3, world_pos3, rotation3)

  #print(world)
  #flush.console()
  #stop("hey!")
  gl_uniform_matrix4_fv(g_world_location, GL$`TRUE`, t(world))
  gl_enable_vertex_attrib_array(0L)
  gl_bind_buffer(GL$ARRAY_BUFFER, vbo)
  gl_vertex_attrib_pointer(0L, 3L, GL$DOUBLE, GL$`FALSE`, 0L, 0L)
  gl_bind_buffer(GL$ELEMENT_ARRAY_BUFFER, ibo)
  gl_draw_elements(GL$TRIANGLES, 12L, GL$UNSIGNED_INT,0L)
  gl_disable_vertex_attrib_array(0L)
  glfw_swap_buffers(window)

  return(scale)
}

create_vertex_buffer <- function()
{
  vertices <- c(
    -1, -1,  0,
    0, -1,  1,
    1,  -1, 0,
    0,  1,  0
  )

  vbo <- gl_gen_buffers(1L)
  gl_bind_buffer(GL$ARRAY_BUFFER, vbo)
  gl_buffer_data(GL$ARRAY_BUFFER, vertices, GL$STATIC_DRAW)

  return(vbo)
}

create_index_buffer <- function() {

  indices <- c(0L, 3L, 1L,
               1L, 3L, 2L,
               2L, 3L, 0L,
               0L, 1L, 2L)
  ibo <- gl_gen_buffers(1L)
  gl_bind_buffer(GL$ARRAY_BUFFER, ibo)
  gl_buffer_data(GL$ARRAY_BUFFER, indices, GL$STATIC_DRAW)

  return(ibo)
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

  g_world_location <- gl_get_uniform_location(shader_program, "gWorld")
  if (g_world_location == -1L)
    stop("Error getting uniform location of 'gWorld'")

  gl_validate_program(shader_program)
  if(!gl_get_program_iv(shader_program, GL$VALIDATE_STATUS)) {
    stop(gl_get_program_info_log(shader_program))
  }

  gl_use_program(shader_program)
  return(g_world_location)
}

glfw_init()

width <- 400L
height <- 400L
scale <- 0

window <- glfw_create_window(width, height, "Tutorial 11: concatenating transformations")
glfw_make_context_current(window)
glad_load_gl()

gl_clear_color(0, 0, 0, 0)

vbo <- create_vertex_buffer()
ibo <- create_index_buffer()

g_world_location <-
  compile_shaders(
    vs_file = system.file("tutorials/ogldev/tutorial11/shader.vs", package = "glfw"),
    fs_file = system.file("tutorials/ogldev/tutorial11/shader.fs", package = "glfw")
  )

while (!glfw_window_should_close(window))
{
  if (glfw_get_key(window, GLFW$KEY_ESCAPE) == GLFW$PRESS)
    glfw_set_window_should_close(window, 1)

  scale <- render_scene(window, vbo, ibo, g_world_location, scale)
  glfw_poll_events()
}

glfw_destroy_window(window)
glfw_terminate()
