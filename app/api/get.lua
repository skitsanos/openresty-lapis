--
-- Exmaple on how to write a request handler that returns JSON
-- @author skitsanos
-- @version 1.0.0
--
local utils = require('utils')

local m = function(self)
    return {
        json = {
            machineId = utils.getMachineId(),
            hostname = ngx.var.HOSTNAME,
            version = '1.2.20200604'
        }
    }
end

return m