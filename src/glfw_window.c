#include <glfw.h>

static void window_finalizer_(SEXP ext) {
  if (NULL == R_ExternalPtrAddr(ext)) return;
  glfwDestroyWindow((GLFWwindow *) R_ExternalPtrAddr(ext));
  R_ClearExternalPtr(ext);
}

SEXP glfw_create_window_(SEXP width, SEXP height, SEXP title) {

  GLFWwindow* _window =
    glfwCreateWindow(Rf_asInteger(width), Rf_asInteger(height), CHAR(STRING_ELT(title, 0)), NULL, NULL);

  if (!_window)
  {
    const char msg[] = "Window creation failed!\n";
    Rf_error(msg);
    return(R_NilValue); // To eliminate compiler warnings about non-void functions that don't return.
  }

  // The tag object associated with the external pointer.
  SEXP class = PROTECT(Rf_mkString("glfw_window"));
  SEXP window = PROTECT(R_MakeExternalPtr(_window, R_NilValue, R_NilValue));
  // assign the attribute class to the external pointer
  Rf_classgets(window, class);

  R_RegisterCFinalizer(window, window_finalizer_);

  UNPROTECT(2);
  return window;

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

  CHECK_GLFW_WINDOW(window);

  int width = NA_INTEGER;
  int height = NA_INTEGER;
  const char *names[] = {"width", "height", ""};
  SEXP x = PROTECT(Rf_mkNamed(INTSXP, names));

  GLFWwindow *ptr = R_ExternalPtrAddr(window);
  glfwGetWindowSize(ptr, &width, &height);

  INTEGER(x)[0] = width;
  INTEGER(x)[1] = height;

  UNPROTECT(1);
  return x;
}

SEXP glfw_set_window_size_(SEXP window, SEXP width, SEXP height) {

  CHECK_GLFW_WINDOW(window);

  glfwSetWindowSize(
    (GLFWwindow *) R_ExternalPtrAddr(window),
    (int) INTEGER(width)[0],
    (int) INTEGER(height)[0]
  );

  return R_NilValue;
}

// Global variable to hold the R function (closure) to be used as
// framebuffer buffer size (fbs) callback.
static SEXP r_fbs_callback;

static void fbs_cb(GLFWwindow* window, int width, int height)
{
  SEXP r_window = PROTECT(R_MakeExternalPtr(window, R_NilValue, R_NilValue));
  SEXP r_width = PROTECT(Rf_ScalarInteger(width));
  SEXP r_height = PROTECT(Rf_ScalarInteger(height));

  SEXP call = PROTECT(Rf_lang4(r_fbs_callback, r_window, r_width, r_height));
  Rf_eval(call, R_EmptyEnv);

  UNPROTECT(4);
  return;
}

SEXP glfw_set_framebuffer_size_callback_(SEXP window, SEXP cbfun) {

  CHECK_GLFW_WINDOW(window);

  r_fbs_callback = cbfun;
  glfwSetFramebufferSizeCallback((GLFWwindow *) R_ExternalPtrAddr(window), fbs_cb);
  return R_NilValue;
}

SEXP glfw_window_should_close_(SEXP window) {

  CHECK_GLFW_WINDOW(window);

  int close_flag = glfwWindowShouldClose((GLFWwindow *) R_ExternalPtrAddr(window));
  return Rf_ScalarLogical(close_flag);
}

SEXP glfw_set_window_should_close_(SEXP window, SEXP value) {

  CHECK_GLFW_WINDOW(window);

  glfwSetWindowShouldClose((GLFWwindow *) R_ExternalPtrAddr(window), INTEGER(value)[0]);
  return(R_NilValue);
}

SEXP glfw_poll_events_(void) {
  glfwPollEvents();
  return R_NilValue;
}

SEXP glfw_window_hint_(SEXP hint, SEXP value) {
  glfwWindowHint((unsigned int)INTEGER(hint)[0], INTEGER(value)[0]);
  return R_NilValue;
}

SEXP glfw_set_window_aspect_ratio_(SEXP window, SEXP numer, SEXP denom) {

  CHECK_GLFW_WINDOW(window);

  glfwSetWindowAspectRatio(
    (GLFWwindow *) R_ExternalPtrAddr(window),
    (int) INTEGER(numer)[0],
    (int) INTEGER(denom)[0]
  );

  return R_NilValue;
}

SEXP glfw_window_hint_string_(SEXP hint, SEXP value) {

  glfwWindowHintString((unsigned int)INTEGER(hint)[0], CHAR(STRING_ELT(value, 0)));
  return R_NilValue;
}

SEXP glfw_set_window_size_limits_(
    SEXP window,
    SEXP min_width,
    SEXP min_height,
    SEXP max_width,
    SEXP max_height) {

  CHECK_GLFW_WINDOW(window);

  glfwSetWindowSizeLimits(
    (GLFWwindow *) R_ExternalPtrAddr(window),
    (int) INTEGER(min_width)[0],
    (int) INTEGER(min_height)[0],
    (int) INTEGER(max_width)[0],
    (int) INTEGER(max_height)[0]
  );

  return R_NilValue;
}

SEXP glfw_get_framebuffer_size_(SEXP window) {

  CHECK_GLFW_WINDOW(window);

  int width = NA_INTEGER;
  int height = NA_INTEGER;
  const char *names[] = {"width", "height", ""};
  SEXP x = PROTECT(Rf_mkNamed(INTSXP, names));

  GLFWwindow *ptr = R_ExternalPtrAddr(window);
  glfwGetFramebufferSize(ptr, &width, &height);

  INTEGER(x)[0] = width;
  INTEGER(x)[1] = height;

  UNPROTECT(1);
  return x;
}
