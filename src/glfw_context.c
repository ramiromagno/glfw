#include <glfw.h>

SEXP glfw_make_context_current_(SEXP window) {

  GLFWwindow *ptr = R_ExternalPtrAddr(window);
  if (ptr == NULL) {
    const char msg[] = "Window pointer is nil!\n";
    Rf_error(msg);
    return R_NilValue;
  } else {
    glfwMakeContextCurrent((GLFWwindow *) R_ExternalPtrAddr(window));
    return window;
  }
}
