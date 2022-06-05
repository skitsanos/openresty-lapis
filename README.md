# OpenResty-Lapis Template

The idea behind this template is to allow developers to skip setting up the complex development environment and simplify request routing while developing APIs or websites running on OpenResty.

> **OpenResty**® is designed to build scalable web applications, web services, and dynamic web gateways. The OpenResty architecture is based on several nginx modules which have been extended in order to expand nginx into a web app server to handle a large number of requests. The concept of the OpenResty solution aims to run a server-side web app completely in the nginx server, leveraging the nginx event model to do non-blocking I/O not only with the HTTP clients, but also with remote backends like MySQL, PostgreSQL, Memcached, and Redis

As a route handler and web framework in general, [Lapis](https://leafo.net/lapis/) is used as a core. Lapis is a framework for building web applications using [MoonScript](https://moonscript.org/) or [Lua](https://lua.org/) that runs inside of OpenResty.

### Minimal nginx.conf

All you need to start developing with this template is actually ... nothing. Minimal `nginx.conf` is already provided for you:

```
events {
   worker_connections 4096;
}
http {
    #include mime.types;

    lua_code_cache off; #comment for production

    init_by_lua_block {
        json = require('dkjson');
    }

   server {
      listen 80;

      location / {
         content_by_lua_file /app/index.lua;
      }

      location /static/ {
        alias static/;
      }

      location /favicon.ico {
        alias static/favicon.ico;
      }
   }
}
```

Notice `lua_code_cache off;` bit. It allows you to keep modifying your code without the need to restart the OpenResty server, on the live server you will need to switch it on.

When turning off, every request served by ngx_lua will run in a separate Lua VM instance, starting from the 0.9.3 release. So the Lua files referenced in set_by_lua_file, content_by_lua_file, access_by_lua_file, etc will not be cached and all Lua modules used will be loaded from scratch. With this in place, developers can adopt an edit-and-refresh approach.

### Running in Docker

For your convenience, there are `Dokerfile` and `docker-compose.yml` both provided, so you can either grab your image from the registry as `skitsanos/openresty-lapis` or rebuild your own.

To run the whole thing in docker, you need just a few lines to be set: mount `nginx.conf` and the `app` folder where your code is.

```yaml
version: "3.9"

services:
  openresty-dev:
    container_name: openresty-lapis
    image: skitsanos/openresty-lapis
    volumes:
      - ./app:/app
      - ./nginx/conf:/usr/local/openresty/nginx/conf
    ports:
      - "8888:80"
```



### Creating your first API endpoint

For the sake of convention, as in [Foxx-Builder](https://github.com/skitsanos/foxx-builder), [Umijs,](https://umijs.org/) and some others, this template used the same folder structure for the route naming and HTTP method handling:

- every path section is a folder,
- Path parameter is a folder that starts with `$`, ie: `/api/users/$id`
- HTTP method handler is a file, ie: `get.lua`, `post.lua`, `delete.lua`

let's assume that all our API services will be mounted on ```/api``` route. The file path of your API route method handler mirrors your URL path.

| **API endpoint**                 | **Handler**                       |
| -------------------------------- | --------------------------------- |
| GET /api/echo                    | /api/echo/post.js                  |
| GET /api/users                   | /api/users/post.js                 |
| POST /api/users                  | /api/users/post.js                |
| GET /api/users/_:id_/tasks       | /api/users/$id/tasks/post.js       |
| GET /api/users/_:id_/tasks/:task | /api/users/$id/tasks/$task/post.js |

### Parametrized path

Adding parameters to your URL point handling is pretty simple. Probably, you already noticed from the table above, when we require some parameter, we add its name with $ in front of it in our folder name. Just make sure you don't have duplicating parameters.

| **API endpoint**                 | **Handler**                       |
| -------------------------------- | --------------------------------- |
| GET /api/users/_:id_/tasks/:task | /api/users/$id/tasks/$task/post.js |

```
/api/
--/users/
----post.js
----post.js
----/$id/
------post.js
------/tasks/
--------post.js
--------post.js
--------/$task/
----------post.js
```

Because `Lapis` is using a naming convention with the path parameters that contains `:` like some of the web servers do (Express, Fastify, etc), - we need to convert these `:param` blocks from the `$param` ones.

In `app/index.lua` you will find also route loader:

```lua
local routeBuilder = require('route-builder')

local routes = routeBuilder.analyzeRoutes('./api')

for routePath, routeResponder in pairs(routes) do
    app:match(routePath, respond_to(routeResponder))
end
```

That's where all the magic going on. It _walks_ through all your folders with handlers and registers them on the Lapis router.

### References

- [OpenResty Reference](https://openresty-reference.readthedocs.io/en/latest/)
- [Lapis](https://leafo.net/lapis/)
- [HTTP methods supported](https://github.com/openresty/lua-nginx-module#http-method-constants)
- [Learn Lua at Tutorials Point](https://www.tutorialspoint.com/questions/category/Lua)
