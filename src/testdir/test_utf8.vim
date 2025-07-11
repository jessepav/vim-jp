" Tests for Unicode manipulations

source util/screendump.vim

" Visual block Insert adjusts for multi-byte char
func Test_visual_block_insert()
  new
  call setline(1, ["aaa", "あああ", "bbb"])
  exe ":norm! gg0l\<C-V>jjIx\<Esc>"
  call assert_equal(['axaa', ' xあああ', 'bxbb'], getline(1, '$'))
  bwipeout!
endfunc

" Test for built-in functions strchars() and strcharlen()
func Test_strchars()
  let inp = ["a", "あいa", "A\u20dd", "A\u20dd\u20dd", "\u20dd"]
  let exp = [[1, 1, 1], [3, 3, 3], [2, 2, 1], [3, 3, 1], [1, 1, 1]]
  for i in range(len(inp))
    call assert_equal(exp[i][0], strchars(inp[i]))
    call assert_equal(exp[i][1], inp[i]->strchars(0))
    call assert_equal(exp[i][2], strchars(inp[i], 1))
  endfor

  let exp = [1, 3, 1, 1, 1]
  for i in range(len(inp))
    call assert_equal(exp[i], inp[i]->strcharlen())
    call assert_equal(exp[i], strcharlen(inp[i]))
  endfor

  call assert_fails("call strchars('abc', 2)", ['E1023:', 'E1023:'])
  call assert_fails("call strchars('abc', -1)", ['E1023:', 'E1023:'])
  call assert_fails("call strchars('abc', {})", ['E728:', 'E728:'])
  call assert_fails("call strchars('abc', [])", ['E745:', 'E745:'])
endfunc

" Test for customlist completion
func CustomComplete1(lead, line, pos)
	return ['あ', 'い']
endfunc

func CustomComplete2(lead, line, pos)
	return ['あたし', 'あたま', 'あたりめ']
endfunc

func CustomComplete3(lead, line, pos)
	return ['Nこ', 'Nん', 'Nぶ']
endfunc

func Test_customlist_completion()
  command -nargs=1 -complete=customlist,CustomComplete1 Test1 echo
  call feedkeys(":Test1 \<C-L>\<C-B>\"\<CR>", 'itx')
  call assert_equal('"Test1 ', getreg(':'))

  command -nargs=1 -complete=customlist,CustomComplete2 Test2 echo
  call feedkeys(":Test2 \<C-L>\<C-B>\"\<CR>", 'itx')
  call assert_equal('"Test2 あた', getreg(':'))

  command -nargs=1 -complete=customlist,CustomComplete3 Test3 echo
  call feedkeys(":Test3 \<C-L>\<C-B>\"\<CR>", 'itx')
  call assert_equal('"Test3 N', getreg(':'))

  call garbagecollect(1)
  delcommand Test1
  delcommand Test2
  delcommand Test3
endfunc

" Yank one 3 byte character and check the mark columns.
func Test_getvcol()
  new
  call setline(1, "x\u2500x")
  normal 0lvy
  call assert_equal(2, col("'["))
  call assert_equal(4, col("']"))
  call assert_equal(2, virtcol("'["))
  call assert_equal(2, virtcol("']"))
endfunc

func Test_list2str_str2list_utf8()
  " One Unicode codepoint
  let s = "\u3042\u3044"
  let l = [0x3042, 0x3044]
  call assert_equal(l, str2list(s, 1))
  call assert_equal(s, list2str(l, 1))
  if &enc ==# 'utf-8'
    call assert_equal(str2list(s), str2list(s, 1))
    call assert_equal(list2str(l), list2str(l, 1))
  endif

  " With composing characters
  let s = "\u304b\u3099\u3044"
  let l = [0x304b, 0x3099, 0x3044]
  call assert_equal(l, str2list(s, 1))
  call assert_equal(s, l->list2str(1))
  if &enc ==# 'utf-8'
    call assert_equal(str2list(s), str2list(s, 1))
    call assert_equal(list2str(l), list2str(l, 1))
  endif

  " Null list is the same as an empty list
  call assert_equal('', list2str([]))
  call assert_equal('', list2str(test_null_list()))
