import 'babel-polyfill';

import express from 'express';
import bodyParser from 'body-parser';
import session from 'express-session';
import multer from 'multer';
import path from 'path';
import mysql from 'mysql2';

const app = express();
const upload = multer();
const conn = mysql.createConnection({
    host : '127.0.0.1',
    user : 'root', 
    password : 'sksks',
    database : 'build_vj'
});

app.set('trust proxy', 1);

app.use(express.static(path.resolve(__dirname, '../dist')));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(session({
    secret: 'keyboard cat',
    resave: false,
    saveUninitialized: true,
    cookie: {
        secure: true
    }
}));

app.post('/upload', upload.array(), (req, res, next) => {
    console.log(req.body);
    res.json(req.body);
});

app.get('/data/user', (req, resp) => {
    conn.query('select `user`,`json` from Users', (err, res) => {
        if (err)
        {
            resp.end('[]');
            return;
        }
        let arr = res.map(item => {
            return {
                user : item.user
            };
        });
    });
});

app.get('/data/:lasttime', (req, resp) => {
    let lasttime = parseInt(req.params.lasttime);
    conn.query(``, (err, res) => {
        if (err)
        {
            resp.end('[]');
            return;
        }
        resp.end(JSON.stringify(res));
    });
});

app.listen(5000);
