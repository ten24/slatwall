require('../lib/RetryProxyES5');


global['myBadFunc'] = () => {
    var rand = Math.random();
    if (rand < 0.9) {
        throw rand;
    } else {
        console.log("result", rand);
        return rand;
    }
};

function testFailsafe() {

    new RetryProxyES5(global, 'myBadFunc')
        .setArgs("cveveve", "wrvev")
        .then((res) => {
            console.log("Got response:", res);
            return res;
        }, (error) => {
            console.log("Got error:", error);
            return error;
        });
}

function testFailsafe2() {

    new RetryProxyES5.RetryProxyES5(global, 'thisWillFail', 1, 10, true)
        .setArgs("cveveve", "wrvev")
        .then((res) => {
            console.log("Got response:", res);
            return res;
        }, (error) => {
            console.log("Got error:", error);
            return error;
        });
}




testFailsafe();
testFailsafe2();