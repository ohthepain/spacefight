local http = require("socket.http")
local ltn12 = require("ltn12")
local cjson = require("json4lua.json.json")

RequestManager = {}
RequestManager.new = function(serverAddress)
    local self = {}

    self.serverAddress = serverAddress

    self.sendObject = function(endpoint, obj)
        local path = "http://0.0.0.0:8080/api/" .. endpoint .. "?param_1=one&param_2=two&param_3=three"
        obj.spaceship = nil
        local request_body = cjson.encode(obj)
        print("request_body:" .. request_body)

        local response_body = {}
        local res, code, response_headers, status = http.request
        {
            url = path,
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
