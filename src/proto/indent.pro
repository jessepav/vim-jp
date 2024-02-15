/* indent.c */
int tabstop_set(char_u *var, int **array);
int tabstop_padding(colnr_T col, int ts_arg, int *vts);
int tabstop_at(colnr_T col, int ts, int *vts);
colnr_T tabstop_start(colnr_T col, int ts, int *vts);
void tabstop_fromto(colnr_T start_col, colnr_T end_col, int ts_arg, int *vts, int *ntabs, int *nspcs);
int *tabstop_copy(int *oldts);
int tabstop_count(int *ts);
int tabstop_first(int *ts);
long get_sw_value(buf_T *buf);
long get_sw_value_indent(buf_T *buf);
long get_sw_value_col(buf_T *buf, colnr_T col);
long get_sts_value(void);
int get_indent(void);
int get_indent_lnum(linenr_T lnum);
int get_indent_buf(buf_T *buf, linenr_T lnum);
int get_indent_str(char_u *ptr, int ts, int no_ts);
int get_indent_str_vtab(char_u *ptr, int ts, int *vts, int no_ts);
int set_indent(int size, int flags);
int get_number_indent(linenr_T lnum);
int briopt_check(win_T *wp);
int get_breakindent_win(win_T *wp, char_u *line);
int inindent(int extra);
void op_reindent(oparg_T *oap, int (*how)(void));
int preprocs_left(void);
int may_do_si(void);
void ins_try_si(int c);
void change_indent(int type, int amount, int round, int replaced, int call_changed_bytes);
int copy_indent(int size, char_u *src);
void ex_retab(exarg_T *eap);
int get_expr_indent(void);
int get_lisp_indent(void);
void fixthisline(int (*get_the_indent)(void));
int use_indentexpr_for_lisp(void);
void fix_indent(void);
void f_indent(typval_T *argvars, typval_T *rettv);
void f_lispindent(typval_T *argvars, typval_T *rettv);
/* vim: set ft=c : */
