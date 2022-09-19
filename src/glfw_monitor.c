#include <glfw.h>

SEXP glfw_get_primary_monitor_(void) {
  GLFWmonitor* _monitor = glfwGetPrimaryMonitor();
  if (!_monitor)
  {
    const char msg[] = "Failed to get the primary monitor pointer!\n";
    Rf_error(msg);
    return(R_NilValue);
  }

  SEXP class = PROTECT(Rf_mkString("glfw_monitor"));
  SEXP monitor = PROTECT(R_MakeExternalPtr(_monitor, R_NilValue, R_NilValue));
  Rf_classgets(monitor, class);
  // Contrary to other pointers, I think the GLFWmonitor pointer does not need
  // a Finalizer.

  UNPROTECT(2);
  return monitor;

}

SEXP glfw_get_monitors_(void) {
  int count;
  GLFWmonitor** _monitors = glfwGetMonitors(&count);

  if (!_monitors)
  {
    const char msg[] = "Failed to get the _monitors pointer!\n";
    Rf_error(msg);
    return(R_NilValue);
  }

  SEXP monitors = PROTECT(Rf_allocVector(VECSXP, count));
  SEXP class = PROTECT(Rf_mkString("glfw_monitor"));
  SEXP monitor;

  for (int i = 0; i < count; i++) {
    monitor = PROTECT(R_MakeExternalPtr(_monitors[i], R_NilValue, R_NilValue));
    Rf_classgets(monitor, class);
    SET_VECTOR_ELT(monitors, i, monitor);
  }

  UNPROTECT(2 + count);
  return monitors;
}

SEXP glfw_get_monitor_pos_(SEXP monitor) {

  int xpos, ypos;
  glfwGetMonitorPos((GLFWmonitor *) R_ExternalPtrAddr(monitor), &xpos, &ypos);

  const char *names[] = {"xpos", "ypos", ""};
  SEXP pos = PROTECT(Rf_mkNamed(INTSXP, names));

  INTEGER(pos)[0] = xpos;
  INTEGER(pos)[1] = ypos;

  UNPROTECT(1);
  return pos;
}

SEXP glfw_get_monitor_workarea_(SEXP monitor) {
  int xpos, ypos, width, height;
  glfwGetMonitorWorkarea((GLFWmonitor *) R_ExternalPtrAddr(monitor), &xpos, &ypos, &width, &height);

  const char *names[] = {"xpos", "ypos", "width", "height", ""};
  SEXP workarea = PROTECT(Rf_mkNamed(INTSXP, names));

  INTEGER(workarea)[0] = xpos;
  INTEGER(workarea)[1] = ypos;
  INTEGER(workarea)[2] = width;
  INTEGER(workarea)[3] = height;

  UNPROTECT(1);
  return workarea;
}

SEXP glfw_get_monitor_physical_size_(SEXP monitor) {
  int width_mm, height_mm; // width and height in millimetres
  glfwGetMonitorPhysicalSize((GLFWmonitor *) R_ExternalPtrAddr(monitor), &width_mm, &height_mm);

  const char *names[] = {"width_mm", "height_mm", ""};
  SEXP area = PROTECT(Rf_mkNamed(INTSXP, names));

  INTEGER(area)[0] = width_mm;
  INTEGER(area)[1] = height_mm;

  UNPROTECT(1);
  return area;
}

SEXP glfw_get_monitor_content_scale_(SEXP monitor) {
  float xscale, yscale; // width and height in millimetres
  glfwGetMonitorContentScale((GLFWmonitor *) R_ExternalPtrAddr(monitor), &xscale, &yscale);

  const char *names[] = {"xscale", "yscale", ""};
  SEXP scale = PROTECT(Rf_mkNamed(REALSXP, names));

  REAL(scale)[0] = (double) xscale;
  REAL(scale)[1] = (double) yscale;

  UNPROTECT(1);
  return scale;
}

SEXP glfw_get_monitor_name_(SEXP monitor) {

  const char *monitor_name;
  monitor_name = glfwGetMonitorName((GLFWmonitor *) R_ExternalPtrAddr(monitor));
  return Rf_mkString(monitor_name);

}

