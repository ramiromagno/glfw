#include <glfw.h>

SEXP gl_create_shader_(SEXP shaderType) {
  return Rf_ScalarInteger(glCreateShader((GLenum) INTEGER(shaderType)[0]));
}

SEXP gl_shader_source_(SEXP shader, SEXP count, SEXP string, SEXP length) {

  const char *shader_source;
  shader_source = Rf_translateCharUTF8(STRING_ELT(string, 0));
  glShaderSource((GLuint) INTEGER(shader)[0], 1, &shader_source, NULL);
  return R_NilValue;
}

SEXP gl_compile_shader_(SEXP shader) {
  glCompileShader((GLuint) INTEGER(shader)[0]);
  return R_NilValue;
}

SEXP gl_is_shader_(SEXP shader) {
  unsigned char is_shader = glIsShader((GLuint) INTEGER(shader)[0]);
  return Rf_ScalarLogical((int) is_shader);
}

SEXP gl_delete_shader_(SEXP shader) {
  glDeleteShader((GLuint) INTEGER(shader)[0]);
  return R_NilValue;
}

SEXP gl_get_shader_iv_(SEXP shader, SEXP pname) {
  GLint params;
  glGetShaderiv((GLuint) INTEGER(shader)[0], (GLenum) INTEGER(pname)[0], &params);
  return Rf_ScalarInteger(params);
}
