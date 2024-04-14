local logger = {}

-- not to be used outside of boot

logger.sender = ""
function logger.ok(string)
    term.setTextColour(colours.white)
    write("("..logger.sender..") ")
    term.setTextColour(colours.lime)
    write("OK: ") 
    term.setTextColour(colours.white)
    print(string)
end
function logger.warn(string)
    term.setTextColour(colours.white)
    write("("..logger.sender..") ")
    term.setTextColour(colours.yellow)
    write("WARN: ") 
    term.setTextColour(colours.white)
    print(string)
end
function logger.error(string)
    term.setTextColour(colours.white)
    write("("..logger.sender..") ")
    term.setTextColour(colours.red)
    write("ERROR: ") 
    term.setTextColour(colours.white)
    print(string)
end
function logger.info(string)
    term.setTextColour(colours.white)
    write("("..logger.sender..") ")
    term.setTextColour(colours.purple)
    write("INFO: ") 
    term.setTextColour(colours.white)
    print(string)
end

return logger