var exec = require('cordova/exec');

exports.loadURL = function(url, room, token , displayName, success, error) {
    exec(success, error, "JitsiPlugin", "loadURL", [url, room ,token , displayName]);
};

exports.destroy = function(success, error) {
    exec(success, error, "JitsiPlugin", "destroy", []);
};