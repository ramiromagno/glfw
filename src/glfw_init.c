/*
 * Initialization, version and error reference.
 */

#include <glfw.h>

SEXP glfw_init_(void) {

  if (!glfwInit()) {
    Rf_error("Failed to initialize GLFW!\n");
    return R_NilValue;
  }

  return Rf_ScalarLogical(1);
}

SEXP glfw_terminate_(void) {
  glfwTerminate();
  return(Rf_ScalarLogical(1));
}
