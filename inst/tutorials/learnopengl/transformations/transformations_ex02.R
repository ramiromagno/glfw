library(glfw)
library(magick)

process_input <- function(window) {
  if (glfw_get_key(window, GLFW$KEY_ESCAPE) == GLFW$PRESS)
    glfw_set_window_should_close(window, 1L)
}

fb_size_cb <- function(window, width, height)
  gl_viewport(0L, 0L, width = width, height = height)

# Window dimensions
src_width <- 800
src_height <- 600

# glfw: initialize and configure
glfw_init()

glfw_window_hint(GLFW$CONTEXT_VERSION_MAJOR, 3L)
glfw_window_hint(GLFW$CONTEXT_VERSION_MINOR, 3L)
glfw_window_hint(GLFW$OPENGL_PROFILE, GLFW$OPENGL_CORE_PROFILE)

if (os() == "darwin")
  glfw_window_hint(GLFW$OPENGL_FORWARD_COMPAT, GL$`TRUE`)

window <- glfw_create_window(
  width = src_width,
  height = src_height,
  "LearnOpenGL"
)

glfw_make_context_current(window = window)
glfw_set_framebuffer_size_callback(window, fb_size_cb)
glad_load_gl()

vs <- system.file("tutorials/learnopengl/transformations/transformation.vs", package = "glfw")
fs <- system.file("tutorials/learnopengl/transformations/transformation.fs", package = "glfw")
program <- build_program(vert = vs, frag = fs)

vertices <- c(
  # positions        # colors         # texture coords
  0.5,  0.5, 0.0, 1.0, 1.0, # top right
  0.5, -0.5, 0.0, 1.0, 0.0, # bottom right
  -0.5, -0.5, 0.0, 0.0, 0.0, # bottom left
  -0.5,  0.5, 0.0, 0.0, 1.0  # top left
)

indices <- c(
  0L, 1L, 3L,  # first triangle
  1L, 2L, 3L   # second triangle
)

vao <- gl_gen_vertex_arrays(1L)
vbo <- gl_gen_buffers(1L)
ebo <- gl_gen_buffers(1L)
gl_bind_vertex_array(vao)
gl_bind_buffer(GL$ARRAY_BUFFER, vbo)
gl_buffer_data(GL$ARRAY_BUFFER, vertices, GL$STATIC_DRAW)
gl_bind_buffer(GL$ELEMENT_ARRAY_BUFFER, ebo)
gl_buffer_data(GL$ELEMENT_ARRAY_BUFFER, indices, GL$STATIC_DRAW)
gl_vertex_attrib_pointer(0L, 3L, GL$DOUBLE, GL$`FALSE`, 5L, 0L)
gl_enable_vertex_attrib_array(0L)
gl_vertex_attrib_pointer(1L, 2L, GL$DOUBLE, GL$`FALSE`, 5L, 3L)
gl_enable_vertex_attrib_array(1L)

texture1 <- gl_gen_textures(1L)
gl_bind_texture(GL$TEXTURE_2D, texture1)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_WRAP_S, GL$REPEAT)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_WRAP_T, GL$REPEAT)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_MIN_FILTER, GL$LINEAR)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_MAG_FILTER, GL$LINEAR)

image_path <- system.file("tutorials/learnopengl/assets/container.jpg", package = "glfw")
img <- image_flip(image_read(image_path))
data <- image_data(img)
img_width <- dim(data)[2]
img_height <- dim(data)[3]

gl_tex_image_2d(GL$TEXTURE_2D, 0L, GL$RGB, img_width, img_height, 0L, GL$RGB, GL$UNSIGNED_BYTE, data)
gl_generate_mipmap(GL$TEXTURE_2D)

texture2 <- gl_gen_textures(1L)
gl_bind_texture(GL$TEXTURE_2D, texture2)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_WRAP_S, GL$REPEAT)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_WRAP_T, GL$REPEAT)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_MIN_FILTER, GL$LINEAR_MIPMAP_LINEAR)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_MAG_FILTER, GL$LINEAR)

image_path <- system.file("tutorials/learnopengl/assets/awesomeface.png", package = "glfw")
img <- image_flip(image_read(image_path))
data <- image_data(img)
img_width <- dim(data)[2]
img_height <- dim(data)[3]

gl_tex_image_2d(GL$TEXTURE_2D, 0L, GL$RGBA, img_width, img_height, 0L, GL$RGBA, GL$UNSIGNED_BYTE, data)
gl_generate_mipmap(GL$TEXTURE_2D)

gl_use_program(program)
gl_uniform_iv(gl_get_uniform_location(program, "texture1"), 0L)
gl_uniform_iv(gl_get_uniform_location(program, "texture2"), 1L)

while (!glfw_window_should_close(window))
{
  process_input(window)
  gl_clear_color(0.2, 0.3, 0.3, 1.0)
  gl_clear(GL$COLOR_BUFFER_BIT)
  gl_active_texture(GL$TEXTURE0)
  gl_bind_texture(GL$TEXTURE_2D, texture1)
  gl_active_texture(GL$TEXTURE1)
  gl_bind_texture(GL$TEXTURE_2D, texture2)

  transform <- glm_translate(diag(4, nrow = 4), v = c(0.5, -0.5, 0.0))
  transform <- glm_rotate(transform, glfw_get_time(), c(0, 0, 1))

  gl_use_program(program)
  transform_loc <- gl_get_uniform_location(program, "transform")
  gl_uniform_matrix4_fv(transform_loc, GL$`FALSE`, transform)
  gl_bind_vertex_array(vao)
  gl_draw_elements(GL$TRIANGLES, 6L, GL$UNSIGNED_INT, 0L)

  transform <- glm_translate(diag(4, nrow = 4), v = c(-0.5, 0.5, 0.0))
  scale_amount <- sin(glfw_get_time())
  transform <- glm_scale(transform, rep(scale_amount, 3L))
  gl_uniform_matrix4_fv(transform_loc, GL$`FALSE`, transform)
  gl_draw_elements(GL$TRIANGLES, 6L, GL$UNSIGNED_INT, 0L)

  glfw_swap_buffers(window)
  glfw_poll_events()
}

gl_delete_vertex_arrays(vao)
gl_delete_buffers(vbo)
gl_delete_buffers(ebo)
glfw_destroy_window(window)
glfw_terminate()
