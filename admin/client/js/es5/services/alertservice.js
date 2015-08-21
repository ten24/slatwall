"use strict";
var slatwalladmin;
(function(slatwalladmin) {
  var AlertService = function AlertService($timeout, alerts) {
    var $__0 = this;
    this.$timeout = $timeout;
    this.alerts = alerts;
    this.get = (function() {
      return $__0.alerts || [];
    });
    this.addAlert = (function(alert) {
      $__0.alerts.push(alert);
      $__0.$timeout((function(alert) {
        $__0.removeAlert(alert);
      }), 3500);
    });
    this.addAlerts = (function(alerts) {
      alerts.forEach((function(alert) {
        $__0.addAlert(alert);
      }));
    });
    this.removeAlert = (function(alert) {
      var index = $__0.alerts.indexOf(alert, 0);
      if (index != undefined) {
        $__0.alerts.splice(index, 1);
      }
    });
    this.getAlerts = (function() {
      return $__0.alerts;
    });
    this.formatMessagesToAlerts = (function(messages) {
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
    });
    this.removeOldestAlert = (function() {
      $__0.alerts.splice(0, 1);
    });
    this.alerts = [];
  };
  ($traceurRuntime.createClass)(AlertService, {}, {});
  AlertService.$inject = ['$timeout'];
  slatwalladmin.AlertService = AlertService;
})(slatwalladmin || (slatwalladmin = {}));
var slatwalladmin;
(function(slatwalladmin) {
  angular.module('slatwalladmin').service('alertService', slatwalladmin.AlertService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/alertservice.js.map