"use strict";
'use strict';
angular.module('slatwalladmin').controller('preprocessaccount_addaccountpayment', ['$scope', '$compile', function($scope, $compile) {
  var paymentType = {
    aptCharge: "444df32dd2b0583d59a19f1b77869025",
    aptCredit: "444df32e9b448ea196c18c66e1454c46",
    aptAdjustment: "68e3fb57d8102b47acc0003906d16ddd"
  };
  $scope.totalAmountToApply = 0;
  $scope.paymentTypeName = $.slatwall.rbKey('define.charge');
  $scope.paymentTypeLock = true;
  $scope.amount = 0;
  $scope.updatePaymentType = function() {
    angular.forEach($scope.appliedOrderPayment, function(obj, key) {
      if ($scope.paymentType != paymentType.aptAdjustment)
        obj.paymentType = $scope.paymentType;
    });
    if ($scope.paymentType == paymentType.aptCharge) {
      $scope.paymentTypeName = $.slatwall.rbKey('define.charge');
      $scope.paymentTypeLock = true;
    } else if ($scope.paymentType == paymentType.aptCredit) {
      $scope.paymentTypeName = $.slatwall.rbKey('define.credit');
      $scope.paymentTypeLock = true;
    } else if ($scope.paymentType == paymentType.aptAdjustment) {
      $scope.paymentTypeLock = false;
      $scope.paymentTypeName = $.slatwall.rbKey('define.adjustment');
      $scope.amount = 0;
    }
    $scope.updateSubTotal();
  };
  $scope.updateSubTotal = function() {
    $scope.totalAmountToApply = 0;
    angular.forEach($scope.appliedOrderPayment, function(obj, key) {
      if (obj.amount != undefined && !isNaN(obj.amount)) {
        if ($scope.paymentType == paymentType.aptCharge || $scope.paymentType == paymentType.aptAdjustment) {
          if (obj.paymentType == paymentType.aptCharge)
            $scope.totalAmountToApply += parseFloat(obj.amount);
          else if (obj.paymentType == paymentType.aptCredit)
            $scope.totalAmountToApply -= parseFloat(obj.amount);
        } else if ($scope.paymentType == paymentType.aptCredit) {
          if (obj.paymentType == paymentType.aptCharge)
            $scope.totalAmountToApply -= parseFloat(obj.amount);
          else if (obj.paymentType == paymentType.aptCredit)
            $scope.totalAmountToApply += parseFloat(obj.amount);
        }
      }
    });
    $scope.amountUnapplied = (Math.round(($scope.amount - $scope.totalAmountToApply) * 100) / 100);
    $scope.accountBalanceChange = parseFloat($scope.amount);
    if ($scope.paymentType == paymentType.aptCharge)
      $scope.accountBalanceChange = parseFloat($scope.accountBalanceChange * -1);
    else if ($scope.paymentType == paymentType.aptAdjustment)
      $scope.accountBalanceChange += parseFloat($scope.amountUnapplied);
  };
}]);

//# sourceMappingURL=../controllers/preprocessaccount_addaccountpayment.js.map