local http = require("socket.http")
local ltn12 = require("ltn12")
local cjson = require("json4lua.json.json") --https://gobyexample.com/json

RequestManager = {}
RequestManager.__index = RequestManager
RequestManager.new = function(serverAddress)
    local self = {}
    setmetatable(self, GameManager)
    RequestManager.theInstance = self

    self.serverAddress = serverAddress

    self.get = function(endpoint)
        local url = "http://0.0.0.0:8080/api/" .. endpoint
        local response_body = {}
        local res, code, response_headers, status = http.request
        {
            url = url,
            method = "GET",
            headers =
            {
                ["Authorization"] = "Maybe you need an Authorization header?", 
                ["Content-Type"] = "application/json",
                -- ["Content-Length"] = string.len(request_body)
            },
            sink = ltn12.sink.table(response_body)
        }
        -- print('GET: ' .. table.concat(response_body))
        return response_body
    end

    self.postObject = function(endpoint, obj)
        local url = "http://0.0.0.0:8080/api/" .. endpoint
        local request_body = cjson.encode(obj)
        print("url:" .. url)
        print("request_body:" .. request_body)

        local response_body = {}
        local res, code, response_headers, status = http.request
        {
            url = url,
            method = "POST",
            headers =
            {
                ["Authorization"] = "Maybe you need an Authorization header?", 
                ["Content-Type"] = "application/json",
                ["Content-Length"] = string.len(request_body)
            },
            source = ltn12.source.string(request_body),
            sink = ltn12.sink.table(response_body)
        }
        print(table.concat(response_body))
      end    

    return self
end

RequestManager.getInstance = function()
    return RequestManager.theInstance
end

if not RequestManager.theInstance then
    RequestManager.new("http://0.0.0.0:8080/api/")
end

return RequestManager.theInstance
