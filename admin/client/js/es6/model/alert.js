/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    //model
    var Alert = (function () {
        function Alert(msg, type) {
            this.msg = msg;
            this.type = type;
        }
        return Alert;
    })();
    slatwalladmin.Alert = Alert;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../model/alert.js.map