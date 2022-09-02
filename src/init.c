#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>


/* Section generated by pkgbuild, do not edit */
/* .Call calls */
extern SEXP gl_attach_shader_(SEXP, SEXP);
extern SEXP gl_bind_buffer_(SEXP, SEXP);
extern SEXP gl_bind_texture_(SEXP, SEXP);
extern SEXP gl_bind_vertex_array_(SEXP);
extern SEXP gl_buffer_data_(SEXP, SEXP, SEXP);
extern SEXP gl_clear_(SEXP);
extern SEXP gl_clear_color_(SEXP, SEXP, SEXP, SEXP);
extern SEXP gl_compile_shader_(SEXP);
extern SEXP gl_create_program_();
extern SEXP gl_create_shader_(SEXP);
extern SEXP gl_delete_buffers_(SEXP);
extern SEXP gl_delete_program_(SEXP);
extern SEXP gl_delete_shader_(SEXP);
extern SEXP gl_delete_vertex_arrays_(SEXP);
extern SEXP gl_draw_arrays_(SEXP, SEXP, SEXP);
extern SEXP gl_draw_elements_(SEXP, SEXP, SEXP, SEXP);
extern SEXP gl_enable_vertex_attrib_array_(SEXP);
extern SEXP gl_gen_buffers_(SEXP);
extern SEXP gl_gen_textures_(SEXP);
extern SEXP gl_gen_vertex_arrays_(SEXP);
extern SEXP gl_generate_mipmap_(SEXP);
extern SEXP gl_get_program_info_log_(SEXP);
extern SEXP gl_get_program_iv_(SEXP, SEXP);
extern SEXP gl_get_shader_info_log_(SEXP);
extern SEXP gl_get_shader_iv_(SEXP, SEXP);
extern SEXP gl_get_uniform_location_(SEXP, SEXP);
extern SEXP gl_is_shader_(SEXP);
extern SEXP gl_link_program_(SEXP);
extern SEXP gl_polygon_mode_(SEXP, SEXP);
extern SEXP gl_shader_source_(SEXP, SEXP, SEXP, SEXP);
extern SEXP gl_tex_image_2d_(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP gl_tex_parameter_i_(SEXP, SEXP, SEXP);
extern SEXP gl_uniform_f_(SEXP, SEXP);
extern SEXP gl_uniform_i_(SEXP, SEXP);
extern SEXP gl_uniform_ui_(SEXP, SEXP);
extern SEXP gl_use_program_(SEXP);
extern SEXP gl_vertex_attrib_pointer_(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP gl_viewport_(SEXP, SEXP, SEXP, SEXP);
extern SEXP glad_load_gl_();
extern SEXP glfw_create_window_(SEXP, SEXP, SEXP);
extern SEXP glfw_destroy_window_(SEXP);
extern SEXP glfw_get_error_();
extern SEXP glfw_get_key_(SEXP, SEXP);
extern SEXP glfw_get_time_();
extern SEXP glfw_get_version_();
extern SEXP glfw_get_version_string_();
extern SEXP glfw_get_window_size_(SEXP);
extern SEXP glfw_init_();
extern SEXP glfw_make_context_current_(SEXP);
extern SEXP glfw_poll_events_();
extern SEXP glfw_set_error_callback_(SEXP);
extern SEXP glfw_set_framebuffer_size_callback_(SEXP, SEXP);
extern SEXP glfw_set_time_(SEXP);
extern SEXP glfw_set_window_aspect_ratio_(SEXP, SEXP, SEXP);
extern SEXP glfw_set_window_should_close_(SEXP, SEXP);
extern SEXP glfw_set_window_size_(SEXP, SEXP, SEXP);
extern SEXP glfw_swap_buffers_(SEXP);
extern SEXP glfw_terminate_();
extern SEXP glfw_window_hint_(SEXP, SEXP);
extern SEXP glfw_window_should_close_(SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"gl_attach_shader_",                   (DL_FUNC) &gl_attach_shader_,                   2},
    {"gl_bind_buffer_",                     (DL_FUNC) &gl_bind_buffer_,                     2},
    {"gl_bind_texture_",                    (DL_FUNC) &gl_bind_texture_,                    2},
    {"gl_bind_vertex_array_",               (DL_FUNC) &gl_bind_vertex_array_,               1},
    {"gl_buffer_data_",                     (DL_FUNC) &gl_buffer_data_,                     3},
    {"gl_clear_",                           (DL_FUNC) &gl_clear_,                           1},
    {"gl_clear_color_",                     (DL_FUNC) &gl_clear_color_,                     4},
    {"gl_compile_shader_",                  (DL_FUNC) &gl_compile_shader_,                  1},
    {"gl_create_program_",                  (DL_FUNC) &gl_create_program_,                  0},
    {"gl_create_shader_",                   (DL_FUNC) &gl_create_shader_,                   1},
    {"gl_delete_buffers_",                  (DL_FUNC) &gl_delete_buffers_,                  1},
    {"gl_delete_program_",                  (DL_FUNC) &gl_delete_program_,                  1},
    {"gl_delete_shader_",                   (DL_FUNC) &gl_delete_shader_,                   1},
    {"gl_delete_vertex_arrays_",            (DL_FUNC) &gl_delete_vertex_arrays_,            1},
    {"gl_draw_arrays_",                     (DL_FUNC) &gl_draw_arrays_,                     3},
    {"gl_draw_elements_",                   (DL_FUNC) &gl_draw_elements_,                   4},
    {"gl_enable_vertex_attrib_array_",      (DL_FUNC) &gl_enable_vertex_attrib_array_,      1},
    {"gl_gen_buffers_",                     (DL_FUNC) &gl_gen_buffers_,                     1},
    {"gl_gen_textures_",                    (DL_FUNC) &gl_gen_textures_,                    1},
    {"gl_gen_vertex_arrays_",               (DL_FUNC) &gl_gen_vertex_arrays_,               1},
    {"gl_generate_mipmap_",                 (DL_FUNC) &gl_generate_mipmap_,                 1},
    {"gl_get_program_info_log_",            (DL_FUNC) &gl_get_program_info_log_,            1},
    {"gl_get_program_iv_",                  (DL_FUNC) &gl_get_program_iv_,                  2},
    {"gl_get_shader_info_log_",             (DL_FUNC) &gl_get_shader_info_log_,             1},
    {"gl_get_shader_iv_",                   (DL_FUNC) &gl_get_shader_iv_,                   2},
    {"gl_get_uniform_location_",            (DL_FUNC) &gl_get_uniform_location_,            2},
    {"gl_is_shader_",                       (DL_FUNC) &gl_is_shader_,                       1},
    {"gl_link_program_",                    (DL_FUNC) &gl_link_program_,                    1},
    {"gl_polygon_mode_",                    (DL_FUNC) &gl_polygon_mode_,                    2},
    {"gl_shader_source_",                   (DL_FUNC) &gl_shader_source_,                   4},
    {"gl_tex_image_2d_",                    (DL_FUNC) &gl_tex_image_2d_,                    9},
    {"gl_tex_parameter_i_",                 (DL_FUNC) &gl_tex_parameter_i_,                 3},
    {"gl_uniform_f_",                       (DL_FUNC) &gl_uniform_f_,                       2},
    {"gl_uniform_i_",                       (DL_FUNC) &gl_uniform_i_,                       2},
    {"gl_uniform_ui_",                      (DL_FUNC) &gl_uniform_ui_,                      2},
    {"gl_use_program_",                     (DL_FUNC) &gl_use_program_,                     1},
    {"gl_vertex_attrib_pointer_",           (DL_FUNC) &gl_vertex_attrib_pointer_,           6},
    {"gl_viewport_",                        (DL_FUNC) &gl_viewport_,                        4},
    {"glad_load_gl_",                       (DL_FUNC) &glad_load_gl_,                       0},
    {"glfw_create_window_",                 (DL_FUNC) &glfw_create_window_,                 3},
    {"glfw_destroy_window_",                (DL_FUNC) &glfw_destroy_window_,                1},
    {"glfw_get_error_",                     (DL_FUNC) &glfw_get_error_,                     0},
    {"glfw_get_key_",                       (DL_FUNC) &glfw_get_key_,                       2},
    {"glfw_get_time_",                      (DL_FUNC) &glfw_get_time_,                      0},
    {"glfw_get_version_",                   (DL_FUNC) &glfw_get_version_,                   0},
    {"glfw_get_version_string_",            (DL_FUNC) &glfw_get_version_string_,            0},
    {"glfw_get_window_size_",               (DL_FUNC) &glfw_get_window_size_,               1},
    {"glfw_init_",                          (DL_FUNC) &glfw_init_,                          0},
    {"glfw_make_context_current_",          (DL_FUNC) &glfw_make_context_current_,          1},
    {"glfw_poll_events_",                   (DL_FUNC) &glfw_poll_events_,                   0},
    {"glfw_set_error_callback_",            (DL_FUNC) &glfw_set_error_callback_,            1},
    {"glfw_set_framebuffer_size_callback_", (DL_FUNC) &glfw_set_framebuffer_size_callback_, 2},
    {"glfw_set_time_",                      (DL_FUNC) &glfw_set_time_,                      1},
    {"glfw_set_window_aspect_ratio_",       (DL_FUNC) &glfw_set_window_aspect_ratio_,       3},
    {"glfw_set_window_should_close_",       (DL_FUNC) &glfw_set_window_should_close_,       2},
    {"glfw_set_window_size_",               (DL_FUNC) &glfw_set_window_size_,               3},
    {"glfw_swap_buffers_",                  (DL_FUNC) &glfw_swap_buffers_,                  1},
    {"glfw_terminate_",                     (DL_FUNC) &glfw_terminate_,                     0},
    {"glfw_window_hint_",                   (DL_FUNC) &glfw_window_hint_,                   2},
    {"glfw_window_should_close_",           (DL_FUNC) &glfw_window_should_close_,           1},
    {NULL, NULL, 0}
};
/* End section generated by pkgbuild */

void R_init_glfw(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
