#include <glfw.h>

SEXP glfw_get_time_(void) {
  return Rf_ScalarReal(glfwGetTime());
}

SEXP glfw_set_time_(SEXP time) {
  glfwSetTime((double) REAL(time)[0]);
  return R_NilValue;
}