endfunc

func Test_list2str_str2list_latin1()
  " When 'encoding' is not multi-byte can still get utf-8 string.
  " But we need to create the utf-8 string while 'encoding' is utf-8.
  let s = "\u3042\u3044"
  let l = [0x3042, 0x3044]

  let save_encoding = &encoding
  set encoding=latin1

  let lres = str2list(s, 1)
  let sres = list2str(l, 1)
  call assert_equal([65, 66, 67], str2list("ABC"))

  " Try converting a list to a string in latin-1 encoding
  call assert_equal([1, 2, 3], str2list(list2str([1, 2, 3])))

  let &encoding = save_encoding
  call assert_equal(l, lres)
  call assert_equal(s, sres)
endfunc

func Test_screenchar_utf8()
  new

  " 1-cell, with composing characters
  call setline(1, ["ABC\u0308"])
  redraw
  call assert_equal([0x0041], screenchars(1, 1))
  call assert_equal([0x0042], 1->screenchars(2))
  call assert_equal([0x0043, 0x0308], screenchars(1, 3))
  call assert_equal("A", screenstring(1, 1))
  call assert_equal("B", screenstring(1, 2))
  call assert_equal("C\u0308", screenstring(1, 3))

  " 1-cell, with 6 composing characters
  set maxcombine=6
  call setline(1, ["ABC" .. repeat("\u0308", 6)])
  redraw
  call assert_equal([0x0041], screenchars(1, 1))
  call assert_equal([0x0042], 1->screenchars(2))
  " This should not use uninitialized memory
  call assert_equal([0x0043] + repeat([0x0308], 6), screenchars(1, 3))
  call assert_equal("A", screenstring(1, 1))
  call assert_equal("B", screenstring(1, 2))
  call assert_equal("C" .. repeat("\u0308", 6), screenstring(1, 3))
  set maxcombine&

  " 2-cells, with composing characters
  let text = "\u3042\u3044\u3046\u3099"
  call setline(1, text)
  redraw
  call assert_equal([0x3042], screenchars(1, 1))
  call assert_equal([0], screenchars(1, 2))
  call assert_equal([0x3044], screenchars(1, 3))
  call assert_equal([0], screenchars(1, 4))
  call assert_equal([0x3046, 0x3099], screenchars(1, 5))

  call assert_equal("\u3042", screenstring(1, 1))
  call assert_equal("", screenstring(1, 2))
  call assert_equal("\u3044", screenstring(1, 3))
  call assert_equal("", screenstring(1, 4))
  call assert_equal("\u3046\u3099", screenstring(1, 5))

  call assert_equal([text . '  '], ScreenLines(1, 8))

  bwipe!
endfunc

