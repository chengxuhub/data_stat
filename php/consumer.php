<?php

error_reporting(7);
set_time_limit(0);
ini_set('memory_limit', -1);
ini_set('default_socket_timeout', -1);
date_default_timezone_set('PRC');

//项目根目录
define('ROOT_PATH', realpath('../'));

$conf = new RdKafka\Conf();
// Set the group id. This is required when storing offsets on the broker
$conf->set('group.id', 'myGroup');
$rk = new RdKafka\Consumer($conf);
$rk->addBrokers("127.0.0.1");

$topicConf = new RdKafka\TopicConf();
$topicConf->set('auto.commit.interval.ms', 100);
// Set the offset store method to 'file'
$topicConf->set('offset.store.method', 'file');
$topicConf->set('offset.store.path', ROOT_PATH . '/logs/');
$topicConf->set('auto.offset.reset', 'smallest');

$topic = $rk->newTopic("test", $topicConf);
$topic->consumeStart(0, RD_KAFKA_OFFSET_STORED);

while (true) {
    $message = $topic->consume(0, 120 * 10000);
    switch ($message->err) {
        case RD_KAFKA_RESP_ERR_NO_ERROR:
            handle($message);
            break;
        case RD_KAFKA_RESP_ERR__PARTITION_EOF:
            echo date("Y-m-d H:i:s") . " No more messages; will wait for more\n";
            sleep(1);
            break;
        case RD_KAFKA_RESP_ERR__TIMED_OUT:
            echo date("Y-m-d H:i:s") . " Timed out\n";
            break;
        default:
            throw new \Exception($message->errstr(), $message->err);
            break;
    }
}


function handle($message) {
    $data = $message->payload;
    $data = json_decode($data, true);
    foreach ($data as $key => $value) {
        $data[$key] = addslashes($value);
    }
    print_r(json_encode($data));
}