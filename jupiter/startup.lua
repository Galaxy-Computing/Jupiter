if not term.isColor() then printError("Jupiter requires an advanced computer.") return end
-- create logger, we have to use lib.core.logger because the require() hasn't been replaced yet
local logger = require("lib.core.logger")
logger.sender = "init"
term.clear()
term.setCursorPos(1,1)
shell.exit()
-- create a new require, changing the package.path
-- this is currently not neccesary, but if init loads anything in the future this will be useful
logger.info("Creating new require for init")
local make_package = dofile("/jupiter/lib/core/require.lua").make
local env = package.loaded
env.shell = shell
env.multishell = multishell
local require, package = make_package(env, "/")
-- os.version()
os.oldversion = os.version
function os.version(platform)
    if platform == 1 then
        return "Jupiter 1.0"
    end
    -- if no platform specified or 0, return CraftOS version for compatibility
    return os.oldversion()
end
logger.ok("Modified os.version()")
-- modify path to override rom
shell.setPath(".:/jupiter/programs"..string.sub(shell.path(),2))
logger.ok("Modified shell path")
logger.info("Loading services")
ccboot.bootcomplete = true;
if fs.exists("/jupiter/services") then
    _G.extensions = {}
    _G.services = {}
    local evalstring = ""
    for i,v in ipairs(fs.list("/jupiter/services")) do
        -- Note that you should not run any other script other than "/jupiter/programs/shell.lua" in a service if you want to use Jupiter require.
        _G.services[i] = function() 
            local make_package = dofile("/jupiter/lib/core/require.lua").make
            local env = _G
            env.shell = shell
            env.multishell = multishell
            env.require, env.package = make_package(env, "/")
            setfenv(1,env)
            dofile("/jupiter/services/"..v) 
        end
        evalstring = "_G.services["..tostring(i).."],"..evalstring
    end 
    evalstring = evalstring.."sleep"
    loadstring("parallel.waitForAll("..evalstring..")")()
else
    logger.error("Could not find /jupiter/services. No program will be started. The kernel will hang now.")
end
-- boot is done, hang the kernel
while true do
    sleep(1)
end