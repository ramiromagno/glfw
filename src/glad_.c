#include <glfw.h>

SEXP glad_load_gl_(void) {
  if (!gladLoadGL()) {
    Rf_error("GLAD: could not load OpenGL functions.\n");
    return R_NilValue;
  }

  return Rf_ScalarLogical(1);
}
