/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    //model
    class Alert {
        constructor(msg, type) {
            this.msg = msg;
            this.type = type;
        }
    }
    slatwalladmin.Alert = Alert;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=alert.js.map
