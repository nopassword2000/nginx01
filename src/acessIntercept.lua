--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2020/2/22 0022
-- Time: 18:49
-- To change this template use File | Settings | File Templates.
--
local http = require("resty.http")
local cjson = require("cjson")
local units = require("units")

local function string2char(sb)
    local sbarry = {}

    if sb == nil then
        sbarry = nil
    end

    for i = 1, string.len(sb) do
        local sbs = string.sub(sb,i,-string.len(sb) + i -1)
        sbarry[i] = sbs
    end
    return sbarry
end
local function wlsuffix()

    local wsuffix = {'html','htm','js','css','png','jpg','gif','txt' }
    local whitelist = {"/user/login","/user/logout"}
    local uri = ngx.var.uri;
    for i=1, table.getn(whitelist) do
        if whitelist[i] == uri then
            return true
        end
        ngx.log(ngx.ERR, "whitelist" ..whitelist[i] .."---------" .. uri)
    end

    local arry = units.split(uri, '/')
    local arrySize = table.getn(arry)
    if arrySize == 0 then
        ngx.log(ngx.ERR, "/" ..table.getn(arry) .."---------")
        return true
    end

    local endifxArry = units.split(arry[table.getn(arry)], ".")
    if table.getn(endifxArry) == 1 then
        return false
    end

    local endfix = endifxArry[table.getn(endifxArry)]
    for  i=1, table.getn(wsuffix) do
        if wsuffix[i] == endfix then
            ngx.log(ngx.ERR, "wsuffix----" ..wsuffix[i] .."---------" .. endfix.. "-----")
            return true
        end
    end
    ngx.log(ngx.ERR, '-------------------' ..uri.. '-------------------')
    return false;
end

local function retBody()
    local body = {
        ["code"] = "no",
        ["msg"] = "fiald"
    }

   return cjson.encode(body)

end

local function auth()

    if wlsuffix()  then
        return
    end

    local httpc = http:new()
    httpc:set_timeout(5000)
    local resp,err = httpc:request_uri("http://192.168.222.129:8088",
        {
            method = "GET",
            path="/user/current-user",
            headers = {["User-Agent"]="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36",
                       ["Cookie"] = ngx.req.get_headers()['Cookie'],
                       ["Accept"] = "application/json"
            }
        })
    httpc:close()
    if not resp then
        ngx.say(retBody())
        ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)

        return
    end
    --获取状态码
    ngx.status = resp.status

    --获取响应信息
    --响应头中的Transfer-Encoding和Connection可以忽略，因为这个数据是当前server输出的。
    for k,v in pairs(resp.headers) do
        if k ~= "Transfer-Encoding" and k ~= "Connection" then
            ngx.header[k] =v
        end
    end


    local retdata = cjson.decode(resp.body)
    ngx.log(ngx.ERR, "wsuffix----" ..resp.body .."---------")

    if retdata["code"] == 'ok' then
        ngx.log(ngx.ERR, "code----" ..retdata["data"]["account"] .."---------")
        ngx.req.set_header("user-info",cjson.encode(retdata["data"]))
    else
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.say(retBody())
        ngx.exit(ngx.HTTP_OK)

    end
    --响应体
    --ngx.say(resp.body)
end



function test()


    -- 这个变量等于包含一些客户端请求参数的原始URI，它无法修改，请查看$uri更改或重写URI。
    local request_uri = ngx.var.request_uri
    ngx.log(ngx.ERR,"获取当前请求的url==" .. cjson.encode(request_uri))

    -- HTTP方法（如http，https）。按需使用，例：
    local scheme = ngx.var.scheme --server_addr
    ngx.log(ngx.ERR,"获取当前请求的url scheme==" .. cjson.encode(scheme) )

    -- 服务器地址，在完成一次系统调用后可以确定这个值，如果要绕开系统调用，则必须在listen中指定地址并且使用bind参数。
    local server_addr = ngx.var.server_addruri
    ngx.log(ngx.ERR,"获取当前请求的url server_addr==" .. cjson.encode(server_addr) )

    -- 请求中的当前URI(不带请求参数，参数位于$args)，可以不同于浏览器传递的$request_uri的值，它可以通过内部重定向，或者使用index指令进行修改。
    local uri = ngx.var.uri
    ngx.log(ngx.ERR,"获取当前请求的url uri==" .. cjson.encode(uri) )

    -- 服务器名称
    local server_name  = ngx.var.server_name
    ngx.log(ngx.ERR,"获取当前请求的url server_name ==" .. cjson.encode(server_name ))

    -- 请求到达服务器的端口号。
    local server_port  = ngx.var.server_name
    ngx.log(ngx.ERR,"获取当前请求的url server_port ==" .. cjson.encode(server_port ))
end



auth()