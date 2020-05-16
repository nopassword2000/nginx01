--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2020/2/26 0026
-- Time: 22:40
-- To change this template use File | Settings | File Templates.
--


local function lua()
    ngx.log(ngx.ERR,'拦截返回body ----' .. ngx.arg[1] .. "--------" .. tostring(ngx.arg[2]))
    if ngx.arg[1] and not ngx.is_subrequest then
        ngx.log(ngx.ERR,'拦截返回body2 ----' .. ngx.arg[1] .. "--------" .. tostring(ngx.arg[2]))
        end

    --ngx.say("body")
end

lua()

