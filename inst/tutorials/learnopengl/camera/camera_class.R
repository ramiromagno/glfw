library(glfw)
library(magick)

# Path to directory containing R code to be sourced
src_path <- system.file("tutorials/learnopengl/camera/camera_class", package = "glfw", mustWork = TRUE)

# Auxiliary R code
source(file.path(src_path, "camera.R"))
source(file.path(src_path, "callbacks.R"))
source(file.path(src_path, "cube_data.R"))
source(file.path(src_path, "vertex_array.R"))
source(file.path(src_path, "textures.R"))

# Global variables
src_width <- 800
src_height <- 600
camera <- camera(c(0, 0, 3))
last_x <- src_width / 2
last_y <- src_height / 2
first_mouse <- TRUE
delta_time <- 0
last_frame <- 0

glfw_init()
glfw_window_hint(GLFW$CONTEXT_VERSION_MAJOR, 3L)
glfw_window_hint(GLFW$CONTEXT_VERSION_MINOR, 3L)
glfw_window_hint(GLFW$OPENGL_PROFILE, GLFW$OPENGL_CORE_PROFILE)
if (os() == "darwin") glfw_window_hint(GLFW$OPENGL_FORWARD_COMPAT, GL$`TRUE`)

window <- glfw_create_window(
  width = src_width,
  height = src_height,
  "LearnOpenGL"
)

glfw_make_context_current(window = window)
glfw_set_framebuffer_size_callback(window, fb_size_cb)
glfw_set_cursor_pos_callback(window, mouse_callback)
glfw_set_scroll_callback(window, scroll_cb)
glfw_set_input_mode(window, GLFW$CURSOR, GLFW$CURSOR_DISABLED)
glad_load_gl()

gl_enable(GL$DEPTH_TEST)

vs <- system.file("tutorials/learnopengl/camera/camera.vs", package = "glfw")
fs <- system.file("tutorials/learnopengl/camera/camera.fs", package = "glfw")
program <- build_program(vert = vs, frag = fs)

vertices <- vertices()
cube_positions <- cube_positions()

vb <- setup_vao(vertices)
tex <- setup_textures()

gl_use_program(program)
gl_uniform_iv(gl_get_uniform_location(program, "texture1"), 0L)
gl_uniform_iv(gl_get_uniform_location(program, "texture2"), 1L)

projection_loc <- gl_get_uniform_location(program, "projection")
view_loc <- gl_get_uniform_location(program, "view")
model_loc <- gl_get_uniform_location(program, "model")

while (!glfw_window_should_close(window))
{
  current_frame <- glfw_get_time()
  delta_time <- current_frame - last_frame
  last_frame <- current_frame

  camera <- process_input(window, delta_time)

  gl_clear_color(0.2, 0.3, 0.3, 1.0)
  gl_clear(bitwOr(GL$COLOR_BUFFER_BIT, GL$DEPTH_BUFFER_BIT))
  gl_active_texture(GL$TEXTURE0)
  gl_bind_texture(GL$TEXTURE_2D, tex['texture1'])
  gl_active_texture(GL$TEXTURE1)
  gl_bind_texture(GL$TEXTURE_2D, tex['texture2'])
  gl_use_program(program)

  projection <- glm_perspective(glm_rad(camera$Zoom), src_width / src_height, 0.1, 100)
  gl_uniform_matrix4_fv(projection_loc, GL$`FALSE`, projection)

  view <- get_view_matrix(camera)
  gl_uniform_matrix4_fv(view_loc, GL$`FALSE`, view)

  gl_bind_vertex_array(vb['vao'])
  for (i in 1:10)
  {
    model <- glm_translate(diag(1, nrow = 4), cube_positions[, i])
    angle <- 20 * i
    model <- glm_rotate(model, glm_rad(angle), c(1, 0.3, 0.5))
    gl_uniform_matrix4_fv(model_loc, GL$`FALSE`, model)
    gl_draw_arrays(GL$TRIANGLES, 0L, 36L)
  }

  glfw_swap_buffers(window)
  glfw_poll_events()
}

gl_delete_vertex_arrays(vb['vao'])
gl_delete_buffers(vb['vbo'])
glfw_destroy_window(window)
glfw_terminate()
