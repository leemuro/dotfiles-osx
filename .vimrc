set nocompatible
call pathogen#runtime_append_all_bundles()

" colors and font
:set t_Co=256
syn on
colorscheme solarized
set gfn=DejaVu\ Sans\ Mono:h12

" Sane editing
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set showmatch
set hlsearch
set hidden

" Store temporary files in a central spot
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" maps that should be defaults
let mapleader=","
map 0 ^

" setup split navigation/sizing
set winwidth=84
set winheight=5
set winminheight=5
set winheight=999
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" fix paste indenting
set pastetoggle=<F2>

" testing setup
function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    if filereadable("script/test")
        exec "!script/test " . a:filename
    end
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.spec.js\|.spec.coffee\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize ' . line('$')
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)

" test commands
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunTests()<cr>

" new file commands
map <leader>nv :e assets/js/app/views/
map <leader>nm :e assets/js/app/models/
map <leader>ns :e assets/css/app/

" goto file commands
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>gv :CommandTFlush<cr>\|:CommandT assets/js/app/views/<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT assets/js/app/models/<cr>
