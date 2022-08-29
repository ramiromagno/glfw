# Developer notes

### No visible binding for global variable

I quote the name of C functions passed to `.Call()` to avoid the NOTE:

    glfw_terminate: no visible binding for global variable
        ‘glfw_terminate_’

### C_VISIBILITY

If you use `C_VISIBILITY` in Makevars:

    PKG_CFLAGS = $(C_VISIBILITY)

Then you need to use `attribute_visible` in conjunction with your C function definitions to create the C entry point, i.e. so that `.Call()` does not err:

    Error in .Call("glfw_get_version_") : 
      "glfw_get_version_" not resolved from current namespace (glfw)

See [rlang-types.h](https://github.com/r-lib/rlang/blob/main/src/rlang/rlang-types.h) for a nice , tidy approach.
