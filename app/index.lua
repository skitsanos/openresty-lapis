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

--
-- Start the server
--
lapis.serve(app)