func Test_setcellwidths()
  new
  call setcellwidths([
        \ [0x1330, 0x1330, 2],
        \ [9999, 10000, 1],
        \ [0x1337, 0x1339, 2],
        \])

  call assert_equal(2, strwidth("\u1330"))
  call assert_equal(1, strwidth("\u1336"))
  call assert_equal(2, strwidth("\u1337"))
  call assert_equal(2, strwidth("\u1339"))
  call assert_equal(1, strwidth("\u133a"))

  for aw in ['single', 'double']
    exe 'set ambiwidth=' . aw
    " Handle \u0080 to \u009F as control chars even on MS-Windows.
    set isprint=@,161-255

    call setcellwidths([])
    " Control chars
    call assert_equal(4, strwidth("\u0081"))
    call assert_equal(6, strwidth("\uFEFF"))
    " Ambiguous width chars
    call assert_equal((aw == 'single') ? 1 : 2, strwidth("\u00A1"))
    call assert_equal((aw == 'single') ? 1 : 2, strwidth("\u2010"))

    call setcellwidths([[0x81, 0x81, 1], [0xA1, 0xA1, 1],
                      \ [0x2010, 0x2010, 1], [0xFEFF, 0xFEFF, 1]])
    " Control chars
    call assert_equal(4, strwidth("\u0081"))
    call assert_equal(6, strwidth("\uFEFF"))
    " Ambiguous width chars
    call assert_equal(1, strwidth("\u00A1"))
    call assert_equal(1, strwidth("\u2010"))

    call setcellwidths([[0x81, 0x81, 2], [0xA1, 0xA1, 2],
                      \ [0x2010, 0x2010, 2], [0xFEFF, 0xFEFF, 2]])
    " Control chars
    call assert_equal(4, strwidth("\u0081"))
    call assert_equal(6, strwidth("\uFEFF"))
    " Ambiguous width chars
    call assert_equal(2, strwidth("\u00A1"))
    call assert_equal(2, strwidth("\u2010"))

    call setcellwidths([])
    call setline(1, repeat("\u2103", 10))
    normal! $
    redraw
    call assert_equal((aw == 'single') ? 10 : 19, wincol())
    call setcellwidths([[0x2103, 0x2103, 1]])
    redraw
    call assert_equal(10, wincol())
    call setcellwidths([[0x2103, 0x2103, 2]])
    redraw
    call assert_equal(19, wincol())
    call setcellwidths([])
    redraw
    call assert_equal((aw == 'single') ? 10 : 19, wincol())
  endfor
  set ambiwidth& isprint&

  call setcellwidths([])

  call assert_fails('call setcellwidths(1)', 'E1211:')

  call assert_fails('call setcellwidths([1, 2, 0])', 'E1109:')

  call assert_fails('call setcellwidths([[0x101]])', 'E1110:')
  call assert_fails('call setcellwidths([[0x101, 0x102]])', 'E1110:')
  call assert_fails('call setcellwidths([[0x101, 0x102, 1, 4]])', 'E1110:')
  call assert_fails('call setcellwidths([["a"]])', 'E1110:')

  call assert_fails('call setcellwidths([[0x102, 0x101, 1]])', 'E1111:')

  call assert_fails('call setcellwidths([[0x101, 0x102, 0]])', 'E1112:')
  call assert_fails('call setcellwidths([[0x101, 0x102, 3]])', 'E1112:')

  call assert_fails('call setcellwidths([[0x111, 0x122, 1], [0x115, 0x116, 2]])', 'E1113:')
  call assert_fails('call setcellwidths([[0x111, 0x122, 1], [0x122, 0x123, 2]])', 'E1113:')

  call assert_fails('call setcellwidths([[0x33, 0x44, 2]])', 'E1114:')

  set listchars=tab:--\\u2192 fillchars=stl:\\u2501
  call assert_fails('call setcellwidths([[0x2192, 0x2192, 2]])', 'E834:')
  call assert_fails('call setcellwidths([[0x2501, 0x2501, 2]])', 'E835:')

  call setcellwidths([[0x201c, 0x201d, 1]])
  set listchars& fillchars& ambiwidth=double

  set listchars=nbsp:\\u201c fillchars=vert:\\u201d
  call assert_fails('call setcellwidths([])', 'E834:')
  set listchars&
  call assert_fails('call setcellwidths([])', 'E835:')
  set fillchars&

  call setcellwidths([])
  set ambiwidth&
  bwipe!
endfunc

func Test_getcellwidths()
  call setcellwidths([])
  call assert_equal([], getcellwidths())

  let widthlist = [
        \ [0x1330, 0x1330, 2],
        \ [9999, 10000, 1],
        \ [0x1337, 0x1339, 2],
        \]
  let widthlistsorted = [
        \ [0x1330, 0x1330, 2],
        \ [0x1337, 0x1339, 2],
        \ [9999, 10000, 1],
        \]
  call setcellwidths(widthlist)
  call assert_equal(widthlistsorted, getcellwidths())

  call setcellwidths([])
