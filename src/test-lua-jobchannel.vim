function VimCallback1(job, status)
  echo typename(a:job) .. ", " .. a:status
  echo "VimCallback1 done"
endfunction

lua <<EOF

--[[
local LuaCallback1 = function(job, status)
  print(vim.type(job), status)
  print("Lua callback 1 done")
end
--]]

--[[
local job = vim.fn.job_start('echo Hi',
               vim.dict {exit_cb = 'VimCallback1'})
--]]

--[[
vim.fn.job_start('echo Hi',
        vim.dict {exit_cb = 'VimCallback1'})
--]]

vim.fn.job_start('echo Hi')

EOF
