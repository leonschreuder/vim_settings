" This script calls 'open' in osx or xdg-open under linux. This opens the
" selected folder in a filebrowser and everything else in it's default
" program.

"guard against sourcing the script twice
if exists("g:loaded_nerdtree_extract")
    finish
endif
let g:loaded_nerdtree_extract = 1


call NERDTreeAddMenuItem({
    \ 'text': '(x)tract current zip',
    \ 'shortcut': 'x',
    \ 'callback': 'NERDTreeExtractMenuItem',
    \ 'isActiveCallback': 'NERDTreeExtractIsActive' })


function! NERDTreeExtractIsActive()
  let currentNode = g:NERDTreeFileNode.GetSelected()
  let file = currentNode.path.str()
  if file =~ ".zip\\|.tar\\|.7z"
    return 1
  else
    return 0
  endif
endfunction


function! NERDTreeExtractMenuItem()
  let currentNode = g:NERDTreeFileNode.GetSelected()
  let file = currentNode.path.str({'escape': 1})
  let parentDir = currentNode.path.getParent().str({'escape': 1})

  if file =~ ".zip"
    if exepath('unzip') != ""
      call system("unzip " . file . " -d " . parentDir)
    else
      echo "unzip not installed"
    endif
  elseif file =~ ".7z"
    if exepath('7zz') != ""
      call system("7zz x" . file)
    else
      echo "7zz not installed"
    endif
  else
    if exepath('tar') != ""
      call system("tar -xf " . file . " -C " . parentDir)
    else
      echo "tar not installed"
    endif
  endif
endfunction

