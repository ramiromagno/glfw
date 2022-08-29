#include <glfw.h>

static void window_finalizer_(SEXP ext) {
  if (NULL == R_ExternalPtrAddr(ext)) return;
  glfwDestroyWindow((GLFWwindow *) R_ExternalPtrAddr(ext));
  R_ClearExternalPtr(ext);
}

SEXP glfw_create_window_(SEXP width, SEXP height, SEXP title) {

  GLFWwindow* window =
    glfwCreateWindow(Rf_asInteger(width), Rf_asInteger(height), CHAR(STRING_ELT(title, 0)), NULL, NULL);

  if (!window)
  {
    const char msg[] = "Window creation failed!\n";
    Rf_error(msg);
    return(R_NilValue); // To eliminate compiler warnings about non-void functions that don't return.
  }

  SEXP ext = PROTECT(R_MakeExternalPtr(window, R_NilValue, R_NilValue));
  R_RegisterCFinalizer(ext, window_finalizer_);

  UNPROTECT(1);
  return ext;

}

SEXP glfw_destroy_window_(SEXP window) {

  GLFWwindow *ptr = R_ExternalPtrAddr(window);
  if (ptr == NULL) {
    return window;
  } else {
    glfwDestroyWindow((GLFWwindow *) R_ExternalPtrAddr(window));
    R_ClearExternalPtr(window);
    return window;
  }
}

SEXP glfw_get_window_size_(SEXP window) {

  int width = NA_INTEGER;
  int height = NA_INTEGER;
  GLFWwindow *ptr = R_ExternalPtrAddr(window);
  const char *names[] = {"width", "height", ""};
  SEXP x = PROTECT(Rf_mkNamed(INTSXP, names));

  if (ptr) {
    glfwGetWindowSize(ptr, &width, &height);
  } else {
    Rprintf("GLFWwindow ptr is nil\n");
  }

  INTEGER(x)[0] = width;
  INTEGER(x)[1] = height;

  UNPROTECT(1);
  return x;
}

// Global variable to hold the R function (closure) to be used as
// framebuffer buffer size (fbs) callback.
static SEXP r_fbs_callback;

static void fbs_cb(GLFWwindow* window, int width, int height)
{
  if (window == NULL) {
    const char msg[] = "Window pointer is nil!\n";
    Rf_error(msg);
  }

  SEXP r_window = PROTECT(R_MakeExternalPtr(window, R_NilValue, R_NilValue));
  SEXP r_width = PROTECT(Rf_ScalarInteger(width));
  SEXP r_height = PROTECT(Rf_ScalarInteger(height));

  SEXP call = PROTECT(Rf_lang4(r_fbs_callback, r_window, r_width, r_height));
  Rf_eval(call, R_EmptyEnv);

  UNPROTECT(4);
  return;
}

SEXP glfw_set_framebuffer_size_callback_(SEXP window, SEXP cbfun) {

  if (R_ExternalPtrAddr(window) == NULL) {
    const char msg[] = "Window pointer is nil!\n";
    Rf_error(msg);
    return(R_NilValue);
  }

  r_fbs_callback = cbfun;
  glfwSetFramebufferSizeCallback((GLFWwindow *) R_ExternalPtrAddr(window), fbs_cb);
  return R_NilValue;
}

SEXP glfw_window_should_close_(SEXP window) {

  if (R_ExternalPtrAddr(window) == NULL) {
    const char msg[] = "Window pointer is nil!\n";
    Rf_error(msg);
    return(R_NilValue);
  }

  int close_flag = glfwWindowShouldClose((GLFWwindow *) R_ExternalPtrAddr(window));
  return Rf_ScalarLogical(close_flag);
}

SEXP glfw_set_window_should_close_(SEXP window, SEXP value) {

  if (R_ExternalPtrAddr(window) == NULL) {
    const char msg[] = "Window pointer is nil!\n";
    Rf_error(msg);
    return(R_NilValue);
  }

  glfwSetWindowShouldClose((GLFWwindow *) R_ExternalPtrAddr(window), INTEGER(value)[0]);
  return(R_NilValue);
}
