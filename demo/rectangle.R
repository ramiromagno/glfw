# demo: rectangle.R
# author: Ramiro Magno
# Adapted from: https://learnopengl.com/code_viewer_gh.php?code=src/1.getting_started/2.2.hello_triangle_indexed/hello_triangle_indexed.cpp

library(glfw)

width <- 800L
height <- 600L

# Vertex shader source code
vtx_shader_src <-
"#version 330 core
layout (location = 0) in vec3 aPos;
void main()
{
  gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}"

# Fragment shader source code
fgr_shader_src <-
"#version 330 core
out vec4 FragColor;
void main()
{
  FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}"

# Initialize GLFW
glfw_init()

# Configure
glfw_window_hint(GLFW$CONTEXT_VERSION_MAJOR, 3L)
glfw_window_hint(GLFW$CONTEXT_VERSION_MINOR, 3L)
glfw_window_hint(GLFW$OPENGL_PROFILE, GLFW$OPENGL_CORE_PROFILE)

# Create window and associated OpenGL context
window = glfw_create_window(width, height, "Two triangles turned into one rectangle")

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
vertices <- c( 0.5,  0.5, 0.0, # top right
               0.5, -0.5, 0.0, # bottom right
              -0.5, -0.5, 0.0, # bottom left
              -0.5,  0.5, 0.0  # top left
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

gl_vertex_attrib_pointer(0L, 3L, GL$DOUBLE, GL$`FALSE`, 3L, 0L)
gl_enable_vertex_attrib_array(0L)
gl_bind_vertex_array(0L)

# Set the background color
gl_clear_color(0.2, 0.3, 0.3, 1.0)

# Set initial mode
mode <- GL$FILL

# Loop until the user closes the window
while (!glfw_window_should_close(window))
{
  # If the Escape key is pressed then signal to close the window.
  if (glfw_get_key(window, GLFW$KEY_ESCAPE) == GLFW$PRESS)
    glfw_set_window_should_close(window, 1)

  # Use 'w' key to alternate between wire-framed and filled rectangle.
  if (glfw_get_key(window, GLFW$KEY_W) == GLFW$PRESS) {
    mode <- ifelse(mode == GL$FILL, GL$LINE, GL$FILL)
    gl_polygon_mode(GL$FRONT_AND_BACK, mode)
  }

  # Clear the screen using the color set by `gl_clear_color()`
  gl_clear(GL$COLOR_BUFFER_BIT)

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

# optional: de-allocate all resources once they've outlived their purpose
# TODO

# Close the window
glfw_destroy_window(window)

# Terminate GLFW
glfw_terminate()
