<script>
    import React from 'react';
    import {observer} from 'mobx-react';
    import {
        Button, Row, Col, Table, Card, Input
    } from 'antd';
    import Promise from 'promise-polyfill';
    if (!window.Promise)
        window.Promise = Promise;
    import 'whatwg-fetch';
    
    import Model from '../model/Model.js';
    
    const APIServer = 'http://202.199.24.220/data.php?';

    Array.prototype.shit = function () {
        let tmp = {};
        let ret = [];
        for (let i=0;i < this.length;++i)
        {
            if (!tmp[this[i].user + this[i].oid])
            {
                ret.push(this[i]);
                tmp[this[i].user + this[i].oid] = true;
            }
        }
        return ret;
    };

    export default @observer class extends React.Component {
        constructor(props) {
            super(props);
            this.state = {
                lasttime : 0,
                dataSource : [],
                user : [],
                ball : {},
                list : {},
                pppp : [],
                first : {},
                problem : [],
                columns : [
                    {
                        title : '编号',
                        dataIndex : 'id',
                        key : 'id'
                    },
                    {
                        title : '账号',
                        dataIndex : 'user',
                        key : 'user'
                    },
                    {
                        title : '队伍',
                        dataIndex : 'nick',
                        key : 'nick'
                    },
                    {
                        title : '题号',
                        dataIndex : 'label',
                        key : 'label'
                    },
                    {
                        title : '题目',
                        dataIndex : 'name',
                        key : 'name'
                    },
                    {
                        title : '操作',
                        dataIndex : 'op',
                        key : 'op'
                    }
                ]
            };
        }
        render() 
        {
            let data = this.state.dataSource.map((item, index) => {
                return {
                    id : item.id,
                    user : item.user,
                    nick : this.state.user[item.user],
                    label : this.state.list[item.oid],
                    name : this.state.problem[item.oid],
                    op : <a href='#' style={this.state.ball[item.user + item.oid]?{color:'#f00'}:{color:'#0f0'}} onClick={e => this.sendBall(e, item.user + item.oid)}>送气球</a>
                };
            }).reverse();
            let cc = [];
            for (let i=0;i < this.state.pppp.length;++i)
                cc[i] = {
                    title : this.state.list[this.state.pppp[i]],
                    dataIndex : this.state.list[this.state.pppp[i]],
                    key : this.state.list[this.state.pppp[i]]
                };
            let bbbb = [Object.assign(this.state.first, {key : 'label'})];
            return (
                <div id='main'>
                    <Row>
                        <Col span={20} offset={2}>
                            <Card title='一血'>
                                <Table dataSource={bbbb} columns={cc} />
                            </Card>
                            <Card title={
                                    <Row>
                                        <Col span={20}>
                                            比赛实时数据
                                        </Col>
                                        <Col span={2}>
                                            <Button onClick={() => this.fetchConst()} type='primary'>刷新队名</Button>
                                        </Col>
                                        <Col span={2}>
                                            <Button onClick={() => this.clearBall()} style={{backgroundColor : '#f00', color : '#fff'}}>清空气球</Button>
                                        </Col>
                                    </Row>
                                } style={{marginTop : '40px'}}>
                                <Table dataSource={data} columns={this.state.columns} />
                            </Card>
                        </Col>
                    </Row>
                </div>
            );
        }
        componentDidMount() {
            this.fetchConst();
            setInterval(() => this.doUpdate(), 1000);
            let ball = sessionStorage.getItem('ball');
            if (!ball)
                ball = {};
            else
                ball = JSON.parse(ball);
            this.setState({ball : ball});
        }
        fetchConst() {
            fetch(APIServer + 'user', {
                    mode : 'cors'
                })
                .then(res => res.json())
                .then(json => this.setState({user : json}));
            fetch(APIServer + 'problem', {
                    mode : 'cors'
                })
                .then(res => res.json())
                .then(json => this.setState({problem : json}));
            fetch(APIServer + 'list')
                .then(res => res.json())
                .then(json => {
                    let list = {};
                    let p = 0;
                    for (let i of json)
                        list[i] = String.fromCharCode(p++ + 65);
                    this.setState({list : list, pppp : json})
                });
        }
        sendBall(e, token) {
            let ball = this.state.ball;
            ball[token] = true;
            sessionStorage.setItem('ball', JSON.stringify(ball));
            this.setState({ball : ball});
        }
        clearBall() {
            let ball = {};
            sessionStorage.setItem('ball', JSON.stringify(ball));
            this.setState({ball : ball});
        }
        setFirst(data) {
            let first = this.state.first;
            let list = this.state.list;
            for (let i of data)
                if (!first[list[i.oid]])
                    first[list[i.oid]] = i.user;
            this.setState({first : first});
        }
        doUpdate() {
            fetch(`${APIServer}data&lasttime=${this.state.lasttime}`, {
                    mode : 'cors'
                })
                .then(res => res.json())
                .then(json => {
                    let old = this.state.dataSource;
                    let new_ = old.concat(json).shit();
                    let lasttime = new_.length?new_[new_.length - 1].id:0;
                    this.setState({dataSource : new_, lasttime : lasttime});
                    this.setFirst(new_);
                });
        }
    }
</script>

<style lang='less' scoped>
    #main {
        margin: 40px 0px 40px 0px;
    }
</style>
