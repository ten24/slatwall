const RetryProxyES5 = require('../lib/RetryProxyES5');

var someLazyLoadedFunction;

function load_LazyFunction() {
    setTimeout(() => {
        global['someLazyLoadedFunction'] = (a1, a2) => {
            console.warn("Received args", a1, a2);
            return a1 + "---" + a2;
        }
    }, 2000);
}

function testFailsafe() {
    new RetryProxyES5.RetryProxyES5(global, 'someLazyLoadedFunction')
        .setArgs("something", "anotherthing", 123)
        .then((res) => {
            console.log("Got response:", res);
            return res;
        }, (error) => {
            console.log("Got error:", error);
            return error;
        });
}


testFailsafe();

load_LazyFunction();