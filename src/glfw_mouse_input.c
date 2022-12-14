#include <glfw.h>

static SEXP r_cursor_pos_callback;
static SEXP r_scroll_callback;

static void cursor_pos_cb(GLFWwindow* _window, double _xpos, double _ypos)
{
  SEXP window = PROTECT(R_MakeExternalPtr(_window, R_NilValue, R_NilValue));
  SEXP xpos = PROTECT(Rf_ScalarReal(_xpos));
  SEXP ypos = PROTECT(Rf_ScalarReal(_ypos));

  SEXP call = PROTECT(Rf_lang4(r_cursor_pos_callback, window, xpos, ypos));
  Rf_eval(call, R_EmptyEnv);

  UNPROTECT(4);
  return;
}

static void scroll_cb(GLFWwindow* _window, double _xoffset, double _yoffset) {

  SEXP window = PROTECT(R_MakeExternalPtr(_window, R_NilValue, R_NilValue));
  SEXP xoffset = PROTECT(Rf_ScalarReal(_xoffset));
  SEXP yoffset = PROTECT(Rf_ScalarReal(_yoffset));

  SEXP call = PROTECT(Rf_lang4(r_scroll_callback, window, xoffset, yoffset));
  Rf_eval(call, R_EmptyEnv);

  UNPROTECT(4);
  return;
}

SEXP glfw_set_cursor_pos_callback_(SEXP window, SEXP cb) {

  CHECK_GLFW_WINDOW(window);
  r_cursor_pos_callback = cb;
  glfwSetCursorPosCallback((GLFWwindow *) R_ExternalPtrAddr(window), cursor_pos_cb);

  return R_NilValue;
}

// TODO: Consider creating a variation of this function that takes the cursor
// position as a SEXP and overwrites the result. This is to avoid the many calls
// to Rf_mkNamed that keep allocating a new vector each time
// glfw_get_cursor_pos_() gets called.
SEXP glfw_get_cursor_pos_(SEXP window) {

  CHECK_GLFW_WINDOW(window);

  const char *names[] = {"xpos", "ypos", ""};
  SEXP cursor_pos = PROTECT(Rf_mkNamed(REALSXP, names));
  double xpos, ypos;
  glfwGetCursorPos((GLFWwindow *) R_ExternalPtrAddr(window), &xpos, &ypos);

  REAL(cursor_pos)[0] = xpos;
  REAL(cursor_pos)[1] = ypos;

  UNPROTECT(1);
  return cursor_pos;
}

SEXP glfw_set_cursor_pos_(SEXP window, SEXP xpos, SEXP ypos) {

  CHECK_GLFW_WINDOW(window);
  glfwSetCursorPos((GLFWwindow *) R_ExternalPtrAddr(window), REAL(xpos)[0], REAL(ypos)[0]);
  return R_NilValue;
}

SEXP glfw_set_scroll_callback_(SEXP window, SEXP cb) {

  CHECK_GLFW_WINDOW(window);
  r_scroll_callback = cb;
  glfwSetScrollCallback((GLFWwindow *) R_ExternalPtrAddr(window), scroll_cb);

  return R_NilValue;
}
