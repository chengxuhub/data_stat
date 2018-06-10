local json = require("cjson")
local func = require('functions')
local kafka_client = require "resty.kafka.client"
local kafka_producer = require "resty.kafka.producer"

local mkafka = {
    key='test',
    topic="test",
    broker_list={
        {host = "127.0.0.1", port = 36502},
    }
}

-- curl -XGET  -H "Host:stat.uuid.wondershare.com"  "10.10.19.118:8080/api/v1.0/stat/kafka.gif?u1=123123&u2=343&u3=434234"
-- 定义json便于日志数据整理收集
local log_json = {}
log_json["uri"]=ngx.var.uri
log_json["args"]=ngx.var.args
log_json["host"]=ngx.var.host
log_json["request_body"]=ngx.var.request_body
log_json["remote_addr"] = ngx.var.remote_addr
log_json["remote_user"] = ngx.var.remote_user
log_json["time_local"] = ngx.var.time_local
log_json["status"] = ngx.var.status
log_json["body_bytes_sent"] = ngx.var.body_bytes_sent
log_json["http_referer"] = ngx.var.http_referer
log_json["http_user_agent"] = ngx.var.http_user_agent
log_json["http_x_forwarded_for"] = ngx.var.http_x_forwarded_for
log_json["upstream_response_time"] = ngx.var.upstream_response_time
log_json["request_time"] = ngx.var.request_time

-- 推送消息到kafka
local v_json = func.json_encode(log_json)
local p = kafka_producer:new(mkafka.broker_list);
local offset, err = p:send(mkafka.topic, mkafka.key, v_json)
if not offset then
    ngx.say(func.json_encode({code = 400, msg = err}))
    return
end

ngx.say(v_json)
ngx.exit(200)