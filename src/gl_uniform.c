#include <glfw.h>

SEXP gl_get_uniform_location_(SEXP program, SEXP name) {

  GLint location;
  location = glGetUniformLocation(
    (GLuint) INTEGER(program)[0],
    (GLchar *)CHAR(STRING_ELT(name, 0))
    );

  return Rf_ScalarInteger(location);
}

SEXP gl_uniform_fv_(SEXP location, SEXP value) {

  GLint _location = INTEGER(location)[0];
  R_len_t _n = XLENGTH(value);
  float *_ptr = (float *) R_alloc(_n, sizeof(float));
  for (R_xlen_t i = 0; i < _n; i++) _ptr[i] = (float) REAL(value)[i];

  switch(_n) {
  case 1:
    glUniform1fv(_location, _n, _ptr);
    break;
  case 2:
    glUniform2fv(_location, _n, _ptr);
    break;
  case 3:
    glUniform3fv(_location, _n, _ptr);
    break;
  case 4:
    glUniform4fv(_location, _n, _ptr);
    break;
  default:
    Rf_error("Length of `value` must be 1, 2, 3 or 4.\n");
  break;
  }

  return R_NilValue;
}

SEXP gl_uniform_f_(SEXP location, SEXP v) {

  GLint _location = INTEGER(location)[0];
  R_len_t _n = XLENGTH(v);

  switch(_n) {
  case 1:
    glUniform1f(_location,
                (GLfloat) REAL(v)[0]
                );
    break;
  case 2:
    glUniform2f(_location,
                (GLfloat) REAL(v)[0],
                (GLfloat) REAL(v)[1]
                );
    break;
  case 3:
    glUniform3f(_location,
                (GLfloat) REAL(v)[0],
                (GLfloat) REAL(v)[1],
                (GLfloat) REAL(v)[2]
                );
    break;
  case 4:
    glUniform4f(_location,
                (GLfloat) REAL(v)[0],
                (GLfloat) REAL(v)[1],
                (GLfloat) REAL(v)[2],
                (GLfloat) REAL(v)[3]
                );
    break;
  default:
    Rf_error("Length of `v` must be 1, 2, 3 or 4.\n");
  break;
  }

  return R_NilValue;
}

SEXP gl_uniform_iv_(SEXP location, SEXP value) {

  R_len_t _n = LENGTH(value);
  GLint *_ptr = INTEGER(value);
  GLint _location = INTEGER(location)[0];

  switch(_n) {
  case 1:
    glUniform1iv(_location, _n, _ptr);
    break;
  case 2:
    glUniform2iv(_location, _n, _ptr);
    break;
  case 3:
    glUniform3iv(_location, _n, _ptr);
    break;
  case 4:
    glUniform4iv(_location, _n, _ptr);
    break;
  default:
    Rf_error("Length of `value` must be 1, 2, 3 or 4.\n");
  break;
  }

  return R_NilValue;
}

SEXP gl_uniform_uiv_(SEXP location, SEXP value) {

  GLint _location = INTEGER(location)[0];
  R_len_t _n = XLENGTH(value);
  unsigned int *_ptr = (unsigned int *) R_alloc(_n, sizeof(unsigned int));
  for (R_xlen_t i = 0; i < _n; i++) _ptr[i] = (float) INTEGER(value)[i];

  switch(_n) {
  case 1:
    glUniform1uiv(_location, _n, _ptr);
    break;
  case 2:
    glUniform2uiv(_location, _n, _ptr);
    break;
  case 3:
    glUniform3uiv(_location, _n, _ptr);
    break;
  case 4:
    glUniform4uiv(_location, _n, _ptr);
    break;
  default:
    Rf_error("Length of `value` must be 1, 2, 3 or 4.\n");
  break;
  }

  return R_NilValue;
}

SEXP gl_uniform_matrix4_fv_(SEXP location, SEXP transpose, SEXP value) {

  GLint _location = INTEGER(location)[0];
  R_len_t _n = XLENGTH(value);
  GLsizei _count = _n / 4; // number of 4x4 matrices.
  float *_ptr = (float *) R_alloc(_n, sizeof(float));
  for (R_xlen_t i = 0; i < _n; i++) _ptr[i] = (float) REAL(value)[i];

  glUniformMatrix4fv(_location, _count, (GLboolean) INTEGER(transpose)[0], _ptr);

  return R_NilValue;

}
