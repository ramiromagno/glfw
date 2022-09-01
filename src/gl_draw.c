#include <glfw.h>

SEXP gl_draw_arrays_(SEXP mode, SEXP first, SEXP count) {

  glDrawArrays((GLenum) INTEGER(mode)[0], (GLint) INTEGER(first)[0], (GLsizei) INTEGER(count)[0]);
  return R_NilValue;
}

// TODO: Currently `indices` is ignored, i.e. it's set to zero internally.
SEXP gl_draw_elements_(SEXP mode, SEXP count, SEXP type, SEXP indices) {

  GLenum _mode = (GLenum) INTEGER(mode)[0];
  GLsizei _count = (GLsizei) INTEGER(count)[0];
  GLenum _type = (GLenum) INTEGER(type)[0];
  const void * _indices = 0;

  glDrawElements(_mode, _count, _type, _indices);

  return R_NilValue;
}
