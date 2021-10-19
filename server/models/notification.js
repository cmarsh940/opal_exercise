const mongoose = require('mongoose');

const NotificationSchema = new mongoose.Schema({
    viewed: {
        type: Boolean,
        default: false
    },
    title: {
        type: String,
        required: true
    },
    message: {
        type: String,
        required: true
    },
    viewedDate: {
        type: Date,
    },
    _user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User"
    }
}, { timestamps: true });

const Notification = mongoose.model('Notification', NotificationSchema);