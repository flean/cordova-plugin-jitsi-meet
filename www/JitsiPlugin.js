var exec = require('cordova/exec');

var jitsiplugin = {
    loadURL: function(url, key, isInvisible, success, error) {
        exec(success, error, "JitsiPlugin", "loadURL", [url, key, !!isInvisible]);
    },
    destroy: function(success, error) {
        exec(success, error, "JitsiPlugin", "destroy", []);
    }
};

module.exports = jitsiplugin;