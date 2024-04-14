-- Jupiter File System Extensions
-- This service is an "extension service". This means that it replaces original CraftOS calls.
-- You can also call this service a "fs driver".

-- this is to tell other programs that there is an extension, but it has not loaded (this is mainly for services so they don't use stuff that isn't loaded)
_G.extensions.fs = false

-- create logger
local logger = require("core.logger")
logger.sender = "JFSE [fs]" -- [fs] means that this is an extension for the fs API. other extensions should use this to show what they replace
logger.info("Loading fs extension.")

function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end 

-- API

-- copy old fs, we do it like this so any modifications don't also affect fsold
_G.extensions.fsold = {}
for k, v in pairs(fs) do
    _G.extensions.fsold[k] = v
end

-- Overwrites fs.list to use file attributes and symlinks.
function fs.list(path)
    if string.starts(path,"/") then path = string.sub(path,2) end
    if not fs.exists(path) then error("Folder does not exist") end
    local fileconfig = _G.extensions.fsold.open("/.JFS","r")
    local tableconfig = textutils.unserialise(fileconfig.readAll())
    fileconfig.close()
    local list = _G.extensions.fsold.list(path)
    for i,v in ipairs(list) do
        if tableconfig[path.."/"..v] then
            if tableconfig[path.."/"..v].shidden then
                table.remove(list,i)
            end
        end
    end
    return list
end

-- Formats the FS. (note: this doesn't wipe the disk, only creates the config.)
function fs.format()
    local formattable = {}
    formattable["/.JFS"] = {}
    formattable["/.JFS"].shidden = true -- super hide the fs config so that it doesn't show up in fs.list()
    local fileconfig = _G.extensions.fsold.open("/.JFS","w")
    fileconfig.write(textutils.serialize(formattable))
    fileconfig.close()
end

if not _G.extensions.fsold.exists("/.JFS") then logger.info("Drive not formatted for JFSE. Creating config file.") fs.format() end
_G.extensions.fs = true
logger.ok("Extension loaded.")