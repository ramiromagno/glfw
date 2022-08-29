#include <glfw.h>

SEXP glfw_get_key_(SEXP window, SEXP key)
{
  if (R_ExternalPtrAddr(window) == NULL) {
    const char msg[] = "Window pointer is nil!\n";
    Rf_error(msg);
    return(R_NilValue);
  }

  // Last state reported for the specified key to the specified window. The
  // returned state is one of GLFW_PRESS or GLFW_RELEASE.
  int state = glfwGetKey((GLFWwindow *) R_ExternalPtrAddr(window), INTEGER(key)[0]);

  return Rf_ScalarInteger(state);
}
