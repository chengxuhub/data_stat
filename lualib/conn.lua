-- 公共连接配置文件

module("conn", package.seeall)

connKafka = {
    key='statistics_new',
    topic="statistics_new",
    broker_list={
        {host = "127.0.0.1", port = 36502},
    }
}


-- 使用 local dbConn = require "conn"["connMySQL"]
connMySQL = {
    host='127.0.0.1',
    port=3306,
    database='lora',
    user='root',
    password='dff20660ea',
}

-- 使用 local RdsConn = require "conn"["connRedis"]
connRedis = {
    host='127.0.0.1',
    port=6379,
    pool=30,
    max_idle_timeout=1000*10,
}