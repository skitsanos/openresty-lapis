local m = {}

function m.get_route_method(file)
    return file:match("^.+/(.+).lua$")
end

function m.get_route_path(file)
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

        local route_item = {
            path = v,
            handler = handler_raw,
            routePath = url_raw:gsub(url_raw:match('^.+(/.+)$'), ''),
            method = m.get_route_method(v):upper()
        }

        if(routes[route_item.routePath] == nil) then
            routes[route_item.routePath] = {}
        end

        if(routes[route_item.routePath][route_item.method] == nil) then
            routes[route_item.routePath][route_item.method] = require(route_item.handler)
        end
    end

    return routes
end

return m