setlocal shiftwidth=2
setlocal tabstop=2
setlocal indentexpr=GetPseudoIndentValue(v:lnum)
setlocal indentkeys+=~end,<:>

" Returns a number indicating the indent value for the specific line.
function! GetPseudoIndentValue(lnum)
  return &shiftwidth * GetPseudoIndentLevel(a:lnum)
endfunction

" Returns a number indicating the indent level to be used for the line.
" Note that this number must be multiplied by &shiftwidth.
function! GetPseudoIndentLevel(lnum)
  let prevLine = getline(a:lnum-1)
  if BeginsBlock(a:lnum)
    return GetIndentStartedByBlock(a:lnum) - 1
  elseif EndsBlock(a:lnum)
    return GetIndentStartedByBlock(a:lnum) - 1
  else
    return GetIndentStartedByBlock(a:lnum-1)
  endif

  return '0'
endfunction

" Returns the indent level started introduced on the given line.
" If no block is started on that line,
" the previous lines are searched.
function! GetIndentStartedByBlock(lnum)
  " Have we gone beyond the beginning of the file?
  if a:lnum < 0
    return '0'
  endif
  if BeginsBlock(a:lnum)
    return 1 + IndentLevel(a:lnum)
  else
    return GetIndentStartedByBlock(a:lnum-1)
  endif
endfunction

" Returns a number indicating the level of indentation for the given line.
" Note that this number should be multiplied by &shiftwidth
" in order to set the correct indentation value.
function! IndentLevel(lnum)
  return indent(a:lnum) / &shiftwidth
endfunction

" Returns true if the line is blank.
function! IsBlank(lnum)
  return getline(a:lnum) =~? '\v^\s*$'
endfunction

" Returns true if the line begins a block.
" A block has the following syntax:
" <statement> ... :
"   ...           ^
" end             |
"
" Note, the colon marks the beginning of a new block.
function! BeginsBlock(lnum)
  return getline(a:lnum) =~? '\v.*\:$'
endfunction

" Returns true if the line ends a block.
" Blocks are ended by >end< optionally followed by a keyword.
function! EndsBlock(lnum)
  return getline(a:lnum) =~? '\v^\s*end(if|while)?$'
endfunction

" Block Type {{{

let g:Generic = 0
let g:If      = 1
let g:Do      = 2
let g:For     = 3
let g:Lock    = 4
let g:Proc    = 5

" Returns a Number indicating the type of the block.
" If the line does not indicate any block,
" the previous lines are searched.
function! GetBlockType(lnum)
  " If the line number is out of range,
  " return a generic block type.
  if a:lnum < 0
    return g:Generic
  endif

  let line = getline(a:lnum)
  if StartsAndEndsWith(line, "if")
    return g:If
  elseif StartsAndEndsWith(line, "for")
    return g:For
  elseif StartsAndEndsWith(line, "lock")
    return g:Lock
  else
    return GetBlockType(a:lnum-1)
  endif
endfunction

" Returns true if the line starts with 'starts',
" optionally preceeded by any number of spaces.
function! StartsAndEndsWith(line, starts)
  return a:line =~? '\v^\s*'.a:starts.'.*\:$'
endfunction

" }}}

" function! PrevIndentLevel(level, lnum)
"   if BeginsBlock(a:lnum)
"     return IndentLevel(a:lnum)
"   endif
"   if IndentLevel(a:lnum) < a:level
"     return IndentLevel(a:lnum)
"   else
"     return PrevIndentLevel(a:level, a:lnum-1)
"   endif
" endfunction
"
" function! RecursiveIndentLevel(lnum)
"   if a:lnum < 0
"     return 0
"   endif
"   if IndentLevel(a:lnum) = 0
"     return RecursiveIndentLevel(a:lnum-1)
"   endif
" endfunction

" vim: foldmethod=marker
