# demo: texture.R
# author: Ramiro Magno
# Adapted from: https://learnopengl.com/code_viewer_gh.php?code=src/1.getting_started/4.1.textures/textures.cpp

library(glfw)
library(magick)

# Load image using `{magick}`
# The texture will be flipped upside-down if you do not use `image_flip()`.
# This happens because OpenGL expects the 0.0 coordinate on the y-axis to be on
# the bottom side of the image, but images usually have 0.0 at the top of the
# y-axis.
image_path <- system.file("assets/cell.png", package = "glfw", mustWork = TRUE)
img <- image_flip(image_read(image_path))
data <- image_data(img)
img_width <- dim(data)[2]
img_height <- dim(data)[3]

width <- img_width
height <- img_height

# Vertex shader source code
vtx_shader_src <-
"#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aColor;
layout (location = 2) in vec2 aTexCoord;

out vec3 ourColor;
out vec2 TexCoord;

void main()
{
	gl_Position = vec4(aPos, 1.0);
	ourColor = aColor;
	TexCoord = vec2(aTexCoord.x, aTexCoord.y);
}"

# Fragment shader source code
fgr_shader_src <-
"#version 330 core
out vec4 FragColor;

in vec3 ourColor;
in vec2 TexCoord;

// texture sampler
uniform sampler2D texture1;

void main()
{
	FragColor = texture(texture1, TexCoord);
}"

# Initialize GLFW
glfw_init()

# Configure
glfw_window_hint(GLFW$CONTEXT_VERSION_MAJOR, 3L)
glfw_window_hint(GLFW$CONTEXT_VERSION_MINOR, 3L)
glfw_window_hint(GLFW$OPENGL_PROFILE, GLFW$OPENGL_CORE_PROFILE)

# Create window and associated OpenGL context
window = glfw_create_window(width, height, "Textures")

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

# Set up vertex data (and buffer(s)) and configure vertex attributes.
# `vertices` contains the four vertices of the rectangle that we are about
# to draw.
vertices <- c(
   # positions       # colors         # texture coords
  -1.0, -1.0, 0.0,   0.0, 0.0, 1.0,   0.0, 0.0, # bottom left
   1.0, -1.0, 0.0,   0.0, 1.0, 0.0,   1.0, 0.0, # bottom right
   1.0,  1.0, 0.0,   1.0, 0.0, 0.0,   1.0, 1.0, # top right
  -1.0,  1.0, 0.0,   1.0, 1.0, 0.0,   0.0, 1.0  # top left
)

indices <- c(
  0L, 1L, 3L,  # first triangle
  1L, 2L, 3L   # second triangle
)

# `vao`: vertex array object
vao <- gl_gen_vertex_arrays(1L)

# `vbo`: vertex buffer object
vbo <- gl_gen_buffers(1L)

# `ebo`: element buffer object
ebo <- gl_gen_buffers(1L)

gl_bind_vertex_array(vao)

gl_bind_buffer(GL$ARRAY_BUFFER, vbo)
gl_buffer_data(GL$ARRAY_BUFFER, vertices, GL$STATIC_DRAW)

gl_bind_buffer(GL$ELEMENT_ARRAY_BUFFER, ebo)
gl_buffer_data(GL$ELEMENT_ARRAY_BUFFER, indices, GL$STATIC_DRAW)

gl_vertex_attrib_pointer(0L, 3L, GL$DOUBLE, GL$`FALSE`, 8L, 0L)
gl_enable_vertex_attrib_array(0L)

gl_vertex_attrib_pointer(1L, 3L, GL$DOUBLE, GL$`FALSE`, 8L, 3L)
gl_enable_vertex_attrib_array(1L)

gl_vertex_attrib_pointer(2L, 2L, GL$DOUBLE, GL$`FALSE`, 8L, 6L)
gl_enable_vertex_attrib_array(2L)

# Create a texture
texture <- gl_gen_textures(1L)

# All upcoming GL_TEXTURE_2D operations now have effect on this texture object
gl_bind_texture(GL$TEXTURE_2D, texture)

# Set texture filtering parameters
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_MIN_FILTER, GL$NEAREST)
gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_MAG_FILTER, GL$NEAREST)

gl_tex_image_2d(GL$TEXTURE_2D, 0L, GL$RGB, img_width, img_height, 0L, GL$RGB, GL$UNSIGNED_BYTE, data)
gl_generate_mipmap(GL$TEXTURE_2D)

# Set the background color
gl_clear_color(0.2, 0.3, 0.3, 1.0)

# Loop until the user closes the window
while (!glfw_window_should_close(window))
{
  # If the Escape key is pressed then signal to close the window.
  if (glfw_get_key(window, GLFW$KEY_ESCAPE) == GLFW$PRESS)
    glfw_set_window_should_close(window, 1)

  # Clear the screen using the color set by `gl_clear_color()`
  gl_clear(GL$COLOR_BUFFER_BIT)

  # bind Texture
  gl_bind_texture(GL$TEXTURE_2D, texture)

  gl_use_program(shader_program)

  # Seeing as we only have a single VAO there's no need to bind it every time,
  # but we'll do so to keep things a bit more organized.
  gl_bind_vertex_array(vao)
  gl_draw_elements(GL$TRIANGLES, 6L, GL$UNSIGNED_INT, 0L)

  # Swap front and back buffers
  glfw_swap_buffers(window)

  # Poll for and process events
  glfw_poll_events()
}

# De-allocate all resources once they've outlived their purpose
# `glfw_terminate()` would wrap up anyway...
gl_delete_vertex_arrays(vao)
gl_delete_buffers(vbo)
gl_delete_buffers(ebo)
gl_delete_program(shader_program)

# Close the window
glfw_destroy_window(window)

# Terminate GLFW
glfw_terminate()