endfunc

func Test_setcellwidths_dump()
  CheckScreendump
  CheckRunVimInTerminal

  let lines =<< trim END
      call setline(1, "\ue5ffDesktop")
  END
  call writefile(lines, 'XCellwidths', 'D')
  let buf = RunVimInTerminal('-S XCellwidths', {'rows': 6})
  call VerifyScreenDump(buf, 'Test_setcellwidths_dump_1', {})

  call term_sendkeys(buf, ":call setcellwidths([[0xe5ff, 0xe5ff, 2]])\<CR>")
  call VerifyScreenDump(buf, 'Test_setcellwidths_dump_2', {})

  call StopVimInTerminal(buf)
endfunc

" Test setcellwidths() on characters that are not targets of 'ambiwidth'.
func Test_setcellwidths_with_non_ambiwidth_character_dump()
  CheckScreendump
  CheckRunVimInTerminal

  let lines =<< trim END
      call setline(1, [repeat("\u279c", 60), repeat("\u279c", 60)])
      set ambiwidth=single
  END
  call writefile(lines, 'XCellwidthsWithNonAmbiwidthCharacter', 'D')
  let buf = RunVimInTerminal('-S XCellwidthsWithNonAmbiwidthCharacter', {'rows': 6, 'cols': 50})
  call term_sendkeys(buf, ":call setcellwidths([[0x279c, 0x279c, 1]])\<CR>")
  call term_sendkeys(buf, ":echo\<CR>")
  call VerifyScreenDump(buf, 'Test_setcellwidths_with_non_ambiwidth_character_dump_1', {})

  call term_sendkeys(buf, ":call setcellwidths([[0x279c, 0x279c, 2]])\<CR>")
  call term_sendkeys(buf, ":echo\<CR>")
  call VerifyScreenDump(buf, 'Test_setcellwidths_with_non_ambiwidth_character_dump_2', {})

  call StopVimInTerminal(buf)
endfunc

" For some reason this test causes Test_customlist_completion() to fail on CI,
" so run it as the last test.
func Test_zz_ambiwidth_hl_dump()
  CheckScreendump
  CheckRunVimInTerminal

  let lines =<< trim END
      call setline(1, [repeat("\u2103", 60), repeat("\u2103", 60)])
      set ambiwidth=single cursorline list display=lastline
  END
  call writefile(lines, 'XAmbiwidthHl', 'D')
  let buf = RunVimInTerminal('-S XAmbiwidthHl', {'rows': 6, 'cols': 50})
  call VerifyScreenDump(buf, 'Test_ambiwidth_hl_dump_1', {})

  call term_sendkeys(buf, ":set ambiwidth=double\<CR>")
  call term_sendkeys(buf, ":echo\<CR>")
  call VerifyScreenDump(buf, 'Test_ambiwidth_hl_dump_2', {})

  call term_sendkeys(buf, ":set ambiwidth=single\<CR>")
  call term_sendkeys(buf, ":echo\<CR>")
  call VerifyScreenDump(buf, 'Test_ambiwidth_hl_dump_1', {})

  call term_sendkeys(buf, ":call setcellwidths([[0x2103, 0x2103, 2]])\<CR>")
  call term_sendkeys(buf, ":echo\<CR>")
  call VerifyScreenDump(buf, 'Test_ambiwidth_hl_dump_2', {})

  call term_sendkeys(buf, ":call setcellwidths([[0x2103, 0x2103, 1]])\<CR>")
  call term_sendkeys(buf, ":echo\<CR>")
  call VerifyScreenDump(buf, 'Test_ambiwidth_hl_dump_1', {})

  call StopVimInTerminal(buf)
endfunc

func Test_print_overlong()
  " Text with more composing characters than MB_MAXBYTES.
  new
  call setline(1, 'axxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
  s/x/\=nr2char(1629)/g
  print
  bwipe!
endfunc

" vim: shiftwidth=2 sts=2 expandtab
