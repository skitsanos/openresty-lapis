local m = function(self)
    return {
        json = {
            debug = 'Deleting user-by-id',
            params = self.params
        }
    }
end

return m