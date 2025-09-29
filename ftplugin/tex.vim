set spelllang=en_au
set spell

"vimtex inverse regain focus"
function! s:TexFocusVim() abort
  " Replace `TERMINAL` with the name of your terminal application
  " Example: execute "!open -a iTerm"  
  " Example: execute "!open -a Alacritty"
  silent execute "!open -a WezTerm"
  redraw!
endfunction

augroup vimtex_event_focus
  au!
  au User VimtexEventViewReverse call s:TexFocusVim()
augroup END

" let g:vimtex_compiler_latexmk = {
" \ 'options': ['-pdf', '-shell-escape', '-interaction=nonstopmode', '-synctex=1'],
" \}
"
