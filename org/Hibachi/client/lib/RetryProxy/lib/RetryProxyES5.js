"use strict";
var RetryProxyES5 = (function () {
    function RetryProxyES5(context, func, delay, maxAttempt, debugMode) {
        if (context === void 0) { context = console; }
        if (func === void 0) { func = 'log'; }
        if (delay === void 0) { delay = 100; }
        if (maxAttempt === void 0) { maxAttempt = 500; }
        if (debugMode === void 0) { debugMode = false; }
        this.context = context;
        this.func = func;
        this.delay = delay;
        this.maxAttempt = maxAttempt;
        this.debugMode = debugMode;
        this.attempted = 0;
        this.resolve = function (whatever) { return whatever; };
        this.reject = function (whatever) { return whatever; };
        this.args = [];
        this.resolve = function () { };
    }
    RetryProxyES5.prototype.setArgs = function (args) {
        this.args = args;
        return this;
    };
    RetryProxyES5.prototype.then = function (resolve, reject) {
        this.resolve = resolve;
        this.reject = reject;
        this.run();
        return this;
    };
    RetryProxyES5.prototype.run = function () {
        var _this = this;
        this.attempted++;

        try {
            return this.resolve(this.context[this.func].apply(this.context, this.args));
        }
        catch (e) {
            if (this.attempted <= this.maxAttempt) {
                
                if (this.debugMode) {
                    console.warn('retrying ->', this.func, ", attempt ->", this.attempted, "error ", e);
                }
                
                setTimeout(function () { return _this.run(); }, this.delay);
            }
            else {
                return this.reject("Max attempt reached");
            }
        }
    };
    return RetryProxyES5;
}());
