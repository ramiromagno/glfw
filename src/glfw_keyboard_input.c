#include <glfw.h>

// Global variable to hold the R function (closure) to be used as
// cursor position callback.
static SEXP r_key_callback;

static void key_cb(GLFWwindow* _window, int _key, int _scancode, int _action, int _mods)
{
  SEXP window = PROTECT(R_MakeExternalPtr(_window, R_NilValue, R_NilValue));
  SEXP key = PROTECT(Rf_ScalarInteger(_key));
  SEXP scancode = PROTECT(Rf_ScalarInteger(_scancode));
  SEXP action = PROTECT(Rf_ScalarInteger(_action));
  SEXP mods = PROTECT(Rf_ScalarInteger(_mods));

  SEXP call = PROTECT(Rf_lang6(r_key_callback, window, key, scancode, action, mods));
  Rf_eval(call, R_EmptyEnv);

  UNPROTECT(6);
  return;
}

SEXP glfw_set_key_callback_(SEXP window, SEXP cb) {

  CHECK_GLFW_WINDOW(window);
  r_key_callback = cb;
  glfwSetKeyCallback((GLFWwindow *) R_ExternalPtrAddr(window), key_cb);

  return R_NilValue;
}
