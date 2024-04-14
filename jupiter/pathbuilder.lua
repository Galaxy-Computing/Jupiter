-- SPDX-FileCopyrightText: 2017 Daniel Ratcliffe
--
-- SPDX-License-Identifier: LicenseRef-CCPL

local completion = require "cc.shell.completion"

-- Setup paths
local sPath = ".:/rom/programs:/rom/programs/http"
if term.isColor() then
    sPath = sPath .. ":/rom/programs/advanced"
end
if turtle then
    sPath = sPath .. ":/rom/programs/turtle"
else
    sPath = sPath .. ":/rom/programs/rednet:/rom/programs/fun"
    if term.isColor() then
        sPath = sPath .. ":/rom/programs/fun/advanced"
    end
end
if pocket then
    sPath = sPath .. ":/rom/programs/pocket"
end
if commands then
    sPath = sPath .. ":/rom/programs/command"
end
shell.setPath(sPath)
help.setPath("/rom/help")

-- Setup aliases
shell.setAlias("ls", "list")
shell.setAlias("dir", "list")
shell.setAlias("cp", "copy")
shell.setAlias("mv", "move")
shell.setAlias("rm", "delete")
shell.setAlias("clr", "clear")
shell.setAlias("rs", "redstone")
shell.setAlias("sh", "shell")
if term.isColor() then
    shell.setAlias("background", "bg")
    shell.setAlias("foreground", "fg")
end

-- Setup completion functions

local function completePastebinPut(shell, text, previous)
    if previous[2] == "put" then
        return fs.complete(text, shell.dir(), true, false)
    end
end

local function completeConfigPart2(shell, text, previous)
    if previous[2] == "get" or previous[2] == "set" then
        return completion.choice(shell, text, previous, config.list(), previous[2] == "set")
    end
end

local function completeConfigPart3(shell, text, previous)
    if previous[2] == "set" then
        if config.getType(previous[3]) == "boolean" then return completion.choice(shell, text, previous, {"true", "false"})
        elseif previous[3] == "mount_mode" then return completion.choice(shell, text, previous, {"none", "ro", "ro_strict", "rw"}) end
    end
end

shell.setCompletionFunction("jupiter/programs/alias.lua", completion.build(nil, completion.program))
shell.setCompletionFunction("jupiter/programs/cd.lua", completion.build(completion.dir))
shell.setCompletionFunction("jupiter/programs/clear.lua", completion.build({ completion.choice, { "screen", "palette", "all" } }))
shell.setCompletionFunction("jupiter/programs/copy.lua", completion.build(
    { completion.dirOrFile, true },
    completion.dirOrFile
))
shell.setCompletionFunction("jupiter/programs/delete.lua", completion.build({ completion.dirOrFile, many = true }))
shell.setCompletionFunction("jupiter/programs/drive.lua", completion.build(completion.dir))
shell.setCompletionFunction("jupiter/programs/edit.lua", completion.build(completion.file))
shell.setCompletionFunction("jupiter/programs/eject.lua", completion.build(completion.peripheral))
shell.setCompletionFunction("jupiter/programs/gps.lua", completion.build({ completion.choice, { "host", "host ", "locate" } }))
shell.setCompletionFunction("jupiter/programs/help.lua", completion.build(completion.help))
shell.setCompletionFunction("jupiter/programs/id.lua", completion.build(completion.peripheral))
shell.setCompletionFunction("jupiter/programs/label.lua", completion.build(
    { completion.choice, { "get", "get ", "set ", "clear", "clear " } },
    completion.peripheral
))
shell.setCompletionFunction("jupiter/programs/list.lua", completion.build(completion.dir))
shell.setCompletionFunction("jupiter/programs/mkdir.lua", completion.build({ completion.dir, many = true }))

