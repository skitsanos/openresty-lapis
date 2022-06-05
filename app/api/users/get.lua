local m = function(self)
    return self.req.parsed_url.path
end

return m