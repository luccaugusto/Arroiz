"====================================
"			Functions
"===================================
function! BeginC()
	normal! i#include <stdlib.h>
	normal! o#include <stdio.h>
	normal! o
	normal! oint
	normal! omain()
	normal! o{
	normal! o
	normal! oreturn 0;
	normal! o}
	normal! 2k
endfunction

function! BeginJava()
	normal! ipublic class <++> {
	normal! o
	normal! opublic static void main(String[] args) {
	normal! o
	normal! o}
	normal! o}
endfunction

function! BeginMS()
	normal! i.TL
	normal! o<++>
	normal! o.AU
	normal! oLucca Augusto (lucca@luccaaugusto.xyz)
endfunction

function! BeginTex()
	normal! i\documentclass[12pt]{article}
	normal! o\usepackage[utf8]{inputenc}
	normal! o\usepackage{graphicx,url}
	normal! o\title{<++>}
	normal! o\author{Lucca Augusto\\(lucca@luccaaugusto.xyz)}
	normal! o\date{} %empty date so it doesn't show
	normal! o\begin{document}
	normal! o\maketitle
	normal! o
	normal! o\end{document}
	normal! 6k
	normal! $ci{
endfunction

function! BreakFunctionCallInLines()
"TODO break this
"break_stuff(int stuff1, int stuff2, int stuff3, int stuff4);

"into this
"break_stuff(
"	int stuff1,
"	int stuff2,
"	int stuff3,
"	int stuff4
");
endfunction

"TODO make it work and bind to x
function! DeleteSurroundingChar()
	if @- == '{'
		normal! f}vd
	endif
	if @- == '('
		normal! f)vd
	endif
	if @- == '['
		normal! f]vd
	endif
endfunction

" Find out current buffer's size and output it.
function! FileSize()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
    let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1000)
    let mbytes = kbytes / 1000
  endif
  if bytes <= 0
    return '0'
  endif
  if (exists('mbytes'))
    return mbytes . 'MB '
  elseif (exists('kbytes'))
    return kbytes . 'KB '
  else
    return bytes . 'B '
  endif
endfunction
