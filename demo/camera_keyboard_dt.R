# demo: camera_keyboard_dt.R
# author: Ramiro Magno
# Adapted from: TODO
# WARNING: THIS IS NOT WORKING

library(glfw)
library(magick)

# Vertex shader source code
vtx_shader_src <-
"#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec2 aTexCoord;

out vec2 TexCoord;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
	gl_Position = projection * view * model * vec4(aPos, 1.0f);
	TexCoord = vec2(aTexCoord.x, aTexCoord.y);
}"

# Fragment shader source code
fgr_shader_src <-
"#version 330 core
out vec4 FragColor;

in vec2 TexCoord;

// texture samplers
uniform sampler2D texture1;
uniform sampler2D texture2;

void main()
{
	FragColor = mix(texture(texture1, TexCoord), texture(texture2, TexCoord), 0.2);
}"

width <- 800L
height <- 600L

camera_pos <- glm_vec3(0, 0, 3)
camera_front <- glm_vec3(0, 0, -1)
camera_up <- glm_vec3(0, 1, 0)

delta_time <- 0
last_frame <- 0

# Initialize GLFW
glfw_init()

glfw_set_error_callback()

# Configure
glfw_window_hint(GLFW$CONTEXT_VERSION_MAJOR, 3L)
glfw_window_hint(GLFW$CONTEXT_VERSION_MINOR, 3L)
glfw_window_hint(GLFW$OPENGL_PROFILE, GLFW$OPENGL_CORE_PROFILE)
glfw_window_hint_string(GLFW$X11_CLASS_NAME, "R glfw")
glfw_window_hint_string(GLFW$X11_INSTANCE_NAME, "r glfw")

# Create window and associated OpenGL context
window = glfw_create_window(width, height, "Camera navigation with keyboard")

# Make the window's context current
glfw_make_context_current(window)

# Load OpenGL functions with GLAD
glad_load_gl()

# Framebuffer size callback
framebuffer_size_callback <- function(window, width, height)
{
  # make sure the viewport matches the new window dimensions; note that width and
  # height will be significantly larger than specified on retina displays.
  gl_viewport(0L, 0L, width, height)
}
glfw_set_framebuffer_size_callback(window, framebuffer_size_callback)

gl_enable(GL$DEPTH_TEST)

# Build vertex shader
vtx_shader <- gl_create_shader(GL$VERTEX_SHADER)
gl_shader_source(vtx_shader, 1L, vtx_shader_src)
gl_compile_shader(vtx_shader)

# Check the vertex shader compilation status
if (!gl_get_shader_iv(vtx_shader, GL$COMPILE_STATUS)) {
  stop(gl_get_shader_info_log(vtx_shader))
}

# Build fragment shader
fgr_shader <- gl_create_shader(GL$FRAGMENT_SHADER)
gl_shader_source(fgr_shader, 1L, fgr_shader_src)
gl_compile_shader(fgr_shader)

# Check the fragment shader compilation status
if (!gl_get_shader_iv(fgr_shader, GL$COMPILE_STATUS)) {
  stop(gl_get_shader_info_log(fgr_shader))
}

# Link shaders
shader_program <- gl_create_program()
gl_attach_shader(shader_program, vtx_shader)
gl_attach_shader(shader_program, fgr_shader)
gl_link_program(shader_program)

# Check for linking errors
if(!gl_get_program_iv(shader_program, GL$LINK_STATUS)) {
  stop(gl_get_program_info_log(shader_program))
}

gl_delete_shader(vtx_shader)
gl_delete_shader(fgr_shader)

