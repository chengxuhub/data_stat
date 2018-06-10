local json = require("cjson")
local func = require('functions')

-- curl -XGET  -H "Host:stat.uuid.wondershare.com"  "10.10.19.118:8080/api/v1.0/stat/r1.gif?u1=123123&u2=343&u3=434234"
local method_name = ngx.req.get_method()
if method_name == "POST" then
    ngx.req.read_body()
    args, err = ngx.req.get_post_args()
else
    args, err = ngx.req.get_uri_args()
end

if not args then
    ng.say(func.json_encode({code = 400, msg = err}))
    return
end



ngx.say(func.json_encode(args))
ngx.exit(200)