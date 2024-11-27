/* option.c */
void set_init_1(int clean_arg);
void set_fencs_unicode(void);
void set_string_default(char *name, char_u *val);
void set_number_default(char *name, long val);
void set_local_options_default(win_T *wp, int do_buffer);
void free_all_options(void);
void set_init_2(void);
void set_init_3(void);
void set_helplang_default(char_u *lang);
void set_title_defaults(void);
void ex_set(exarg_T *eap);
int do_set(char_u *arg_start, int opt_flags);
void did_set_option(int opt_idx, int opt_flags, int new_value, int value_checked);
int string_to_key(char_u *arg, int multi_byte);
void did_set_title(void);
void set_options_bin(int oldval, int newval, int opt_flags);
void check_options(void);
int get_term_opt_idx(char_u **p);
int set_term_option_alloced(char_u **p);
int was_set_insecurely(char_u *opt, int opt_flags);
void redraw_titles(void);
int valid_name(char_u *val, char *allowed);
void set_option_sctx_idx(int opt_idx, int opt_flags, sctx_T script_ctx);
sctx_T *get_option_sctx(char *name);
void set_term_option_sctx_idx(char *name, int opt_idx);
char *did_set_arabic(optset_T *args);
char *did_set_autochdir(optset_T *args);
char *did_set_ballooneval(optset_T *args);
char *did_set_balloonevalterm(optset_T *args);
char *did_set_binary(optset_T *args);
char *did_set_buflisted(optset_T *args);
char *did_set_cmdheight(optset_T *args);
char *did_set_compatible(optset_T *args);
char *did_set_conceallevel(optset_T *args);
char *did_set_diff(optset_T *args);
char *did_set_eof_eol_fixeol_bomb(optset_T *args);
char *did_set_equalalways(optset_T *args);
char *did_set_foldcolumn(optset_T *args);
char *did_set_foldlevel(optset_T *args);
char *did_set_foldminlines(optset_T *args);
char *did_set_foldnestmax(optset_T *args);
char *did_set_hlsearch(optset_T *args);
char *did_set_ignorecase(optset_T *args);
char *did_set_imdisable(optset_T *args);
char *did_set_iminsert(optset_T *args);
char *did_set_imsearch(optset_T *args);
char *did_set_imstyle(optset_T *args);
char *did_set_insertmode(optset_T *args);
char *did_set_langnoremap(optset_T *args);
char *did_set_langremap(optset_T *args);
char *did_set_laststatus(optset_T *args);
char *did_set_linespace(optset_T *args);
char *did_set_lisp(optset_T *args);
char *did_set_maxcombine(optset_T *args);
char *did_set_modifiable(optset_T *args);
char *did_set_modified(optset_T *args);
char *did_set_mousehide(optset_T *args);
char *did_set_msghistory(optset_T *args);
char *did_set_number_relativenumber(optset_T *args);
char *did_set_numberwidth(optset_T *args);
char *did_set_paste(optset_T *args);
char *did_set_previewwindow(optset_T *args);
char *did_set_pyxversion(optset_T *args);
char *did_set_readonly(optset_T *args);
char *did_set_scrollbind(optset_T *args);
char *did_set_shellslash(optset_T *args);
char *did_set_shiftwidth_tabstop(optset_T *args);
char *did_set_showtabline(optset_T *args);
char *did_set_smoothscroll(optset_T *args);
char *did_set_spell(optset_T *args);
char *did_set_swapfile(optset_T *args);
char *did_set_tabclose(optset_T *args);
char *did_set_termguicolors(optset_T *args);
char *did_set_termwinscroll(optset_T *args);
char *did_set_terse(optset_T *args);
char *did_set_textauto(optset_T *args);
char *did_set_textmode(optset_T *args);
char *did_set_textwidth(optset_T *args);
char *did_set_title_icon(optset_T *args);
char *did_set_titlelen(optset_T *args);
char *did_set_undofile(optset_T *args);
char *did_set_undolevels(optset_T *args);
char *did_set_updatecount(optset_T *args);
char *did_set_weirdinvert(optset_T *args);
char *did_set_wildchar(optset_T *args);
char *did_set_window(optset_T *args);
char *did_set_winheight_helpheight(optset_T *args);
char *did_set_winminheight(optset_T *args);
char *did_set_winminwidth(optset_T *args);
char *did_set_winwidth(optset_T *args);
char *did_set_wrap(optset_T *args);
void check_redraw(long_u flags);
int findoption(char_u *arg);
getoption_T get_option_value(char_u *name, long *numval, char_u **stringval, int *flagsp, int scope);
int get_option_value_strict(char_u *name, long *numval, char_u **stringval, int opt_type, void *from);
char_u *option_iter_next(void **option, int opt_type);
long_u get_option_flags(int opt_idx);
void set_option_flag(int opt_idx, long_u flag);
int is_global_option(int opt_idx);
int is_global_local_option(int opt_idx);
int is_window_local_option(int opt_idx);
int is_hidden_option(int opt_idx);
int is_crypt_key_option(int opt_idx);
char *set_option_value(char_u *name, long number, char_u *string, int opt_flags);
void set_option_value_give_err(char_u *name, long number, char_u *string, int opt_flags);
char_u *get_term_code(char_u *tname);
char_u *get_highlight_default(void);
char_u *get_encoding_default(void);
int is_option_allocated(char *name);
int makeset(FILE *fd, int opt_flags, int local_only);
int makefoldset(FILE *fd);
void clear_termoptions(void);
void free_termoptions(void);
void free_one_termoption(char_u *var);
void set_term_defaults(void);
int istermoption_idx(int opt_idx);
void unset_global_local_option(char_u *name, void *from);
char_u *get_option_varp_scope(int opt_idx, int scope);
char_u *get_option_var(int opt_idx);
char_u *get_option_fullname(int opt_idx);
opt_did_set_cb_T get_option_did_set_cb(int opt_idx);
char_u *get_equalprg(void);
char_u *get_findfunc(void);
void win_copy_options(win_T *wp_from, win_T *wp_to);
void after_copy_winopt(win_T *wp);
void copy_winopt(winopt_T *from, winopt_T *to);
void clear_winopt(winopt_T *wop);
void buf_copy_options(buf_T *buf, int flags);
void reset_modifiable(void);
void set_iminsert_global(void);
void set_imsearch_global(void);
void set_context_in_set_cmd(expand_T *xp, char_u *arg, int opt_flags);
int ExpandSettings(expand_T *xp, regmatch_T *regmatch, char_u *fuzzystr, int *numMatches, char_u ***matches, int can_fuzzy);
int ExpandOldSetting(int *numMatches, char_u ***matches);
int ExpandStringSetting(expand_T *xp, regmatch_T *regmatch, int *numMatches, char_u ***matches);
int ExpandSettingSubtract(expand_T *xp, regmatch_T *regmatch, int *numMatches, char_u ***matches);
int shortmess(int x);
void vimrc_found(char_u *fname, char_u *envname);
void change_compatible(int on);
int option_was_set(char_u *name);
int reset_option_was_set(char_u *name);
int can_bs(int what);
long get_scrolloff_value(void);
long get_sidescrolloff_value(void);
unsigned int get_bkc_flags(buf_T *buf);
char_u *get_flp_value(buf_T *buf);
unsigned int get_ve_flags(void);
char_u *get_showbreak_value(win_T *win);
dict_T *get_winbuf_options(int bufopt);
int fill_culopt_flags(char_u *val, win_T *wp);
int magic_isset(void);
int option_set_callback_func(char_u *optval, callback_T *optcb);
/* vim: set ft=c : */
