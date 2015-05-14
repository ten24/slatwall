/*services return promises which can be handled uniquely based on success or failure by the controller*/
'use strict';
angular.module('slatwalladmin').factory('alertService', [
    '$timeout',
    function ($timeout) {
        var _alerts = [];
        var alertService = {
            addAlert: function (alert) {
                _alerts.push(alert);
                $timeout(function () {
                    _alerts.splice(0, 1);
                }, 3500);
            },
            addAlerts: function (alerts) {
                for (var alert in alerts) {
                    _alerts.push(alerts[alert]);
                    $timeout(function () {
                        _alerts.splice(0, 1);
                    }, 3500);
                }
            },
            formatMessagesToAlerts: function (messages) {
                var alerts = [];
                for (var message in messages) {
                    var alert = {
                        msg: messages[message].message,
                        type: messages[message].messageType
                    };
                    alerts.push(alert);
                    if (alert.type === 'success' || alert.type === 'error') {
                        $timeout(function () {
                            alert.fade = true;
                        }, 3500);
                        alert.dismissable = false;
                    }
                    else {
                        alert.fade = false;
                        alert.dismissable = true;
                    }
                }
                return alerts;
            },
            getAlerts: function () {
                return _alerts;
            },
            removeAlert: function (alert) {
                for (var i in _alerts) {
                    if (_alerts[i] === alert) {
                        delete _alerts[i];
                    }
                }
            },
            removeOldestAlert: function () {
                _alert.splice(0, 1);
            }
        };
        return alertService;
    }
]);

//# sourceMappingURL=../services/alertservice.js.map