SEXP glfw_get_video_mode_(SEXP monitor) {

  const GLFWvidmode *_video_mode;
  _video_mode = glfwGetVideoMode((GLFWmonitor *) R_ExternalPtrAddr(monitor));

  const char *names[] = {"width", "height", "red_bits", "green_bits", "blue_bits", "refresh_rate", ""};
  SEXP video_mode = PROTECT(Rf_mkNamed(INTSXP, names));

  INTEGER(video_mode)[0] = _video_mode->width;
  INTEGER(video_mode)[1] = _video_mode->height;
  INTEGER(video_mode)[2] = _video_mode->redBits;
  INTEGER(video_mode)[3] = _video_mode->greenBits;
  INTEGER(video_mode)[4] = _video_mode->blueBits;
  INTEGER(video_mode)[5] = _video_mode->refreshRate;

  UNPROTECT(1);
  return video_mode;
}

SEXP glfw_get_video_modes_(SEXP monitor) {

  const GLFWvidmode *_video_modes;
  int count; // number of video modes
  _video_modes = glfwGetVideoModes((GLFWmonitor *) R_ExternalPtrAddr(monitor), &count);

  // List of six vectors (width, height, redBits, greenBits, blueBits, refreshRate)
  SEXP video_modes = PROTECT(Rf_allocVector(VECSXP, 6));
  SEXP width = PROTECT(Rf_allocVector(INTSXP, count));
  SEXP height = PROTECT(Rf_allocVector(INTSXP, count));
  SEXP red_bits = PROTECT(Rf_allocVector(INTSXP, count));
  SEXP green_bits = PROTECT(Rf_allocVector(INTSXP, count));
  SEXP blue_bits = PROTECT(Rf_allocVector(INTSXP, count));
  SEXP refresh_rate = PROTECT(Rf_allocVector(INTSXP, count));

  for (int i = 0; i < count; i++) {
    INTEGER(width)[i] = (_video_modes + i)->width;
    INTEGER(height)[i] = (_video_modes + i)->height;
    INTEGER(red_bits)[i] = (_video_modes + i)->redBits;
    INTEGER(green_bits)[i] = (_video_modes + i)->greenBits;
    INTEGER(blue_bits)[i] = (_video_modes + i)->blueBits;
    INTEGER(refresh_rate)[i] = (_video_modes + i)->refreshRate;
  }

  SET_VECTOR_ELT(video_modes, 0, width);
  SET_VECTOR_ELT(video_modes, 1, height);
  SET_VECTOR_ELT(video_modes, 2, red_bits);
  SET_VECTOR_ELT(video_modes, 3, green_bits);
  SET_VECTOR_ELT(video_modes, 4, blue_bits);
  SET_VECTOR_ELT(video_modes, 5, refresh_rate);

  UNPROTECT(7);

  return video_modes;
}

SEXP glfw_get_gamma_ramp_(SEXP monitor) {

  const GLFWgammaramp *_gamma_ramp;
  _gamma_ramp = glfwGetGammaRamp((GLFWmonitor *) R_ExternalPtrAddr(monitor));

  if (!_gamma_ramp)
  {
    const char msg[] = "`glfwGetGammaRamp()` returned nil!\n";
    Rf_error(msg);
    return(R_NilValue);
  }

  // List of three vectors (red, green and blue)
  SEXP gamma_ramp = PROTECT(Rf_allocVector(VECSXP, 3));
  SEXP red = PROTECT(Rf_allocVector(INTSXP, _gamma_ramp->size));
  SEXP green = PROTECT(Rf_allocVector(INTSXP, _gamma_ramp->size));
  SEXP blue = PROTECT(Rf_allocVector(INTSXP, _gamma_ramp->size));

  for (int i = 0; i < _gamma_ramp->size; i++) {
    INTEGER(red)[i] = (int) _gamma_ramp->red[i];
    INTEGER(green)[i] = (int) _gamma_ramp->green[i];
    INTEGER(blue)[i] = (int) _gamma_ramp->blue[i];
  }

  SET_VECTOR_ELT(gamma_ramp, 0, red);
  SET_VECTOR_ELT(gamma_ramp, 1, green);
  SET_VECTOR_ELT(gamma_ramp, 2, blue);

  UNPROTECT(4);

  return gamma_ramp;
}
