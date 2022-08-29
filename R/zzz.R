.onUnload <- function(libpath) {
  gc() # trigger finalisers
  library.dynam.unload("glfw", libpath)
}
