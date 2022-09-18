#include <glfw.h>

SEXP glfw_poll_events_(void) {
  glfwPollEvents();
  return R_NilValue;
}

SEXP glfw_wait_events_(void) {
  glfwWaitEvents();
  return R_NilValue;
}

SEXP glfw_wait_events_timeout_(SEXP timeout) {
  glfwWaitEventsTimeout((double) REAL(timeout)[0]);
  return R_NilValue;
}

SEXP glfw_post_empty_event_(void) {
  glfwPostEmptyEvent();
  return R_NilValue;
}
