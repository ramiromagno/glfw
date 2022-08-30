library(glfw)

# Initialize GLFW
glfw_init()

# Create a windowed mode window and its OpenGL context
window = glfw_create_window(640L, 480L, "Press Escape to close the window")

# Make the window's context current
glfw_make_context_current(window)

# Load OpenGL functions with GLAD
glad_load_gl()

# Loop until the user closes the window
while (!glfw_window_should_close(window))
{
  # If the Escape key is pressed then signal to close the window.
  if (glfw_get_key(window, GLFW$KEY_ESCAPE) == GLFW$PRESS)
    glfw_set_window_should_close(window, 1)

  # Poll for and process events (you need this for the pressed key to be
  # processed)
  glfw_poll_events()
}

# Close the window
glfw_destroy_window(window)

# Terminate GLFW
glfw_terminate()
