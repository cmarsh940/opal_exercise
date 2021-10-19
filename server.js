const config = require("./server/config/config");
const cors = require("cors");
// const csrf = require('csurf');
const express = require('express');
const helmet = require('helmet');
const http = require('http');
const port = normalizePort(process.env.PORT || '8000');
// const session = require('express-session');
const app = express();


// const csp = `default-src * data: blob:;script-src *.amazonaws.com *.facebook.com  *.facebook.net *.google-analytics.com *.google.com 127.0.0.1:*  'unsafe-inline' 'unsafe-eval' blob: data: 'self';style-src data: blob: 'unsafe-inline' *;connect-src *.amazonaws.com localhost:* *.facebook.com facebook.com *.fbcdn.net *.facebook.net *.google.com *.googleapis.com`;

app.use(helmet());

// app.use(function (req, res, next) {
//     res.header('Access-Control-Allow-Origin', '*');
//     res.header('Access-Control-Allow-Credentials', true);
//     res.header('X-Content-Type-Options', 'nosniff');
//     res.header('X-Frame-Options', 'DENY');
//     res.header('Referrer-Policy', 'no-referrer-when-downgrade');
//     res.header('Content-Security-Policy', csp);
//     res.header('Strict-Transport-Security', 'max-age=7889238; includeSubDomains; preload');
//     res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
//     res.header('Access-Control-Expose-Headers', 'Content-Length');
//     res.header('Access-Control-Allow-Headers', 'Accept, Authorization, Content-Type, X-Requested-With, Range, X-XSRF-TOKEN, Sh1p');
//     if (req.method === 'OPTIONS') {
//         return res.sendStatus(200);
//     } else {
//         return next();
//     }
// });


app.use(cors());

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// app.use(bodyParser.urlencoded({ extended: false }));
// app.use(bodyParser.json());
// app.use(bodyParser.urlencoded({ limit: "1gb", extended: true, parameterLimit: 1000000000 }));
// app.use(bodyParser.json({ limit: "1gb"})); 



app.set('trust proxy', true) // trust first proxy

// app.use(session({
//     secret: config.secret,
//     resave: false,
//     saveUninitialized: true,
//     cookie: { maxAge: 60000 }
// }))

require('./server/config/mongoose');
require('./server/config/routes')(app);

// app.use(csrf());
// app.use(function (req, res, next) {
//     res.cookie("XSRF-TOKEN", req.csrfToken());
//     return next();
// });


const server = http.createServer(app);

const apiRouter = express.Router();

apiRouter.get('/', (req, res) => {
    res.json({ name: 'Opal Exercise', date: Date.now(), version: 1.0 });
});

app.use('/api', apiRouter);

app.listen(port, () => console.log(`listening in port ${port}...`));

/**
 * Normalize a port into a number, string, or false.
 */
function normalizePort(val) {
    var port = parseInt(val, 10);

    if (isNaN(port)) {
        // named pipe
        return val;
    }

    if (port >= 0) {
        // port number
        return port;
    }

    return false;
}






