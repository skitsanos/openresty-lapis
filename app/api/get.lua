--
-- Exmaple on how to write a request handler that returns JSON
-- @author skitsanos
-- @version 1.0.0
--
local function getMachineId()
    local handle = io.popen("cat /etc/machine-id")
    local result = handle:read("*a")
    handle:close()

    return result
end

local m = function(self)
    return {
        json = {
            machineId = getMachineId(),
            hostname = ngx.var.HOSTNAME,
            version = '1.2.20200604'
        }
    }
end

return m