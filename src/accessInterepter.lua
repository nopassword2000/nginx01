--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2020/2/18 0018
-- Time: 23:17
-- To change this template use File | Settings | File Templates.
--


local function auth()
    --local heads = ngx.req.get_headers();
    local prams = ngx.req.get_uri_args()
    local param = "";
    local isok = false;
    for k,v  in pairs(prams) do
        param = param .. k .. v .. "---"
        if (k == 'a') then
            isok = true
        end

    end
    ngx.log(ngx.ERR,'nginx auth ' .. param)
    if isok == false then
        --ngx.say("this is auth")


        -- ngx.exit(ngx.HTTP_OK);

        local http = require("resty.http")
        local httpc = http:new()
        local resp,err = httpc:request_uri("http://www.baidu.com",
            {
                method = "GET",
                path="/",
                headers = {["User-Agent"]="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36"}
            })
        if not resp then
            ngx.say("request error:",err)
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

        --响应体
        ngx.say(resp.body)

        httpc:close()
    end


end

auth()