local branch = "dev"

term.clear()
term.setCursorPos(1,1)
print("Jupiter Setup")
fs.makeDir("/.temp")
shell.run("pastebin get W5ZkVYSi /.temp/gitget")
shell.run("/.temp/gitget Galaxy-Computing CCboot "..branch)
shell.run("/.temp/gitget Galaxy-Computing Jupiter "..branch)
print("Complete. Press any key to reboot.")