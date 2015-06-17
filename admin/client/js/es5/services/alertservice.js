"use strict";
var slatwalladmin;
(function(slatwalladmin) {
  var AlertService = (function() {
    function AlertService($timeout, alerts) {
      var _this = this;
      this.$timeout = $timeout;
      this.alerts = alerts;
      this.get = function() {
        return _this.alerts || [];
      };
      this.addAlert = function(alert) {
        _this.alerts.push(alert);
        _this.$timeout(function(alert) {
          _this.removeAlert(alert);
        }, 3500);
      };
      this.addAlerts = function(alerts) {
        alerts.forEach(function(alert) {
          _this.addAlert(alert);
        });
      };
      this.removeAlert = function(alert) {
        var index = _this.alerts.indexOf(alert, 0);
        if (index != undefined) {
          _this.alerts.splice(index, 1);
        }
      };
      this.getAlerts = function() {
        return _this.alerts;
      };
      this.formatMessagesToAlerts = function(messages) {
        var alerts = [];
        for (var message in messages) {
          var alert = new slatwalladmin.Alert();
          alert.msg = messages[message].message;
          alert.type = messages[message].messageType;
          alerts.push(alert);
          if (alert.type === 'success' || alert.type === 'error') {
            $timeout(function() {
              alert.fade = true;
            }, 3500);
            alert.dismissable = false;
          } else {
            alert.fade = false;
            alert.dismissable = true;
          }
        }
        return alerts;
      };
      this.removeOldestAlert = function() {
        _this.alerts.splice(0, 1);
      };
      this.alerts = [];
    }
    AlertService.$inject = ['$timeout'];
    return AlertService;
  })();
  slatwalladmin.AlertService = AlertService;
})(slatwalladmin || (slatwalladmin = {}));
var slatwalladmin;
(function(slatwalladmin) {
  angular.module('slatwalladmin').service('alertService', slatwalladmin.AlertService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/alertservice.js.map