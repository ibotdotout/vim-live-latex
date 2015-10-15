augroup live_latex
  autocmd!
  autocmd BufWritePost *.tex call LiveLatexBuild(expand("%:p"))
augroup END

function LiveLatexBuild(target)
  "BuildLatex and feedback in QuickFix
  if empty($TMUX) || !executable('tmux')
    "Require vim run in tmux
    return 0
  endif

  if exists('g:live_latex_compiler')
    "set latex compiler
    let s:compiler = g:live_latex_compiler
  else
    let s:compiler = "pdflatex"
  endif

  cclose
  let pluginname ="vim-live-latex"
  let log = tempname()
  let s:path = matchstr(escape(&rtp, ' '), '[^,]*'.pluginname)
  let cmd = s:path."/plugin/compile ".a:target." ".s:compiler
  " get active session:window of tmux and remove \n
  let tmux_active_window = system("tmux display-message -p '\#S:\#I'")
  let tmux_active_window = substitute(tmux_active_window, "\n", "", "")
  let tmux_current_cmd = "(tmux display-message -p -t ".tmux_active_window." \"\\#{pane_current_command}\" | grep -iq vim)"
  " send key to active tmux
  let tmux_send_key = "tmux send-key -t ".tmux_active_window." "
  let quick_fix_key = "Escape \":cgetfile ".log."\" Enter \":copen\" Enter"
  let failed_key = quick_fix_key." \":LiveLatexEchomFailed ".a:target."\" Enter"
  let done_key = "Escape \":LiveLatexEchomDone".a:target."\" Enter"
  let call_back_done = tmux_send_key.done_key
  let call_back_failed = tmux_send_key.failed_key
  let call_back = "(".tmux_current_cmd." && ".call_back_done.") || (".tmux_current_cmd." && ".call_back_failed.")"
  " cmd that will be run in new tmux deamon window
  let window_id = 999
  if !system("tmux list-windows -F '\#I' | grep -iq ".window_id."; echo $?")
    " if alreay exits job kill it.
    call system("tmux kill-window -t ".window_id)
  endif
  let cmd_in_tmux = cmd." > ".log." && ".call_back
  execute "silent !tmux new-window -d -t ".window_id." '".cmd_in_tmux."'"
  redraw!
endfunction

command -nargs=1 LiveLatexEchomFailed execute ":echom 'Failure: ".<q-args>."'"
command -nargs=1 LiveLatexEchomDone execute ":echom 'Success: ".<q-args>."'"
