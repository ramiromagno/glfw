compile_shader <- function(shader_type, shader_src) {
  shader <- gl_create_shader(shader_type)
  gl_shader_source(shader, 1L, shader_src)
  gl_compile_shader(shader)

  # Check the shader compilation status
  if (!gl_get_shader_iv(shader, GL$COMPILE_STATUS)) {
    stop(gl_get_shader_info_log(shader))
  }
  return(shader)
}

#' Build a shader program
#'
#' @description
#'
#' This function creates a program object that represents fully processed
#' executable code in the OpenGL Shading Language for one or more shader
#' stages.
#'
#' All arguments expect the source code of each shader. The source code can be
#' provided as a character vector, or as a path to the source code file. At
#' least the source code of one shader must be supplied. A typical use case is
#' to supply the source code of the vertex and fragment shaders.
#'
#' @param vert Vertex shader.
#' @param tesc Tessellation control shader.
#' @param tese Tessellation evaluation shader.
#' @param geom Geometry shader.
#' @param frag Fragment shader.
#' @param comp Compute shader.
#'
#' @return A non-zero value corresponding to the shader program reference.
#'
#' @export
build_program <-
  function(vert = NULL,
           tesc = NULL,
           tese = NULL,
           geom = NULL,
           frag = NULL,
           comp = NULL) {
    if (is.null(vert) &&
        is.null(tesc) &&
        is.null(tese) &&
        is.null(geom) &&
        is.null(frag) &&
        is.null(comp))
      stop("No shader source code supplied.")

    if (!is.null(vert)) {
      vert <- read_shader(vert)
      vert_shader <- compile_shader(GL$VERTEX_SHADER, vert)
    }

    if (!is.null(tesc)) {
      tesc <- read_shader(tesc)
      tesc_shader <- compile_shader(GL$TESS_CONTROL_SHADER, tesc)
    }

    if (!is.null(tese)) {
      tese <- read_shader(tese)
      tese_shader <- compile_shader(GL$TESS_EVALUATION_SHADER, tese)
    }

    if (!is.null(geom)) {
      geom <- read_shader(geom)
      geom_shader <- compile_shader(GL$GEOMETRY_SHADER, geom)
    }

    if (!is.null(frag)) {
      frag <- read_shader(frag)
      frag_shader <- compile_shader(GL$FRAGMENT_SHADER, frag)
    }

    if (!is.null(comp)) {
      comp <- read_shader(comp)
      comp_shader <- compile_shader(GL$COMPUTE_SHADER, comp)
    }

    # Create shader program
    shader_program <- gl_create_program()
    if (identical(shader_program, 0L))
      stop("Failed to create the shader program.")

    # Attach shaders
    if (!is.null(vert))
      gl_attach_shader(shader_program, vert_shader)
    if (!is.null(tesc))
      gl_attach_shader(shader_program, tesc_shader)
    if (!is.null(tese))
      gl_attach_shader(shader_program, tese_shader)
    if (!is.null(geom))
      gl_attach_shader(shader_program, geom_shader)
    if (!is.null(frag))
      gl_attach_shader(shader_program, frag_shader)
    if (!is.null(comp))
      gl_attach_shader(shader_program, comp_shader)

    # Link shaders
    gl_link_program(shader_program)

    if (!gl_get_program_iv(shader_program, GL$LINK_STATUS)) {
      stop(gl_get_program_info_log(shader_program))
    }

    # Delete all shaders. They will continue to stay alive until they are no
    # longer referenced.
    # Source: https://stackoverflow.com/questions/24172962/gldeleteshader-is-the-order-irrelevant
    if (!is.null(vert))
      gl_delete_shader(vert_shader)
    if (!is.null(tesc))
      gl_delete_shader(tesc_shader)
    if (!is.null(tese))
      gl_delete_shader(tese_shader)
    if (!is.null(geom))
      gl_delete_shader(geom_shader)
    if (!is.null(frag))
      gl_delete_shader(frag_shader)
    if (!is.null(comp))
      gl_delete_shader(comp_shader)

    return (shader_program)
  }
