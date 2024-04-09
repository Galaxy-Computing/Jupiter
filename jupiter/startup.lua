function os.version()
    return "Jupiter 1.0"
end
shell.setPath(".:/jupiter/programs"..string.sub(shell.path(),2))
term.clear()
term.setCursorPos(1,1)
ccboot.bootcomplete = true;
if fs.exists("/jupiter/modules") then
    _G.modules = {}
    local evalstring = ""
    for i,v in ipairs(fs.list("/jupiter/modules")) do
        _G.modules[i] = function() shell.run("/jupiter/modules/"..v) end
        evalstring = "_G.modules["..tostring(i).."],"..evalstring
    end 
    evalstring = evalstring.."sleep"
    loadstring("parallel.waitForAll(\"..evalstring..\")")()
end
-- boot is done, hang the kernel
while true do
    sleep(1)
end