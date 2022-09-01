#include <glfw.h>

SEXP gl_gen_vertex_arrays_(SEXP n) {

  GLsizei _n = INTEGER(n)[0];

  if(_n <= 0) {
    Rf_error("Error `n` must be 1 or greater.\n");
    return R_NilValue;
  }

  GLuint *arrays;
  arrays = (GLuint *) malloc(_n*sizeof(GLuint));
  if(!arrays) {
    Rf_error("Error in memory allocation of `arrays`.\n");
    return R_NilValue;
  }

  glGenVertexArrays(_n, arrays);
  // `va_names`: vertex array names (integer values).
  SEXP va_names = PROTECT(Rf_allocVector(INTSXP, _n));
  for (int i = 0; i < _n; i++) {
    INTEGER(va_names)[i] = arrays[i];
  }

  free(arrays);
  UNPROTECT(1);
  return va_names;
}

SEXP gl_gen_buffers_(SEXP n) {

  GLsizei _n = INTEGER(n)[0];

  if(_n <= 0) {
    Rf_error("Error `n` must be 1 or greater.\n");
    return R_NilValue;
  }

  GLuint *buffers;
  buffers = (GLuint *) malloc(_n*sizeof(GLuint));
  if(!buffers) {
    Rf_error("Error in memory allocation of `buffers`.\n");
    return R_NilValue;
  }

  glGenBuffers(_n, buffers);
  // `buf_names`: buffer names (integer values).
  SEXP buf_names = PROTECT(Rf_allocVector(INTSXP, _n));
  for (int i = 0; i < _n; i++) {
    INTEGER(buf_names)[i] = buffers[i];
  }

  free(buffers);
  UNPROTECT(1);
  return buf_names;
}

SEXP gl_bind_vertex_array_(SEXP array) {

  glBindVertexArray((GLuint) INTEGER(array)[0]);
  return R_NilValue;
}

SEXP gl_bind_buffer_(SEXP target, SEXP buffer) {

  glBindBuffer((GLenum) INTEGER(target)[0], (GLuint) INTEGER(buffer)[0]);
  return R_NilValue;
}

SEXP gl_buffer_data_(SEXP target, SEXP data, SEXP usage) {

  R_xlen_t n = XLENGTH(data);
  if (n == 0) Rf_error("`data` is empty (length is zero).");

  switch (TYPEOF(data)) {
  case INTSXP:
  {
    int *_data = INTEGER(data);
    GLsizeiptr size = (GLsizeiptr) n*sizeof(int);
    glBufferData((GLenum) INTEGER(target)[0], size, _data, (GLenum) INTEGER(usage)[0]);
    break;
  }
  case REALSXP:
  {
    double *_data = REAL(data);
    GLsizeiptr size = (GLsizeiptr) n*sizeof(double);
    glBufferData((GLenum) INTEGER(target)[0], size, _data, (GLenum) INTEGER(usage)[0]);
    break;
  }
  default:
    Rf_error("`data` must be an integer or double vector.");
  }

  return R_NilValue;
}

SEXP gl_vertex_attrib_pointer_(SEXP index,
                               SEXP size,
                               SEXP type,
                               SEXP normalized,
                               SEXP stride,
                               SEXP offset) {

  GLuint _index = (GLuint) INTEGER(index)[0];
  GLint _size = (GLint) INTEGER(size)[0];
  GLenum _type = (GLenum) INTEGER(type)[0];
  GLboolean _normalized = (GLboolean) INTEGER(normalized)[0];
  GLsizei _stride = (GLsizei) INTEGER(stride)[0];
  int _offset = INTEGER(offset)[0];

  GLsizei __stride = 0;
  void * pointer = NULL;

  switch (_type) {
  case GL_INT:
  {
    __stride = _stride*sizeof(int);
    pointer = (void *) (_offset*sizeof(int));
    break;
  }
  case GL_DOUBLE:
  {
    __stride = _stride*sizeof(double);
    pointer = (void *) (_offset*sizeof(double));
    break;
  }
  default:
    Rf_error("`type` must be either GL$INT or GL$DOUBLE.\n");
  }

  glVertexAttribPointer(_index, _size, _type, _normalized, __stride, pointer);

  return R_NilValue;
}

SEXP gl_enable_vertex_attrib_array_(SEXP index) {
  glEnableVertexAttribArray((GLuint) INTEGER(index)[0]);
  return R_NilValue;
}

SEXP gl_delete_buffers_(SEXP buffers) {

  R_xlen_t n = XLENGTH(buffers);
  if (n == 0) Rf_error("`buffers` is empty (length is zero).");

  glDeleteBuffers(n, (GLuint *) INTEGER(buffers));
  return R_NilValue;
}

SEXP gl_delete_vertex_arrays_(SEXP arrays) {
  R_xlen_t n = XLENGTH(arrays);
  if (n == 0) Rf_error("`arrays` is empty (length is zero).");

  glDeleteBuffers(n, (GLuint *) INTEGER(arrays));
  return R_NilValue;
}
