setup_vao <- function(vertices) {

  vao <- gl_gen_vertex_arrays(1L)
  vbo <- gl_gen_buffers(1L)

  gl_bind_vertex_array(vao)
  gl_bind_buffer(GL$ARRAY_BUFFER, vbo)
  gl_buffer_data(GL$ARRAY_BUFFER, vertices, GL$STATIC_DRAW)
  gl_vertex_attrib_pointer(0L, 3L, GL$DOUBLE, GL$`FALSE`, 5L, 0L)
  gl_enable_vertex_attrib_array(0L)
  gl_vertex_attrib_pointer(1L, 2L, GL$DOUBLE, GL$`FALSE`, 5L, 3L)
  gl_enable_vertex_attrib_array(1L)

  return(c(vao = vao, vbo = vbo))
}
