"use strict";
angular.module('slatwalladmin').directive('swConfirm', ['$slatwall', '$log', '$compile', '$modal', function($slatwall, $log, $compile, $modal) {
  var confirmationModalController = function($scope, $modalInstance) {
    $scope.deleteEntity = function(entity) {
      $log.debug("Deleting an entity.");
      $log.debug($scope.entity);
      this.close();
    };
    $scope.close = function() {
      $modalInstance.close();
    };
    $scope.cancel = function() {
      $modalInstance.dismiss('cancel');
    };
  };
  var buildConfirmationModal = function(simple, useRbKey, confirmText, messageText, noText, yesText, callback) {
    var confirmKey = "[confirm]";
    var messageKey = "[message]";
    var noKey = "[no]";
    var yesKey = "[yes]";
    var callbackKey = "[callback]";
    var swRbKey = "sw-rbkey=";
    var confirmVal = "<confirm>";
    var messageVal = "<message>";
    var noVal = "<no>";
    var yesVal = "<yes>";
    var callbackVal = "<callback>";
    var startTag = "\"'";
    var endTag = "'\"";
    var startParen = "'";
    var endParen = "'";
    var empty = "";
    var parsedKeyString = "";
    var finishedString = "";
    var templateString = "<div>" + "<div class='modal-header'><a class='close' data-dismiss='modal' ng-click='cancel()'>×</a><h3 [confirm]><confirm></h3></div>" + "<div class='modal-body' [message]>" + "<message>" + "</div>" + "<div class='modal-footer'>" + "<button class='btn btn-sm btn-default btn-inverse' ng-click='cancel()' [no]><no></button>" + "<button class='btn btn-sm btn-default btn-primary' ng-click='[callback]' [yes]><yes></button></div></div></div>";
    $log.debug(templateString);
    if (useRbKey === "true") {
      $log.debug("Using RbKey? " + useRbKey);
      confirmText = swRbKey + startTag + confirmText + endTag;
      messageText = swRbKey + startTag + messageText + endTag;
      yesText = swRbKey + startTag + yesText + endTag;
      noText = swRbKey + startTag + noText + endTag;
      parsedKeyString = templateString.replace(confirmKey, confirmText).replace(messageText, messageText).replace(noKey, noText).replace(yesKey, yesText).replace(callback, callback);
      $log.debug(finishedString);
      finishedString = parsedKeyString.replace(confirm, empty).replace(messageVal, empty).replace(noVal, empty).replace(yesVal, empty);
      $log.debug(finishedString);
      return finishedString;
    } else {
      $log.debug("Using RbKey? " + useRbKey);
      parsedKeyString = templateString.replace(confirmVal, confirmText).replace(messageVal, messageText).replace(noVal, noText).replace(yesVal, yesText);
      finishedString = parsedKeyString.replace(confirmKey, empty).replace(messageKey, empty).replace(noKey, empty).replace(yesKey, empty).replace(callbackKey, callback);
      $log.debug(finishedString);
      return finishedString;
    }
  };
  return {
    restrict: 'EA',
    scope: {
      callback: "&",
      entity: "="
    },
    link: function(scope, element, attr) {
      element.bind('click', function() {
        var useRbKey = attr.useRbKey || "false";
        var simple = attr.simple || false;
        var yesText = attr.yesText || "define.yes";
        var noText = attr.noText || "define.no";
        var confirmText = attr.confirmText || "define.delete";
        var messageText = attr.messageText || "define.delete_message";
        var callback = attr.callback || "onSuccess()";
        var templateString = buildConfirmationModal(simple, useRbKey, confirmText, messageText, noText, yesText, callback);
        var modalInstance = $modal.open({
          template: templateString,
          controller: confirmationModalController
        });
        modalInstance.result.then(function(test) {
          $log.debug("Callback Called");
          scope.callback();
          $log.debug(scope.callback);
          return true;
        }, function() {
          $log.debug("Dismissed");
        });
      });
    }
  };
}]);
