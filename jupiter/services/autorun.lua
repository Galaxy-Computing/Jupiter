-- Any code in this file will be ran on boot, in parallel with all the other files in this folder.
local logger = require("core.logger")
logger.sender = "autorun"
logger.info("Starting shell")
_G.shellreinit = true;
shell.run("/jupiter/programs/shell.lua")