library(glfw)
library(magick)

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

  sensitivity <- 0.1
  xoffset <- xoffset * sensitivity;
  yoffset <- yoffset * sensitivity;

  yaw <<- yaw + xoffset
  pitch <<- pitch + yoffset


    if (pitch > 89.0)
        pitch <<- 89.0

    if (pitch < -89.0)
        pitch <<- -89.0

  front <- c(
    x = cos(glm_rad(yaw)) * cos(glm_rad(pitch)),
    y = sin(glm_rad(pitch)),
    z = sin(glm_rad(yaw)) * cos(glm_rad(pitch))
  )

  camera_front <<- glm_normalize(front)
}

scroll_cb <- function(window, xoffset, yoffset) {
  fov <<- fov - yoffset
  if (fov < 1) fov <<- 1
  if (fov > 45) fov <<- 45
}

process_input <-
  function(window,
           camera_pos,
           camera_front,
           camera_up,
           delta_time) {
    if (glfw_get_key(window, GLFW$KEY_ESCAPE) == GLFW$PRESS)
      glfw_set_window_should_close(window, 1L)

    camera_speed <- 2.5 * delta_time

    if (glfw_get_key(window, GLFW$KEY_W) == GLFW$PRESS)
      camera_pos <- camera_pos + camera_speed * camera_front

    if (glfw_get_key(window, GLFW$KEY_S) == GLFW$PRESS)
      camera_pos <- camera_pos - camera_speed * camera_front

    if (glfw_get_key(window, GLFW$KEY_A) == GLFW$PRESS) {
      camera_pos <-
        camera_pos - glm_normalize(glm_cross(camera_front, camera_up)) * camera_speed
    }

    if (glfw_get_key(window, GLFW$KEY_D) == GLFW$PRESS) {
      camera_pos <-
        camera_pos + glm_normalize(glm_cross(camera_front, camera_up)) * camera_speed
    }

    return(camera_pos)
  }

fb_size_cb <- function(window, width, height)
  gl_viewport(0L, 0L, width = width, height = height)

# Window dimensions
src_width <- 800
src_height <- 600

camera_pos <- c(0, 0, 3)
camera_front <- c(0, 0, -1)
camera_up <- c(0, 1, 0)

first_mouse <- TRUE
yaw <- -90
pitch <- 0
last_x <- 800 / 2
last_y <- 600 / 2
fov <- 45

delta_time <- 0
last_frame <- 0

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
glfw_set_cursor_pos_callback(window, mouse_callback)
glfw_set_scroll_callback(window, scroll_cb)
glad_load_gl()

gl_enable(GL$DEPTH_TEST)

vs <- system.file("tutorials/learnopengl/camera/camera.vs", package = "glfw")
fs <- system.file("tutorials/learnopengl/camera/camera.fs", package = "glfw")
program <- build_program(vert = vs, frag = fs)

vertices <- c(
  -0.5, -0.5, -0.5,  0.0, 0.0,
  0.5, -0.5, -0.5,  1.0, 0.0,
  0.5,  0.5, -0.5,  1.0, 1.0,
  0.5,  0.5, -0.5,  1.0, 1.0,
  -0.5,  0.5, -0.5,  0.0, 1.0,
  -0.5, -0.5, -0.5,  0.0, 0.0,

  -0.5, -0.5,  0.5,  0.0, 0.0,
  0.5, -0.5,  0.5,  1.0, 0.0,
  0.5,  0.5,  0.5,  1.0, 1.0,
  0.5,  0.5,  0.5,  1.0, 1.0,
  -0.5,  0.5,  0.5,  0.0, 1.0,
  -0.5, -0.5,  0.5,  0.0, 0.0,

  -0.5,  0.5,  0.5,  1.0, 0.0,
  -0.5,  0.5, -0.5,  1.0, 1.0,
  -0.5, -0.5, -0.5,  0.0, 1.0,
  -0.5, -0.5, -0.5,  0.0, 1.0,
  -0.5, -0.5,  0.5,  0.0, 0.0,
  -0.5,  0.5,  0.5,  1.0, 0.0,

  0.5,  0.5,  0.5,  1.0, 0.0,
  0.5,  0.5, -0.5,  1.0, 1.0,
  0.5, -0.5, -0.5,  0.0, 1.0,
  0.5, -0.5, -0.5,  0.0, 1.0,
  0.5, -0.5,  0.5,  0.0, 0.0,
  0.5,  0.5,  0.5,  1.0, 0.0,

  -0.5, -0.5, -0.5,  0.0, 1.0,
  0.5, -0.5, -0.5,  1.0, 1.0,
  0.5, -0.5,  0.5,  1.0, 0.0,
  0.5, -0.5,  0.5,  1.0, 0.0,
  -0.5, -0.5,  0.5,  0.0, 0.0,
  -0.5, -0.5, -0.5,  0.0, 1.0,

  -0.5,  0.5, -0.5,  0.0, 1.0,
  0.5,  0.5, -0.5,  1.0, 1.0,
  0.5,  0.5,  0.5,  1.0, 0.0,
  0.5,  0.5,  0.5,  1.0, 0.0,
  -0.5,  0.5,  0.5,  0.0, 0.0,
  -0.5,  0.5, -0.5,  0.0, 1.0
)

cube_positions <-
  matrix(
    c(
      0,    0,   0,
      2,    5, -15,
      -1.5, -2.2, -2.5,
      -3.8, -2.0, -12.3,
      2.4, -0.4, -3.5,
      -1.7,  3.0, -7.5,
      1.3, -2.0, -2.5,
      1.5,  2.0, -2.5,
      1.5,  0.2, -1.5,
      -1.3,  1.0, -1.5
    ),
    nrow = 3L
  )
vao <- gl_gen_vertex_arrays(1L)
vbo <- gl_gen_buffers(1L)

gl_bind_vertex_array(vao)
gl_bind_buffer(GL$ARRAY_BUFFER, vbo)
gl_buffer_data(GL$ARRAY_BUFFER, vertices, GL$STATIC_DRAW)
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

projection_loc <- gl_get_uniform_location(program, "projection")
view_loc <- gl_get_uniform_location(program, "view")
model_loc <- gl_get_uniform_location(program, "model")

while (!glfw_window_should_close(window))
{
  current_frame <- glfw_get_time()
  delta_time <- current_frame - last_frame
  last_frame <- current_frame

  camera_pos <- process_input(window,
                              camera_pos,
                              camera_front,
                              camera_up,
                              delta_time)

  gl_clear_color(0.2, 0.3, 0.3, 1.0)
  gl_clear(bitwOr(GL$COLOR_BUFFER_BIT, GL$DEPTH_BUFFER_BIT))
  gl_active_texture(GL$TEXTURE0)
  gl_bind_texture(GL$TEXTURE_2D, texture1)
  gl_active_texture(GL$TEXTURE1)
  gl_bind_texture(GL$TEXTURE_2D, texture2)
  gl_use_program(program)

  projection <- glm_perspective(glm_rad(fov), src_width / src_height, 0.1, 100)
  gl_uniform_matrix4_fv(projection_loc, GL$`FALSE`, projection)

  view <- glm_lookat(camera_pos, camera_pos + camera_front, camera_up)
  gl_uniform_matrix4_fv(view_loc, GL$`FALSE`, view)

  gl_bind_vertex_array(vao)
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

gl_delete_vertex_arrays(vao)
gl_delete_buffers(vbo)
glfw_destroy_window(window)
glfw_terminate()
