" complexity.vim
" Gary Bernhardt (http://blog.extracheese.org)
"
" This will add cyclomatic complexity annotations to your source code. It is
" no longer wrong (as previous versions were!)

if !has('signs')
    finish
endif
if !has('python')
    finish
endif
python << endpython
import vim
%(python_source)s
endpython

hi SignColumn guifg=fg guibg=bg
hi low_complexity guifg=#004400 guibg=#004400 ctermfg=2 ctermbg=2
hi medium_complexity guifg=#bbbb00 guibg=#bbbb00 ctermfg=3 ctermbg=3
hi high_complexity guifg=#ff2222 guibg=#ff2222 ctermfg=1 ctermbg=1
sign define low_complexity text=XX texthl=low_complexity
sign define medium_complexity text=XX texthl=medium_complexity
sign define high_complexity text=XX texthl=high_complexity

autocmd! BufReadPost,BufWritePost,FileReadPost,FileWritePost *.py call ShowComplexity()

function! s:ClearSigns()
   sign unplace *
endfunction

function! s:ShowComplexity()
    python << END
show_complexity()
END
" no idea why it is needed to update colors each time
" to actually see the colors
hi low_complexity guifg=#004400 guibg=#004400 ctermfg=2 ctermbg=2
hi medium_complexity guifg=#bbbb00 guibg=#bbbb00 ctermfg=3 ctermbg=3
hi high_complexity guifg=#ff2222 guibg=#ff2222 ctermfg=1 ctermbg=1
endfunction

function! s:ToggleComplexity()
    if exists("g:complexity_is_displaying") && g:complexity_is_displaying
        call s:ClearSigns()
        let g:complexity_is_displaying = 0
    else
        call s:ShowComplexity()
        let g:complexity_is_displaying = 1
    endif
endfunction

command! Complexity call s:ToggleComplexity()
