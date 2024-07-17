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

### Not finding a C function during compilation

Make sure you have not inadvertently placed a C file in the R/ folder, instead of src/.

### Typical development workflow

1. Add a C function to a file in src/
2. Add an R wrapper to a file in R/
3. Run craftthis::register_compiled_fns()

### Code organization

1. Typically, a src/ file has an accompanying R/ file.
2. Source files starting with `glfw_` provide the GLFW API which this package is all about.
3. Source files starting with `glm_` provide the GLM API in R code.
4. Source files starting with `gl_` provide the OpenGL API.
5. Source files starting with `r_` provide novel API but that is not GLFW API per se, typically utility functions.
6. GL and GLFW constants are generated in data-raw/ and exported as datasets.

### GLAD

1. Install `python-glad`:

   ```bash
   yay -S python-glad
   ```

   

2. Run `glad` to generate `glad.c` and `glad.h`:

   ```bash
   glad --generator c --out-path .
   ```

   You should have now:

   - `include/glad.h`
   - `src/glad.c`

Troubleshooting: <https://stackoverflow.com/questions/58053885/having-an-issue-with-gladloadgl-im-getting-an-error-saying-it-does-not-take>


