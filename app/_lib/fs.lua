rawset(_G, 'lfs', false)
local localfilesystem = require('lfs')

local fs = {}

-- url:match "[^/]+$" -- To match file name
-- url:match "[^.]+$" -- To match file extension
-- url:match "([^/]-([^.]+))$" -- To match file name + file extension
function fs.fileName(path)
    --return path:match("^.+/(.+)$")
    return path:match("([^/]-([^.]+))$")
end

function fs.read(path)
    local _, res = pcall(io.open, path, "r")
    if (res == nil) then
        return nil
    end

    local t = res:read("*all")
    res:close()

    return t
end

function fs.write(path, content)
    local _, res = pcall(io.open, path, 'wb+')

    if (res == nil) then
        return nil
    end

    res:write(content)

    res:close()
end

function fs.exists(path)
    return localfilesystem.attributes(path, "mode") ~= nil
end

function fs.filesCount(path)

end

return fs