local m = {}

function get_route_method(file)
    return file:match("^.+/(.+).lua$")
end

function get_route_path(file)
    return file:match("^.+/(.+)$")
end

function m.scanRoutes(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('find "' .. directory .. '" -type f')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename:gsub("%./", "/")
    end
    pfile:close()

    return t
end

function m.analyzeRoutes(directory)
    local files = m.scanRoutes(directory)

    local routes = {}

    for i, v in ipairs(files) do
        local url_raw = v:gsub('%$', ":")
        local handler_raw = v:gsub("%/", "."):sub(2):match('(.+).lua$')

        table.insert(routes, {
            path = v,
            handler = handler_raw,
            routePath = url_raw:gsub(url_raw:match('^.+(/.+)$'), ''),
            method = get_route_method(v):upper()
        })
    end

    return routes
end

function m.getMachineId()
    local handle = io.popen("cat /etc/machine-id")
    local result = handle:read("*a")
    handle:close()

    return result
end

return m