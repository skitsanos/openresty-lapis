local fs = require('_lib.fs')
local md = require('_lib.md')
local template = require('_lib.resty.template')

local m = function(self)
    if (self.params.id) then
        local mdContentPath = '/data/blog/' .. self.params.id .. '.md'
        if (fs.exists(mdContentPath)) then
            local mdContent = fs.read(mdContentPath);
            local htmlContent, err = md.renderString(mdContent, {});

            ngx.header['Content-Type'] = 'text/html'
            template.render(fs.read('/data/templates/blog/index.html'), {
                content = htmlContent,
                load = function(path)
                    return fs.read(path)
                end
            }, 'cache_' .. self.params.id, nil)

            return {
                layout = false
            }
        else
            return 'Not found'
        end

        return mdContentPath
    end

    return nil
end

return m