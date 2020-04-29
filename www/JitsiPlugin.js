var exec = require('cordova/exec');

exports.loadURL = function(url, key, displayName, isInvisible, success, error) {
    exec(success, error, "JitsiPlugin", "loadURL", [url, key, displayName , !!isInvisible]);
};

exports.destroy = function(success, error) {
    exec(success, error, "JitsiPlugin", "destroy", []);
};