#' @export
n_active_uniforms <- function(program) {
  gl_get_program_iv(program = program, pname = GL$ACTIVE_UNIFORMS)
}

#' @export
get_all_active_uniforms <- function(program) {
  n <- n_active_uniforms(program)

  # The `index` argument in `gl_get_active_uniform()` runs from 0 thru n - 1.
  lst <- lapply(seq_len(n) - 1L, \(i) gl_get_active_uniform(program = program, index = i))
  df <- do.call(rbind.data.frame, lst)

  # df$type is either GL$FLOAT, GL$FLOAT_VEC2, etc.
  idx <- match(df$type, uniform_types$constant)
  type <- uniform_types$type[idx]

  # Overwrite df$type with type (GLSL shader types)
  # GLSL shader type is either: float, vec2, vec3, etc.
  df$type <- type

  df
}

#' @export
set_uniform <- function(program, var, value) {

  uniforms <- get_all_active_uniforms(program)
  idx <- match(var, uniforms$name)

  if(is.na(idx))
    stop(var, " is not an active uniform in the shader program.")

  # Check if there are any NAs.
  if (anyNA(value))
    stop("`value` can't contain NA elements.")

  location <- uniforms$index[idx]
  type <- uniforms$type[idx]

  switch (type,
    "float" = gl_uniform_f(location, value),
    "vec2" = gl_uniform_f(location, value),
    "vec3" = gl_uniform_f(location, value),
    "vec4" = gl_uniform_f(location, value),

    "int" = gl_uniform_i(location, value),
    "ivec2" = gl_uniform_i(location, value),
    "ivec3" = gl_uniform_i(location, value),
    "ivec4" = gl_uniform_i(location, value),

    "unsigned int" = gl_uniform_ui(location, value),
    "uvec2" = gl_uniform_ui(location, value),
    "uvec3" = gl_uniform_ui(location, value),
    "uvec4" = gl_uniform_ui(location, value),

    stop(type, " type not supported yet.")
  )
}
