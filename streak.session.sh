session_root "~/Projects/eat40005/streak"

if initialize_session "streak"; then
  new_window "code"
  run_cmd "v ."

  new_window "shell"
  run_cmd "alias build='./build.sh'"
  run_cmd "git pull"
  split_h
  run_cmd "c todo"
  split_v
  run_cmd "cd ~; clear"
  select_pane 1
  
fi
finalize_and_go_to_session
