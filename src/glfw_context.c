#include <glfw.h>

SEXP glfw_make_context_current_(SEXP window) {
  CHECK_GLFW_WINDOW(window);
  glfwMakeContextCurrent((GLFWwindow *) R_ExternalPtrAddr(window));
  return R_NilValue;
}

SEXP glfw_swap_buffers_(SEXP window) {
  CHECK_GLFW_WINDOW(window);
  glfwSwapBuffers((GLFWwindow *) R_ExternalPtrAddr(window));
  return R_NilValue;
}
