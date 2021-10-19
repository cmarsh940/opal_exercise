const Users = require('../controllers/users');
const Notifications = require('../controllers/notifications');

const jwt = require('jsonwebtoken');
const secret = require('./config').jwt_secret;


async function validJWTNeeded(req, res, next) {
    if (req.headers['authorization']) {
        try {
            let Authorization = await req.headers['authorization'].split(' ');
            if (Authorization[0] !== 'Bearer') {
                console.log("Not Valid");
                return res.status(401).send();
            } else {
                req.jwt = await jwt.verify(Authorization[1], secret);
                console.log("NEXT");
                return next();
            }

        } catch (err) {
            if (err.name === 'TokenExpiredError') {
                console.log("ERROR TOKEN EXIRED", err);
                return res.json(err);
            } else {
                console.log("ERROR", err)
                return res.status(403).send();
            }
        }
    }
    else {
        console.log("ELSE");
        return res.status(401).send();
        // return next();
    }
};


module.exports = function (app) {

    // USER
    app.post('/api/users/login', Users.authenticate);
    app.post('/api/users', Users.create);

    app.get('/api/users/:id', [
        validJWTNeeded,
        Users.show
    ]);

    app.post('/api/notifications/:id', [
        // validJWTNeeded,
        Notifications.create
    ]);
    app.get('/api/notifications/:id', [
        // validJWTNeeded,
        Notifications.view
    ]);
    app.put('/api/notifications/:id', [
        // validJWTNeeded,
        Notifications.update
    ]);
    app.delete('/api/notifications/:id', [
        // validJWTNeeded,
        Notifications.delete
    ]);

}