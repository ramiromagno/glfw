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
