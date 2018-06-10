local json = require("cjson")

-- 公共函数


local _FUNC = { _VERSION = '0.01' }
local mt = { __index = _FUNC }


-- json 编码
function _FUNC.json_encode(str)
    return json.encode(str)
end


-- json 解码
function _FUNC.json_decode(str)
    local ok, t = pcall(function(str) return json.decode(str) end, str)
    if not ok then
        return nil
    end

    return t
end


function _FUNC.to_hex( str )
   return ( str:gsub( '.', function ( c )
               return string.format('%02X', string.byte( c ) )
            end ) )
end

-- 获取ngx共享内存
function _FUNC.get_ngx_cache(key)
    local cache_ngx = ngx.shared.token_cache
    local value = cache_ngx:get(key)
    return value
end

-- 设置ngx共享内存
function _FUNC.set_to_cache(key, value, exptime)
    if not exptime then
        exptime = 0
    end

    local cache_ngx = ngx.shared.token_cache
    local succ, err, forcible = cache_ngx:set(key, value, exptime)
    return succ
end


-- 删除ngx共享内存
function _FUNC.delete_from_cache(key)
    local cache_ngx = ngx.shared.token_cache
    local value = cache_ngx:delete(key)
end

-- trim字符串
function _FUNC.trim_string(str)
    if str == nil then
        return ""
    end
    str = tostring(str)
    return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
end


-- 获取客户端IP
function _FUNC.get_client_ip(ngx)
    local headers=ngx.req.get_headers()
    local ip=headers["X-REAL-IP"] or headers["X_FORWARDED_FOR"] or ngx.var.remote_addr or "0.0.0.0"
    return ip
end

-- 检查email的格式
function _FUNC.isEmail(str)
    if string.len(str or "") < 6 then return false end
    local b,e = string.find(str or "", '@')
    local bstr = ""
    local estr = ""
    if b then
        bstr = string.sub(str, 1, b-1)
        estr = string.sub(str, e+1, -1)
    else
        return false
    end
    -- check the string before '@'
    local p1,p2 = string.find(bstr, "[%w_.]+")
    if (p1 ~= 1) or (p2 ~= string.len(bstr)) then return false end

    -- check the string after '@'
    if string.find(estr, "^[%.]+") then return false end
    if string.find(estr, "%.[%.]+") then return false end
    if string.find(estr, "@") then return false end
    if string.find(estr, "%s") then return false end --空白符
    if string.find(estr, "[%.]+$") then return false end

    _,count = string.gsub(estr, "%.", "")
    if (count < 1 ) or (count > 3) then
        return false
    end

    return true
end
return _FUNC