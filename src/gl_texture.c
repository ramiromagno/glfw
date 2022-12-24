#include <glfw.h>

SEXP gl_gen_textures_(SEXP n) {

  GLsizei _n = INTEGER(n)[0];

  if(_n <= 0) {
    Rf_error("Error `n` must be 1 or greater.\n");
    return R_NilValue;
  }

  GLuint *textures;
  textures = (GLuint *) malloc(_n*sizeof(GLuint));
  if(!textures) {
    Rf_error("Error in memory allocation of `textures`.\n");
    return R_NilValue;
  }

  glGenTextures(_n, textures);
  // `tex_names`: vertex array names (integer values).
  SEXP tex_names = PROTECT(Rf_allocVector(INTSXP, _n));
  for (int i = 0; i < _n; i++) {
    INTEGER(tex_names)[i] = textures[i];
  }

  free(textures);
  UNPROTECT(1);
  return tex_names;
}

SEXP gl_bind_texture_(SEXP target, SEXP texture) {

  glBindTexture((GLenum) INTEGER(target)[0], (GLuint) INTEGER(texture)[0]);
  return R_NilValue;
}

SEXP gl_tex_parameter_i_(SEXP target, SEXP pname, SEXP param) {
  glTexParameteri((GLenum) INTEGER(target)[0], (GLenum) INTEGER(pname)[0], (GLint) INTEGER(param)[0]);
  return R_NilValue;
}

SEXP gl_tex_image_2d_(SEXP target,
                      SEXP level,
                      SEXP internalformat,
                      SEXP width,
                      SEXP height,
                      SEXP border,
                      SEXP format,
                      SEXP type,
                      SEXP data) {

  GLenum _target = (GLenum) INTEGER(target)[0];
  GLint _level = (GLint) INTEGER(level)[0];
  GLint _internalformat = (GLint) INTEGER(internalformat)[0];
  GLsizei _width = (GLsizei) INTEGER(width)[0];
  GLsizei _height = (GLsizei) INTEGER(height)[0];
  GLint _border = (GLint) INTEGER(border)[0];
  GLenum _format = (GLenum) INTEGER(format)[0];
  GLenum _type = (GLenum) INTEGER(type)[0];

  void * _data;
  switch (TYPEOF(data)) {
  case INTSXP:
  {
    _data = INTEGER(data);
    break;
  }
  case REALSXP:
  {
    _data = REAL(data);
    break;
  }
  case RAWSXP:
  {
    _data = RAW(data);
    break;
  }
  default:
    Rf_error("`data` must be an integer, double or raw vector.");
  }

  glTexImage2D(_target,
               _level,
               _internalformat,
               _width,
               _height,
               _border,
               _format,
               _type,
               _data);

  return R_NilValue;
}

SEXP gl_generate_mipmap_(SEXP target) {
  glGenerateMipmap((GLenum) INTEGER(target)[0]);
  return R_NilValue;
}

SEXP gl_active_texture_(SEXP texture) {
  glActiveTexture((GLenum) INTEGER(texture)[0]);
  return R_NilValue;
}

SEXP gl_tex_sub_image_2d_(SEXP target,
                      SEXP level,
                      SEXP xoffset,
                      SEXP yoffset,
                      SEXP width,
                      SEXP height,
                      SEXP format,
                      SEXP type,
                      SEXP pixels) {

  GLenum _target = (GLenum) INTEGER(target)[0];
  GLint _level = (GLint) INTEGER(level)[0];
  GLint _xoffset = (GLint) INTEGER(xoffset)[0];
  GLint _yoffset = (GLint) INTEGER(yoffset)[0];
  GLsizei _width = (GLsizei) INTEGER(width)[0];
  GLsizei _height = (GLsizei) INTEGER(height)[0];
  GLenum _format = (GLenum) INTEGER(format)[0];
  GLenum _type = (GLenum) INTEGER(type)[0];

  void * _pixels;
  switch (TYPEOF(pixels)) {
  case INTSXP:
  {
    _pixels = INTEGER(pixels);
    break;
  }
  case REALSXP:
  {
    _pixels = REAL(pixels);
    break;
  }
  case RAWSXP:
  {
    _pixels = RAW(pixels);
    break;
  }
  default:
    Rf_error("`data` must be an integer, double or raw vector.");
  }

  glTexSubImage2D(_target,
               _level,
               _xoffset,
               _yoffset,
               _width,
               _height,
               _format,
               _type,
               _pixels);

  return R_NilValue;
}
