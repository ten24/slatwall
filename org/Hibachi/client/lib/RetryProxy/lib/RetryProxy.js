"use strict";
var RetryProxy = (function () {
    function RetryProxy(context, func, delay, cnt, silent) {
        var _this = this;
        if (context === void 0) { context = console; }
        if (func === void 0) { func = 'log'; }
        if (delay === void 0) { delay = 200; }
        if (cnt === void 0) { cnt = 500; }
        if (silent === void 0) { silent = true; }
        this.context = context;
        this.func = func;
        this.delay = delay;
        this.cnt = cnt;
        this.silent = silent;
        this.wait = function () { return new Promise(function (resolve) { return setTimeout(resolve, _this.delay); }); };
        this.attempt = function () { return new Promise(function (resolve) {
            var _a;
            return resolve((_a = _this.context)[_this.func].apply(_a, _this.args));
        }); };
        this.args = [];
    }
    RetryProxy.prototype.setArgs = function () {
        var args = [];
        for (var _i = 0; _i < arguments.length; _i++) {
            args[_i] = arguments[_i];
        }
        this.args = args;
        return this;
    };
    RetryProxy.prototype.run = function () {
        var _this = this;
        return new Promise(function (resolve, reject) {
            return _this.attempt()
                .then(resolve)
                .catch(function (e) {
                if (--_this.cnt > 0) {
                    console.log("Called " + _this.context + "." + _this.func + "(), " + _this.cnt + "th time.\nGot Error --> " + e.message + ",\nRetrying in: --> " + _this.delay);
                    return _this.wait().then(_this.run.bind(_this, null)).then(resolve).catch(reject);
                }
                return _this.silent ? resolve(e) : reject(e);
            });
        });
    };
    return RetryProxy;
}());
