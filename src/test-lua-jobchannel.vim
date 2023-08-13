lua <<EOF
job = vim.fn.job_start('echo Hi',
        vim.dict {exit_cb = function(job, status) print("Lua callback:", vim.type(job), status) end })
EOF

echom typename(luaeval('job'))
echom luaeval('job')
lua job = nil

" exe "sleep " .. rand() % 5
call getchar()
quit
