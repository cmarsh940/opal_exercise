const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
const secret = require('../config/config').jwt_secret;

const User = mongoose.model('User');
const Notification = mongoose.model('Notification');

const config = require("../config/config");


class UsersController {
    authenticate(req, res) {
        console.log('hit user auth', req.body);
        User.findOne({ email: req.body.email }).select("+password")
            .populate('notifications')
            .exec((err, user) => {
                if (!user || err) {
                    console.log("____ AUTHENTICATE ERROR ____", err);
                    return res.status(400).json({ error: err })
                }

                if (user && user.authenticate(req.body.password)) {

                    let token = jwt.sign({ user }, secret);

                    // req.session.user = {
                    //     _id: user._id,
                    //     email: user.email,
                    //     notifications: user.notifications,
                    //     token: token,
                    //     expiresIn: 604800,
                    // };
                    // return res.json(req.session.user);
                    console.log('authenticated')
                    return res.json(user)

                } else {
                    console.log("_____ ERROR _____");
                    return res.json({
                        errors: {
                            login: {
                                message: 'Invalid credentials'
                            }
                        }
                    });
                }
            })
    }

    create(req, res) {
        console.log("hit create user")
        if (req.body.password != req.body.confirm_pass) {
            return res.json({
                errors: {
                    password: {
                        message: "Your passwords do not match"
                    }
                }
            })
        }
        User.create(req.body, (err, user) => {
            if (err) {
                console.log("*** CREATING USER ERROR", err);
                return res.json(err);
            }
            let notification = {
                title: 'Welcome',
                message: 'Welcome! Let us know if there is anything we can do to make your experience as easy as possible.',
                _user: user._id
            }
            Notification.create(notification, function (err, notification) {
                if (err) {
                    console.log("___ CREATE WELCOME NOTIFICATION ERROR ___", err);
                    return res.json(err);
                }
                User.findByIdAndUpdate(user._id, {
                    $push: { notifications: notification._id }
                }, { new: true }).lean()
                    .populate('notifications')
                    .exec(function (err, updatedUser) {
                    if (err) {
                        console.log("___ UPDATE FINDING USER ERROR ___", err);
                        return res.json(err);
                    }
                    req.user = updatedUser
                    return res.json(updatedUser);
                })
            })
        })
    }

    show(req, res, next) {
        console.log('hit show');
        if (req.params.id == null) {
            return res.json(err)
        } else {
            User.findById({ _id: req.params.id }).lean()
                .populate('notifications')
                .exec(function (err, doc) {
                    if (err) {
                        return res.json(err);
                    }
                    return res.json(doc);
                });
        }
    }


    update(req, res) {
        User.findByIdAndUpdate(
            { _id: req.params.id },
            { $set: req.body },
            { new: true }).lean()
            .populate('notifications')
            .exec(function (err, user) {
                if (err) {
                    return res.json(err);
                }

                return res.json(user);
            }
            );
    }
}

module.exports = new UsersController();
