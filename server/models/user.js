const mongoose = require('mongoose');
const bcrypt = require("bcryptjs");
const unique = require('mongoose-unique-validator');

// const root = 'https://s3.amazonaws.com/fitness-you-trust';

const UserSchema = new mongoose.Schema({
    email: {
        type: String,
        lowercase: true,
        required: [true, 'Email cannot be blank'],
        unique: true,
        uniqueCaseInsensitive: true,
        trim: true
    },
    password: {
        type: String,
        required: [true, "Password cannot be blank"],
        minlength: [8, "Password must be at least 8 characters"],
        maxlength: [150, "Password cannot be greater then 150 characters"],
        select: false,
        validate: {
            validator: function (value) {
                return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d$@$!%*?&]{8,50}/.test(value);
            },
            message: "Password must have at least 1 number, and 1 uppercase"
        }
    },
    notifications: {
        type: [
            {
                type: mongoose.Schema.Types.ObjectId,
                ref: "Notification"
            }
        ],
        default: []
    },
}, {
    timestamps: true
});


// Uniqueness
UserSchema.plugin(unique, { message: "Email'{VALUE}' already exists." });

UserSchema.pre('save', function (next) {
    let user = this;

    if (user.isNew) {
        user.password = bcrypt.hashSync(user.password, bcrypt.genSaltSync());
    }

    next();
});


UserSchema.methods.authenticate = function (password) {
    return bcrypt.compareSync(password, this.password);
}

const User = mongoose.model('User', UserSchema);