<?php /**
        Author: SpringHack - springhack@live.cn
        Last modified: 2016-12-17 23:52:55
        Filename: data.php
        Description: Created by SpringHack using vim automatically.
**/ ?>
<?php

    define('CONTEST', 1);
    define('DB_HOST', '127.0.0.1');

    $db = new PDO('mysql:host='.DB_HOST.';dbname=build_vj;charset=utf8', 'root', 'sksks');

    header('Access-Control-Allow-Origin: *');

    if (isset($_GET['user']))
    {
        $res = $db->query('select `user`,`json` from Users');
        $ret = [];
        while ($item = $res->fetch())
            $ret[$item['user']] = unserialize($item['json'])['nick'];
        echo json_encode($ret);
    }

    if(isset($_GET['problem']))
    {
        $res = $db->query('select id,title from Problem');
        $ret = [];
        while ($item = $res->fetch())
            $ret[$item['id']] = $item['title'];
        echo json_encode($ret);
    }

    if(isset($_GET['list']))
    {
        $res = $db->query('select `list` from Contest where id='.CONTEST);
        $ret = [];
        while ($item = $res->fetch())
            $ret = explode(',', $item['list']);
        echo json_encode($ret);
    }

    if (isset($_GET['data']) && isset($_GET['lasttime']))
    {
        $res = $db->query("select `id`,`user`,`oid`,`time` from Record where result='Accepted' and contest=".CONTEST." and id>".intval($_GET['lasttime'])." order by time ASC");
        $ret = [];
        while ($item = $res->fetch())
            $ret[] = [
                'id' => $item['id'],
                'oid' => $item['oid'],
                'user' => $item['user'],
                'time' => $item['time']
            ];
        echo json_encode($ret);
    }

?>
