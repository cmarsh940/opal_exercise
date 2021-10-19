const mongoose = require('mongoose');
const Notification = mongoose.model('Notification');
const User = mongoose.model('User');

class NotificationsController {
    view(req, res) {
        console.log("hit view notifications")
        User.findById({ _id: req.params.id }).lean()
            .populate('notifications')
            .exec(function (err, doc) {
                if (err) {
                    console.log('Error finding notifications', err);
                    return res.json(err);
                }
                let notifications = doc.notifications;
                return res.json(notifications);
            });
    }

    create(req, res) {
        req.body._user = req.params.id
        req.body.title = "Another Notification"
        req.body.message = `This is another Notification create at ${Date.now()}`
        Notification.create(req.body, (err, notification) => {
            if (err) {
                console.log("*** ERROR CREATING NOTIFICATION ***", err)
                return res.json(err);
            }
            User.findByIdAndUpdate(req.params.id, {
                $push: { notifications: notification._id }
            }, { new: true }, (err, user) => {
                if (err) {
                    console.log('*** ERROR PUSHING NOTIFICATION TO USER', err);
                    return res.json(err);
                }
                console.log('PUSHED NOTIFICATION TO USER', user);
                return res.json(true);
            });
        });
    }

    update(req, res) {
        Notification.findByIdAndUpdate(
            req.params.id,
            { $set: req.body },
            { new: true },
            (err, notification) => {
                if (err) {
                    return res.json(err);
                }
                return res.json(notification);
            }
        );
    }

    delete(req, res) {
        
        Notification.findByIdAndRemove({ _id: req.params.id }, (err, doc) => {
                if (err) {
                    return res.json(err);
                }
            User.findOneAndUpdate({ email: req.body.email}, { $pull: { notifications: doc._id } }, { new: true }).lean()
                    .exec(function (err, user) {
                        if (err) {
                            return res.json(err);
                        }
                        return res.json(true);
                    })
            });
    }

}

module.exports = new NotificationsController();