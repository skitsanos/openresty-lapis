--http://dkolf.de/src/dkjson-lua.fsl/raw/dkjson.lua?name=6c6486a4a589ed9ae70654a2821e956650299228
--http://lua-users.org/wiki/JsonModules
--https://github.com/bungle/lua-resty-jq

local lapis = require("lapis")
local respond_to = require("lapis.application").respond_to
local app = lapis.Application()
local to_json = require("lapis.util").to_json --https://leafo.net/lapis/reference/utilities.html
local utils = require('utils');
local markdown = require "markdown"
--markdown(source)

function app:default_route()
    ngx.log(ngx.WARN, "User hit unknown path " .. self.req.parsed_url.path)
    return lapis.Application.default_route(self)
end

--
--
--
function app:handle_404()
    return {
        status = 404,
        layout = false,
        "Not Found!"
    }
end

--
--
--
app:get("/", function(self)
    return to_json({})
end)

--
-- Load route handlers from the filesystem
--
local routes = utils.analyzeRoutes('./api')

for _, route in ipairs(routes) do
    app:match(route.routePath, respond_to(
            {
                [route.method] = require(route.handler)
            }
    ))
end

--[[
app:match("wildcard", '/*', function(self)
    --if it is not /api, do something else
    local req_path = self.params.splat:gsub("%/", ".") .. '.index'

    return to_json(utils.analyzeRoutes('./api'))

    --return require(req_path)(self)

    --return markdown('### hello ' .. self.req.parsed_url.path .. '--' .. req_path)
end)
]]


--[[--https://leafo.net/lapis/reference/actions.html#handling-http-verbs
app:match("/api/*", function(self)
    --ngx.header['Content-Type'] = 'application/json'
    --ngx.status = code
    return {
        status = 200,
        json = self.params
    }
end)]]

--
-- Start the server
--
lapis.serve(app)