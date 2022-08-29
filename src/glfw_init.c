/*
 * Initialization, version and error reference.
 */

#include <glfw.h>

SEXP glfw_init_(void) {

  if (!glfwInit()) {
    Rf_error("Failed to initialize GLFW!\n");
    return R_NilValue;
  }

  return Rf_ScalarLogical(1);
}

SEXP glfw_terminate_(void) {
  glfwTerminate();
  return(Rf_ScalarLogical(1));
}

SEXP glfw_get_version_(void) {

  int major = NA_INTEGER;
  int minor = NA_INTEGER;
  int rev = NA_INTEGER;

  // array of names; note the null string
  const char *names[] = {"major", "minor", "rev", ""};
  SEXP x = PROTECT(Rf_mkNamed(INTSXP, names));
  glfwGetVersion(&major, &minor, &rev);

  // populate integer vector `x`. If any of these elements
  // were not assigned by `glfwGetVersion()` then the value
  // remains NA_INTEGER.
  INTEGER(x)[0] = major;
  INTEGER(x)[1] = minor;
  INTEGER(x)[2] = rev;

  UNPROTECT(1);
  return x;

}

SEXP glfw_get_version_string_(void) {
  SEXP string;
  string = Rf_mkString(glfwGetVersionString());
  return(string);
}

SEXP glfw_window_hint_(SEXP hint, SEXP value) {
  glfwWindowHint((unsigned int)INTEGER(hint)[0], INTEGER(value)[0]);
  return R_NilValue;
}
