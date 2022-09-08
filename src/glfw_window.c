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

SEXP glfw_get_window_frame_size_(SEXP window) {

  CHECK_GLFW_WINDOW(window);

  int left = NA_INTEGER;
  int top = NA_INTEGER;
  int right = NA_INTEGER;
  int bottom = NA_INTEGER;

  const char *names[] = {"left", "top", "right", "bottom", ""};
  SEXP x = PROTECT(Rf_mkNamed(INTSXP, names));

  GLFWwindow *ptr = R_ExternalPtrAddr(window);
  glfwGetWindowFrameSize(ptr, &left, &top, &right, &bottom);

  INTEGER(x)[0] = left;
  INTEGER(x)[1] = top;
  INTEGER(x)[2] = right;
  INTEGER(x)[3] = bottom;

  UNPROTECT(1);
  return x;
}

SEXP glfw_get_window_content_scale_(SEXP window) {

  CHECK_GLFW_WINDOW(window);

  float xscale = NA_INTEGER;
  float yscale = NA_INTEGER;
  const char *names[] = {"xscale", "yscale", ""};
  SEXP x = PROTECT(Rf_mkNamed(REALSXP, names));

  GLFWwindow *ptr = R_ExternalPtrAddr(window);
  glfwGetWindowContentScale(ptr, &xscale, &yscale);

  REAL(x)[0] = (double) xscale;
  REAL(x)[1] = (double) yscale;

  UNPROTECT(1);
  return x;
}

SEXP glfw_get_window_opacity_(SEXP window) {
  CHECK_GLFW_WINDOW(window);
  float opacity = glfwGetWindowOpacity((GLFWwindow *) R_ExternalPtrAddr(window));
  return Rf_ScalarReal((double) opacity);
}

SEXP glfw_set_window_opacity_(SEXP window, SEXP opacity) {
  CHECK_GLFW_WINDOW(window);
  glfwSetWindowOpacity((GLFWwindow *) R_ExternalPtrAddr(window), (float) REAL(opacity)[0]);
  return R_NilValue;
}

SEXP glfw_iconify_window_(SEXP window) {
  CHECK_GLFW_WINDOW(window);
  glfwIconifyWindow((GLFWwindow *) R_ExternalPtrAddr(window));
  return R_NilValue;
}

SEXP glfw_restore_window_(SEXP window) {
  CHECK_GLFW_WINDOW(window);
  glfwRestoreWindow((GLFWwindow *) R_ExternalPtrAddr(window));
  return R_NilValue;
}

SEXP glfw_maximize_window_(SEXP window) {
  CHECK_GLFW_WINDOW(window);
  glfwMaximizeWindow((GLFWwindow *) R_ExternalPtrAddr(window));
  return R_NilValue;
}

SEXP glfw_show_window_(SEXP window) {
  CHECK_GLFW_WINDOW(window);
  glfwShowWindow((GLFWwindow *) R_ExternalPtrAddr(window));
  return R_NilValue;
}

SEXP glfw_hide_window_(SEXP window) {
  CHECK_GLFW_WINDOW(window);
  glfwHideWindow((GLFWwindow *) R_ExternalPtrAddr(window));
  return R_NilValue;
}

SEXP glfw_focus_window_(SEXP window) {
  CHECK_GLFW_WINDOW(window);
  glfwFocusWindow((GLFWwindow *) R_ExternalPtrAddr(window));
  return R_NilValue;
}

SEXP glfw_request_window_attention_(SEXP window) {
  CHECK_GLFW_WINDOW(window);
  glfwRequestWindowAttention((GLFWwindow *) R_ExternalPtrAddr(window));
  return R_NilValue;
}

SEXP glfw_get_window_attrib_(SEXP window, SEXP attrib) {
  CHECK_GLFW_WINDOW(window);
  int value = glfwGetWindowAttrib((GLFWwindow *) R_ExternalPtrAddr(window), (int) INTEGER(attrib)[0]);
  return Rf_ScalarInteger(value);
}
