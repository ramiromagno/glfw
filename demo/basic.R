library(glfw)

# Initialize GLFW
if (!glfw_init()) stop("Could not initialize GLFW")

# Create a windowed mode window and its OpenGL context
window = glfw_create_window(640L, 480L, "Hello World")

# Make the window's context current
glfw_make_context_current(window)

# Load OpenGL functions with GLAD
glad_load_gl()

# Loop until the user closes the window
while (!glfw_window_should_close(window))
{
  # Render here
  gl_clear(gl$color_buffer_bit)

  # Swap front and back buffers
  glfw_swap_buffers(window)

  # Poll for and process events
  glfw_poll_events()
}

# Close the window
glfw_destroy_window(window)

# Terminate GLFW
glfw_terminate()


