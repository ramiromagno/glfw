#include <glfw.h>

SEXP glfw_get_key_(SEXP window, SEXP key)
{
  CHECK_GLFW_WINDOW(window);

  // Last state reported for the specified key to the specified window. The
  // returned state is one of GLFW_PRESS or GLFW_RELEASE.
  int state = glfwGetKey((GLFWwindow *) R_ExternalPtrAddr(window), INTEGER(key)[0]);

  return Rf_ScalarInteger(state);
}

SEXP glfw_get_time_(void) {
  return Rf_ScalarReal(glfwGetTime());
}

SEXP glfw_set_time_(SEXP time) {
  glfwSetTime((double) REAL(time)[0]);
  return R_NilValue;
}
