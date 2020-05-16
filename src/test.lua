--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2020/2/18 0018
-- Time: 20:15
-- To change this template use File | Settings | File Templates.
--
require("socket")
local function main()
    local http = require("resty.http")
    local httpc = http:new()
    local resp,err = httpc:request_uri("https://127.0.0.1:8080",
        {
            ssl_verify = ssl_verify or false,
            method = "GET",
            path="/user/hello",
            headers = {["User-Agent"]="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36"}
        })
    if not resp then
        ngx.say("request error:",err)
        return
    end
    ngx.log(ngx.ERR, "this is openrest")
end


local function httpsmian()
    local https = require("ssl.https")
    local one, code, headers, status = https.request{
        url = "https://127.0.0.1:8080",
        key = "F:/wmContos/vmShare/cert/client.key",
        certificate="F:/wmContos/vmShare/cert/client.pem",
        cafile="F:/wmContos/vmShare/cert/ca.crt"
    }
    print(code)
    print(header)
    print(status)
    print(one)
end
main()

