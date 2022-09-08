#ifndef GLFW_H
#define GLFW_H

/*
 To make sure there will be no header conflicts, you can define
 GLFW_INCLUDE_NONE before the GLFW header to explicitly disable
 inclusion of the development environment header. This also allows
 the two headers to be included in any order.
 */
#define GLFW_INCLUDE_NONE
#include <glad/glad.h>
#include <GLFW/glfw3.h>

// R's Internal API
#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#define CHECK_GLFW_WINDOW(GLFW_WINDOW) {\
  if (R_ExternalPtrAddr(GLFW_WINDOW) == NULL) \
  Rf_error("Window pointer is nil.\n");\
  }

#endif
