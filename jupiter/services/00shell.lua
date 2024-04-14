-- Any code in this file will be ran on boot, in parallel with all the other files in this folder.

-- create logger
local logger = require("core.logger")
logger.sender = "shell starter"

-- start shell and tell it to reinitialize
logger.info("Starting shell")
_G.shellreinit = true;
shell.run("/jupiter/programs/shell.lua")