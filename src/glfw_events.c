#include <glfw.h>

SEXP glfw_poll_events_(void) {
  glfwPollEvents();
  return R_NilValue;
}
