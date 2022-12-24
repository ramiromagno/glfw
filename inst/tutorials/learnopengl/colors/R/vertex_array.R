setup_vao <- function(vertices) {

  cube_vao <- gl_gen_vertex_arrays(1L)
  vbo <- gl_gen_buffers(1L)

  gl_bind_buffer(GL$ARRAY_BUFFER, vbo)
  gl_buffer_data(GL$ARRAY_BUFFER, vertices, GL$STATIC_DRAW)

  gl_bind_vertex_array(cube_vao)
  gl_vertex_attrib_pointer(0L, 3L, GL$DOUBLE, GL$`FALSE`, 3L, 0L)
  gl_enable_vertex_attrib_array(0L)

  light_cube_vao <- gl_gen_vertex_arrays(1L)

  gl_bind_vertex_array(light_cube_vao)
  gl_bind_buffer(GL$ARRAY_BUFFER, vbo)
  gl_vertex_attrib_pointer(0L, 3L, GL$DOUBLE, GL$`FALSE`, 3L, 0L)
  gl_enable_vertex_attrib_array(0L)

  return(c(cube_vao = cube_vao, light_cube_vao = light_cube_vao,  vbo = vbo))
}