# vertex data
vertices <-
  c(
    -0.5, -0.5, -0.5,  0.0,  0.0,
     0.5, -0.5, -0.5,  1.0,  0.0,
     0.5,  0.5, -0.5,  1.0,  1.0,
     0.5,  0.5, -0.5,  1.0,  1.0,
    -0.5,  0.5, -0.5,  0.0,  1.0,
    -0.5, -0.5, -0.5,  0.0,  0.0,

    -0.5, -0.5,  0.5,  0.0,  0.0,
     0.5, -0.5,  0.5,  1.0,  0.0,
     0.5,  0.5,  0.5,  1.0,  1.0,
     0.5,  0.5,  0.5,  1.0,  1.0,
    -0.5,  0.5,  0.5,  0.0,  1.0,
    -0.5, -0.5,  0.5,  0.0,  0.0,

    -0.5,  0.5,  0.5,  1.0,  0.0,
    -0.5,  0.5, -0.5,  1.0,  1.0,
    -0.5, -0.5, -0.5,  0.0,  1.0,
    -0.5, -0.5, -0.5,  0.0,  1.0,
    -0.5, -0.5,  0.5,  0.0,  0.0,
    -0.5,  0.5,  0.5,  1.0,  0.0,

    0.5,  0.5,  0.5,  1.0,  0.0,
    0.5,  0.5, -0.5,  1.0,  1.0,
    0.5, -0.5, -0.5,  0.0,  1.0,
    0.5, -0.5, -0.5,  0.0,  1.0,
    0.5, -0.5,  0.5,  0.0,  0.0,
    0.5,  0.5,  0.5,  1.0,  0.0,

    -0.5, -0.5, -0.5,  0.0,  1.0,
     0.5, -0.5, -0.5,  1.0,  1.0,
     0.5, -0.5,  0.5,  1.0,  0.0,
     0.5, -0.5,  0.5,  1.0,  0.0,
    -0.5, -0.5,  0.5,  0.0,  0.0,
    -0.5, -0.5, -0.5,  0.0,  1.0,

    -0.5,  0.5, -0.5,  0.0,  1.0,
     0.5,  0.5, -0.5,  1.0,  1.0,
     0.5,  0.5,  0.5,  1.0,  0.0,
     0.5,  0.5,  0.5,  1.0,  0.0,
    -0.5,  0.5,  0.5,  0.0,  0.0,
    -0.5,  0.5, -0.5,  0.0,  1.0
  )

# World space positions of our cubes
cube_positions <-
  matrix(
    c(
       0.0,  0.0,  0.0,
       2.0,  5.0, -15.0,
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

# position attribute
gl_vertex_attrib_pointer(0L, 3L, GL$DOUBLE, GL$`FALSE`, 5L, 0L)
gl_enable_vertex_attrib_array(0L)

# texture coord attribute
gl_vertex_attrib_pointer(1L, 2L, GL$DOUBLE, GL$`FALSE`, 5L, 3L)
gl_enable_vertex_attrib_array(1L)

#
# Create texture1
#
texture1 <- gl_gen_textures(1L)

# All upcoming GL_TEXTURE_2D operations now have effect on this texture object
gl_bind_texture(GL$TEXTURE_2D, texture1)

# Set texture filtering parameters
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_WRAP_S, GL$REPEAT)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_WRAP_T, GL$REPEAT)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_MIN_FILTER, GL$LINEAR)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_MAG_FILTER, GL$LINEAR)

image_path <- system.file("assets/cell.png", package = "glfw", mustWork = TRUE)
img <- image_flip(image_read(image_path))
data <- image_data(img)
img_width <- dim(data)[2]
img_height <- dim(data)[3]

gl_tex_image_2d(GL$TEXTURE_2D, 0L, GL$RGB, img_width, img_height, 0L, GL$RGB, GL$UNSIGNED_BYTE, data)
gl_generate_mipmap(GL$TEXTURE_2D)

#
# Create texture2
#
texture2 <- gl_gen_textures(1L)

# All upcoming GL_TEXTURE_2D operations now have effect on this texture object
gl_bind_texture(GL$TEXTURE_2D, texture2)

# Set texture filtering parameters
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_WRAP_S, GL$REPEAT)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_WRAP_T, GL$REPEAT)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_MIN_FILTER, GL$LINEAR)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_MAG_FILTER, GL$LINEAR)

