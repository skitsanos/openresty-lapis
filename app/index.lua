--http://dkolf.de/src/dkjson-lua.fsl/raw/dkjson.lua?name=6c6486a4a589ed9ae70654a2821e956650299228
--http://lua-users.org/wiki/JsonModules
--https://github.com/bungle/lua-resty-jq

local lapis = require("lapis")
local respond_to = require("lapis.application").respond_to
local app = lapis.Application()
local to_json = require("lapis.util").to_json --https://leafo.net/lapis/reference/utilities.html
local routeBuilder = require('route-builder')
local markdown = require "markdown"
--markdown(source)

print('booting..')

function app:default_route()
    ngx.log(ngx.WARN, "User hit unknown path " .. self.req.parsed_url.path)
    return lapis.Application.default_route(self)
end

--
-- Handle 404 (Not Found) errors
--
function app:handle_404()
    return {
        status = 404,
        layout = false,
        markdown('### Not Found!\n\n'..'The page you are looking for can not be found')
    }
end

--
--
--
app:get("/", function(self)
    return to_json({})
end)

--[[app:match('/api/users/:userId', respond_to({
    ['DELETE'] = require('api.users.$id.delete')
}
))
--]]
-- Load route handlers from the filesystem
--
local routes = routeBuilder.analyzeRoutes('./api')

for routePath, routeResponder in pairs(routes) do
    app:match(routePath, respond_to(routeResponder))
end

--
-- Start the server
--
lapis.serve(app)