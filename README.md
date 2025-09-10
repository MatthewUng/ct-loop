# ct-loop
nvim plugin for speeding up code/test iterations 

## Example set-up

Example .vimrc
```
command! -nargs=+ AddTestCommand :lua require("ct-loop").set_command(<q-args>)
noremap <leader>sa :AddTestCommand<space>
noremap <leader>ss :lua require("ct-loop").run_command()<cr>
```

A test command can be added with `<leader>sa ./run_test`.  

`<leader>ss` will open up a companion terminal in a vertical split and run the previously specified command.
If no comand has been specified, `<leader>ss` will just open the companion terminal.
