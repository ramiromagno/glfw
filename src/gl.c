#include <glfw.h>

SEXP gl_clear_(SEXP mask) {
  unsigned int c_mask = (unsigned int) INTEGER(mask)[0];
  glClear(c_mask);
  return R_NilValue;
}
