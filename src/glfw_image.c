#include <glfw.h>

SEXP glfw_destroy_image_(SEXP image) {

  GLFWimage* _image = (GLFWimage *) R_ExternalPtrAddr(image);
  if (!_image) return R_NilValue;
  free(_image->pixels);
  free(_image);
  R_ClearExternalPtr(image);
  return R_NilValue;
}

static void image_finalizer_(SEXP image) {

  glfw_destroy_image_(image);
}

SEXP glfw_create_image_(SEXP image_data) {

  if (!Rf_isArray(image_data)) {
    Rprintf("`image_data` is not an array\n");
    return(R_NilValue);
  }

  // `dim` is an integer vector containing the three dimensions of the array
  // idx 0: 4 (RGBA)
  // idx 1: width
  // idx 2: height
  SEXP dim = PROTECT(Rf_getAttrib(image_data, R_DimSymbol));
  R_len_t _n = XLENGTH(image_data);

  GLFWimage* _image = malloc(sizeof(GLFWimage));

  if (!_image)
  {
    const char msg[] = "GLFW image creation failed!\n";
    Rf_error(msg);
    return(R_NilValue); // To eliminate compiler warnings about non-void functions that don't return.
  }

  // NB: INTEGER(dim)[0] is 4 (the four channels, RGBA)
  _image->width = INTEGER(dim)[1];
  _image->height = INTEGER(dim)[2];
  _image->pixels = (unsigned char *) calloc(_n, sizeof(unsigned char));
  if (!(_image->pixels)) Rf_error("Memory allocation of glfw_image pixels element failed.\n");

  unsigned char *_image_data_ptr = RAW(image_data);
  for (R_xlen_t i = 0; i < _n; i++) {
    (_image->pixels)[i] = _image_data_ptr[i];
  }

  SEXP class = PROTECT(Rf_mkString("glfw_image"));
  SEXP image = PROTECT(R_MakeExternalPtr(_image, R_NilValue, R_NilValue));
  // assign the attribute class to the external pointer
  Rf_classgets(image, class);

  R_RegisterCFinalizer(image, image_finalizer_);

  UNPROTECT(3);
  return image;

}

