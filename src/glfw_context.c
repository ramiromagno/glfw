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

// This function purposely does not register a finaliser, because contrarily
// to glfw_create_window_(), glfw_get_current_context_() is not creating a new
// window. We also do not check if `_window` is NULL, because it can be NULL
// and it is fine, it means no OpenGL context is attached.
SEXP glfw_get_current_context_(void) {
  GLFWwindow* _window;
  _window = glfwGetCurrentContext();

  SEXP class = PROTECT(Rf_mkString("glfw_window"));
  SEXP window = PROTECT(R_MakeExternalPtr(_window, R_NilValue, R_NilValue));
  Rf_classgets(window, class);

  UNPROTECT(2);
  return window;
}
