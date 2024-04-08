local branch = "dev"

term.clear()
term.setCursorPos(1,1)
print("Jupiter Setup")
fs.makeDir("/.temp")
shell.setDir("/.temp")
shell.run("pastebin get W5ZkVYSi gitget")
shell.run("gitget Galaxy-Computing CCboot "..branch.." /")
shell.run("gitget Galaxy-Computing Jupiter "..branch.." /")
print("Complete. Press any key to reboot.")