local complete_monitor_extra = { "scale" }
shell.setCompletionFunction("jupiter/programs/monitor.lua", completion.build(
    function(shell, text, previous)
        local choices = completion.peripheral(shell, text, previous, true)
        for _, option in pairs(completion.choice(shell, text, previous, complete_monitor_extra, true)) do
            choices[#choices + 1] = option
        end
        return choices
    end,
    function(shell, text, previous)
        if previous[2] == "scale" then
            return completion.peripheral(shell, text, previous, true)
        else
            return completion.programWithArgs(shell, text, previous, 3)
        end
    end,
    {
        function(shell, text, previous)
            if previous[2] ~= "scale" then
                return completion.programWithArgs(shell, text, previous, 3)
            end
        end,
        many = true,
    }
))

shell.setCompletionFunction("jupiter/programs/move.lua", completion.build(
    { completion.dirOrFile, true },
    completion.dirOrFile
))
shell.setCompletionFunction("jupiter/programs/redstone.lua", completion.build(
    { completion.choice, { "probe", "set ", "pulse " } },
    completion.side
))
shell.setCompletionFunction("jupiter/programs/rename.lua", completion.build(
    { completion.dirOrFile, true },
    completion.dirOrFile
))
shell.setCompletionFunction("jupiter/programs/shell.lua", completion.build({ completion.programWithArgs, 2, many = true }))
shell.setCompletionFunction("jupiter/programs/type.lua", completion.build(completion.dirOrFile))
shell.setCompletionFunction("jupiter/programs/set.lua", completion.build({ completion.setting, true }))
shell.setCompletionFunction("rom/programs/advanced/bg.lua", completion.build({ completion.programWithArgs, 2, many = true }))
shell.setCompletionFunction("rom/programs/advanced/fg.lua", completion.build({ completion.programWithArgs, 2, many = true }))
shell.setCompletionFunction("rom/programs/fun/dj.lua", completion.build(
    { completion.choice, { "play", "play ", "stop " } },
    completion.peripheral
))
shell.setCompletionFunction("rom/programs/fun/speaker.lua", completion.build(
    { completion.choice, { "play ", "stop " } },
    function(shell, text, previous)
        if previous[2] == "play" then return completion.file(shell, text, previous, true)
        elseif previous[2] == "stop" then return completion.peripheral(shell, text, previous, false)
        end
    end,
    function(shell, text, previous)
        if previous[2] == "play" then return completion.peripheral(shell, text, previous, false)
        end
    end
))
shell.setCompletionFunction("rom/programs/fun/advanced/paint.lua", completion.build(completion.file))
shell.setCompletionFunction("rom/programs/http/pastebin.lua", completion.build(
    { completion.choice, { "put ", "get ", "run " } },
    completePastebinPut
))
shell.setCompletionFunction("rom/programs/http/gist.lua", completion.build(
    { completion.choice, { "put ", "get ", "run ", "edit ", "info ", "delete " } },
    completePastebinPut
))
shell.setCompletionFunction("rom/programs/rednet/chat.lua", completion.build({ completion.choice, { "host ", "join " } }))
shell.setCompletionFunction("rom/programs/command/exec.lua", completion.build(completion.command))
shell.setCompletionFunction("rom/programs/http/wget.lua", completion.build({ completion.choice, { "run " } }))

if periphemu and config and mounter then
    shell.setCompletionFunction("rom/programs/attach.lua", completion.build(
        completion.peripheral,
        { completion.choice, periphemu.names() }
    ))
    shell.setCompletionFunction("rom/programs/detach.lua", completion.build(completion.peripheral))
    shell.setCompletionFunction("rom/programs/config.lua", completion.build(
        { completion.choice, { "get ", "set ", "list " } },
        completeConfigPart2,
        completeConfigPart3
    ))
    shell.setCompletionFunction("rom/programs/mount.lua", completion.build(completion.dir))
    shell.setCompletionFunction("rom/programs/unmount.lua", completion.build(completion.dir))
end

if turtle then
    shell.setCompletionFunction("rom/programs/turtle/go.lua", completion.build(
        { completion.choice, { "left", "right", "forward", "back", "down", "up" }, true, many = true }
    ))
    shell.setCompletionFunction("rom/programs/turtle/turn.lua", completion.build(
        { completion.choice, { "left", "right" }, true, many = true }
    ))
    shell.setCompletionFunction("rom/programs/turtle/equip.lua", completion.build(
        nil,
        { completion.choice, { "left", "right" } }
    ))
    shell.setCompletionFunction("rom/programs/turtle/unequip.lua", completion.build(
        { completion.choice, { "left", "right" } }
    ))
end

-- Show MOTD
if settings.get("motd.enable") then
    shell.run("motd")
end

if _CCPC_PLUGIN_ERRORS and settings.get("shell.report_plugin_errors") then
    printError("Some plugins failed to load:")
    for k,v in pairs(_CCPC_PLUGIN_ERRORS) do
        printError("  " .. k .. " - " .. v)
    end
end
