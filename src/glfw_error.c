#include <glfw.h>

// Global variable to hold the R function (closure) to be used as
// error callback.
static SEXP r_error_callback;

static void error_cb(int error, const char* description)
{
  SEXP r_error = PROTECT(Rf_ScalarInteger(error));
  SEXP r_description = PROTECT(Rf_mkString(description));

  SEXP call = PROTECT(Rf_lang3(r_error_callback, r_error, r_description));
  // `call` is evaluated for its side effects, so no need to store and/or
  // PROTECT the result from its evaluation.
  Rf_eval(call, R_EmptyEnv);

  UNPROTECT(3);
  return;
}

SEXP glfw_set_error_callback_(SEXP callback) {

  r_error_callback = callback;
  glfwSetErrorCallback(error_cb);

  return R_NilValue;
}

SEXP glfw_get_error_(void) {

  const char *description;
  int error_code;
  error_code = glfwGetError(&description);

  const char *names[] = {"error_code", "description", ""};
  SEXP list = PROTECT(Rf_mkNamed(VECSXP, names));
  SET_VECTOR_ELT(list, 0, Rf_ScalarInteger(error_code));

  if (description == NULL) {
    SET_VECTOR_ELT(list, 1, Rf_ScalarString(NA_STRING));
  } else {
    SET_VECTOR_ELT(list, 1, Rf_mkString(description));
  }
  UNPROTECT(1);
  return list;
}
