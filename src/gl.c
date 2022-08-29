#include <glfw.h>

SEXP gl_clear_(SEXP mask) {
  unsigned int c_mask = (unsigned int) INTEGER(mask)[0];
  glClear(c_mask);
  return R_NilValue;
}

SEXP gl_clear_color_(SEXP red, SEXP green, SEXP blue, SEXP alpha) {

  // GLclampf is float
  glClearColor(
    (GLclampf) REAL(red)[0],
    (GLclampf) REAL(green)[0],
    (GLclampf) REAL(blue)[0],
    (GLclampf) REAL(alpha)[0]
  );

  return R_NilValue;
}
