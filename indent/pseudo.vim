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
  " Are we at the head of the file?
  if a:lnum == 0
    return 0
  endif

  let lt = GetLineType(a:lnum)
  let prev = a:lnum - 1
  if g:Start == lt
    return SyntheticIndentLevel(prev)
  elseif g:End == lt
    return SyntheticIndentLevel(prev) - 1
  elseif g:StartAndEnd == lt
    return SyntheticIndentLevel(prev) - 1
  elseif g:Normal == lt
    " Get the line type of the parent line
    let lt = GetLineType(prev)
    if g:Normal == lt
      echom "no"
      return SyntheticIndentLevel(prev)
    elseif g:Start == lt
      echom "j"
      return 1 + IndentLevel(prev)
    elseif g:End == lt
      return IndentLevel(prev)
    elseif g:StartAndEnd == lt
      return 1 + IndentLevel(prev)
    endif
  endif
  return 1
endfunction

" Returns the indent level imposed by the line, if any.
" If the line imposes a new scope (or indent level),
" that level is returned.
" If the line is a normal one, its indent level is returned.
function! GetScopeIndentLevel(lnum)
  " Have we reached the top of the file?
  if a:lnum < 0
    return 0
  endif

  let prev = a:lnum - 1
  let lt = GetLineType(prev)
  if g:Normal == lt
    return IndentLevel(prev)
  elseif g:Start == lt
    return 1 + IndentLevel(prev)
  elseif g:StartAndEnd == lt
    return 1 + IndentLevel(prev)
  endif
endfunction
" Returns the indent level of the surrounding block.
" That is, if the line does not start nor end a block,
" its indent level should 
" If the line is not surrounded by a block,
" 0 (zero) is returned.
function! GetIndentOfSurroundingBlock(lnum)
  if a:lnum < 0
    return 0
  endif

  if BeginsBlock(a:lnum-1)
    return 1 + IndentLevel(a:lnum-1)
  endif
  return SyntheticIndentLevel(a:lnum-1) "GetIndentOfSurroundingBlock(a:lnum-1)
endfunction

" Returns the indent level started introduced on the given line.
" If no block is started on that line,
" the previous lines are searched.
function! GetIndentStartedByBlock(lnum)
  " Have we gone beyond the beginning of the file?
  if a:lnum < 0
    return '0'
  endif
  let lt = GetLineType(a:lnum)
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

" Returns a number indicating the supposed level of indentation for the given
" line.
" The supposed level is used for when a line has no visual indent level,
" but semantically it needs to have one.
" This is most often the case when a line break separates two statements
" of the same indent level.
" See example below.
"
" proc SomeProc:
" --v := 1
" --      <---- This line has indent level = 0,
"               but synthetic indent level = 1
" --a := v
function! SyntheticIndentLevel(lnum)
  if IsBlank(a:lnum)
    return SyntheticIndentLevel(a:lnum - 1)
  else
    return IndentLevel(a:lnum)
  endif
endfunction

" Returns true if the line is blank.
function! IsBlank(lnum)
  return getline(a:lnum) =~? '\v^\s*$'
endfunction

let g:StartAndEnd = -1
let g:Start       = -2
let g:End         = -3
let g:Normal      = -4

" Returns a number indicating the line type.
" A line either starts a block, ends a block,
" or does *both*.
" If it does neither, then it's a normal line
" and we don't care!
function! GetLineType(lnum)
  let line = getline(a:lnum)
  if line =~? '\v.*else$'
    return g:StartAndEnd
  elseif line =~? '\v^\s*(else|end(if|while)?)$'
    return g:End
  elseif line =~? '\v.*\:$'
    return g:Start
  else
    return g:Normal
  endif
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
