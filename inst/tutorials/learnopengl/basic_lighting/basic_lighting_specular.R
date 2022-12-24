library(glfw)

# Path to directory containing R code to be sourced
src_path <- system.file("tutorials/learnopengl/basic_lighting/R", package = "glfw", mustWork = TRUE)

# Auxiliary R code
source(file.path(src_path, "camera.R"))
source(file.path(src_path, "callbacks.R"))
source(file.path(src_path, "cube_data.R"))
source(file.path(src_path, "vertex_array.R"))

# Global variables
src_width <- 800
src_height <- 600
camera <- camera(c(0, 0, 3))
last_x <- src_width / 2
last_y <- src_height / 2
first_mouse <- TRUE
delta_time <- 0
last_frame <- 0
light_pos <- c(1.2, 1, 2)


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

basic_lighting_vs <- system.file("tutorials/learnopengl/basic_lighting/basic_lighting.vs", package = "glfw")
basic_lighting_fs <- system.file("tutorials/learnopengl/basic_lighting/basic_lighting.fs", package = "glfw")
basic_lighting_program <- build_program(vert = basic_lighting_vs, frag = basic_lighting_fs)

light_cube_vs <- system.file("tutorials/learnopengl/basic_lighting/light_cube.vs", package = "glfw")
light_cube_fs <- system.file("tutorials/learnopengl/basic_lighting/light_cube.fs", package = "glfw")
light_cube_program <- build_program(vert = light_cube_vs, frag = light_cube_fs)

vertices <- vertices()
vb <- setup_vao(vertices)

lighting_loc <- list()
lighting_loc[['lightPos']] <- gl_get_uniform_location(basic_lighting_program, "lightPos")
lighting_loc[['viewPos']] <- gl_get_uniform_location(basic_lighting_program, "viewPos")
lighting_loc[['lightColor']] <- gl_get_uniform_location(basic_lighting_program, "lightColor")
lighting_loc[['objectColor']] <- gl_get_uniform_location(basic_lighting_program, "objectColor")
lighting_loc[['projection']] <- gl_get_uniform_location(basic_lighting_program, "projection")
lighting_loc[['view']] <- gl_get_uniform_location(basic_lighting_program, "view")
lighting_loc[['model']] <- gl_get_uniform_location(basic_lighting_program, "model")

light_cube_loc <- list()
light_cube_loc[['projection']] <- gl_get_uniform_location(light_cube_program, "projection")
light_cube_loc[['view']] <- gl_get_uniform_location(light_cube_program, "view")
light_cube_loc[['model']] <- gl_get_uniform_location(light_cube_program, "model")

while (!glfw_window_should_close(window))
{
  current_frame <- glfw_get_time()
  delta_time <- current_frame - last_frame
  last_frame <- current_frame

  camera <- process_input(window, delta_time)

  gl_clear_color(0.1, 0.1, 0.1, 1.0)
  gl_clear(bitwOr(GL$COLOR_BUFFER_BIT, GL$DEPTH_BUFFER_BIT))

  gl_use_program(basic_lighting_program)
  gl_uniform_fv(lighting_loc[['objectColor']], c(1, 0.5, 0.31))
  gl_uniform_fv(lighting_loc[['lightColor']], c(1, 1, 1))
  gl_uniform_fv(lighting_loc[['lightPos']], light_pos)
  gl_uniform_fv(lighting_loc[['viewPos']], camera$Position)

  projection <- glm_perspective(glm_rad(camera$Zoom), src_width / src_height, 0.1, 100)
  view <- get_view_matrix(camera)
  gl_uniform_matrix4_fv(lighting_loc[['projection']], GL$`FALSE`, projection)
  gl_uniform_matrix4_fv(lighting_loc[['view']], GL$`FALSE`, view)

  model <- diag(1, nrow = 4)
  gl_uniform_matrix4_fv(lighting_loc[['model']], GL$`FALSE`, model)

  gl_bind_vertex_array(vb[['cube_vao']])
  gl_draw_arrays(GL$TRIANGLES, 0L, 36L)

  gl_use_program(light_cube_program)
  gl_uniform_matrix4_fv(light_cube_loc[['projection']], GL$`FALSE`, projection)
  gl_uniform_matrix4_fv(light_cube_loc[['view']], GL$`FALSE`, view)

  model <- glm_translate(diag(1, nrow = 4), light_pos)
  model <- glm_scale(model, c(0.2, 0.2, 0.2))
  gl_uniform_matrix4_fv(light_cube_loc[['model']], GL$`FALSE`, model)

  gl_bind_vertex_array(vb['light_cube_vao'])
  gl_draw_arrays(GL$TRIANGLES, 0L, 36L)

  glfw_swap_buffers(window)
  glfw_poll_events()
}

gl_delete_vertex_arrays(vb['cube_vao'])
gl_delete_vertex_arrays(vb['light_cube_vao'])
gl_delete_buffers(vb['vbo'])
glfw_destroy_window(window)
glfw_terminate()
