if exists("b:current_syntax")
  finish
endif

syntax keyword pseudoConditional if else endif

syntax keyword pseudoRepeat do while endwhile

syntax keyword pseudoKeyword return lock
syntax keyword pseudoKeyword for endfor

syntax keyword pseudoFunction proc fun

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
highlight link pseudoFunction Function
highlight link pseudoOperator Operator
highlight link pseudoNumber Number
highlight link pseudoString String

let b:current_syntax = "Pseudo"