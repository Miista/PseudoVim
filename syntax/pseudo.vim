" Vim syntax file
" Language: Pseudo
" Maintainer: Søren Palmund
" Latest Revision: 23 March 2017

if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "Pseudo"

syn keyword pseudoConditional if then else endif

" Syntax Pairs
syntax keyword pseudoRepeat do while endwhile
syntax keyword pseudoKeyword begin end

syntax keyword pseudoKeyword return lock
syntax keyword pseudoKeyword for endfor

syntax keyword pseudoFunction proc fun
syntax keyword pseudoFunction atomic

syntax match pseudoOperator "\v\:\="
syntax match pseudoOperator "\v\="
syntax match pseudoOperator "\v-"
syntax match pseudoOperator "\v\+"
syntax match pseudoOperator "\v\=\:"

syntax match pseudoOperator "\v\:$"

syntax match pseudoNumber "\v[0-9]"

syntax region pseudoString start=/\v"/ skip=/\v\\./ end=/\v"/

highlight link pseudoConditional Conditional
highlight link pseudoRepeat Repeat
highlight link pseudoKeyword Keyword
highlight link pseudoFunction Structure
highlight link pseudoOperator Operator
highlight link pseudoNumber Number
highlight link pseudoString String