image_path <- system.file("assets/solvitur_ambulando.png", package = "glfw", mustWork = TRUE)
img <- image_flip(image_read(image_path))
data <- image_data(img)
img_width <- dim(data)[2]
img_height <- dim(data)[3]

gl_tex_image_2d(GL$TEXTURE_2D, 0L, GL$RGB, img_width, img_height, 0L, GL$RGBA, GL$UNSIGNED_BYTE, data)
gl_generate_mipmap(GL$TEXTURE_2D)

gl_use_program(shader_program)
gl_uniform_iv(gl_get_uniform_location(shader_program, "texture1"), value = 0L)
gl_uniform_iv(gl_get_uniform_location(shader_program, "texture2"), value = 1L)

projection <- glm_perspective(
  fovy = glm_radians(45),
  aspect = width / height,
  z_near = 0.1,
  z_far = 100.0
)

gl_uniform_matrix4_fv(gl_get_uniform_location(shader_program, "projection"), GL$`FALSE`, projection)

# Loop until the user closes the window
while (!glfw_window_should_close(window))
{
  # per frame time logic
  current_frame <- glfw_get_time()
  delta_time <- current_frame - last_frame
  last_frame <- current_frame

  # If the Escape key is pressed then signal to close the window.
  if (glfw_get_key(window, GLFW$KEY_ESCAPE) == GLFW$PRESS)
    glfw_set_window_should_close(window, GLFW$`TRUE`)

  camera_speed <- 2.5 * delta_time
  if (glfw_get_key(window, GLFW$KEY_W) == GLFW$PRESS)
    camera_pos <- camera_pos + camera_speed * camera_front

  if (glfw_get_key(window, GLFW$KEY_S) == GLFW$PRESS)
    camera_pos <- camera_pos - (camera_speed * camera_front)

  if (glfw_get_key(window, GLFW$KEY_A) == GLFW$PRESS)
    camera_pos <- camera_pos - (glm_normalize(glm_cross(camera_front, camera_up))) * camera_speed

  if (glfw_get_key(window, GLFW$KEY_D) == GLFW$PRESS)
    camera_pos <- camera_pos + (glm_normalize(glm_cross(camera_front, camera_up))) * camera_speed


  gl_clear_color(0.2, 0.3, 0.3, 1.0)
  gl_clear(bitwOr(GL$COLOR_BUFFER_BIT, GL$DEPTH_BUFFER_BIT))

  gl_active_texture(GL$TEXTURE0)
  gl_bind_texture(GL$TEXTURE_2D, texture1)
  gl_active_texture(GL$TEXTURE1)
  gl_bind_texture(GL$TEXTURE_2D, texture2)

  gl_use_program(shader_program)

  view <- glm_lookat(camera_pos, camera_pos + camera_front, camera_up)
  gl_uniform_matrix4_fv(gl_get_uniform_location(shader_program, "view"), GL$`FALSE`, view)

  # Seeing as we only have a single VAO there's no need to bind it every time,
  # but we'll do so to keep things a bit more organized.
  gl_bind_vertex_array(vao)
  for (i in 1:10) {
    model <- diag(4)
    model <- glm_translate(model, cube_positions[, i])
    angle <- 20
    model <- glm_rotate(model, glm_radians(angle), c(1, 0.3, 0.5))
    gl_uniform_matrix4_fv(gl_get_uniform_location(shader_program, "model"), GL$`FALSE`, model)
    gl_draw_arrays(GL$TRIANGLES, 0L, 36L)
  }

  # Swap front and back buffers
  glfw_swap_buffers(window)

  # Poll for and process events
  glfw_poll_events()
}

gl_delete_vertex_arrays(vao)
gl_delete_buffers(vbo)
gl_delete_program(shader_program)

# Close the window
glfw_destroy_window(window)

# Terminate GLFW
glfw_terminate()
