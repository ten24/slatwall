var ngSlatwall = angular.module('ng-slatwall', []);

//============= START: Controllers ===================

ngSlatwall.controller('admin-entity-preprocessaccount_addaccountpayment', function($scope, $compile) {
	$scope.totalAmountToApply = 0; //Default value to show on new form
	$scope.paymentTypeName = "Charge" //Default payment type
	$scope.paymentTypeLock = true; //Used to lock down the order payment type dropdowns

	$scope.updatePaymentType = function() {
		//Change all order payment types here
		angular.forEach($scope.appliedOrderPayment, function(obj, key) {
			obj.paymentType=$scope.paymentType;
		});

		
		if($scope.paymentType=="444df32dd2b0583d59a19f1b77869025") {
			$scope.paymentTypeName = "Charge"
			$scope.paymentTypeLock = true;
		} else if($scope.paymentType=="444df32e9b448ea196c18c66e1454c46") {
			$scope.paymentTypeName = "Credit"
			$scope.paymentTypeLock = true;
		} else if($scope.paymentType=="68e3fb57d8102b47acc0003906d16ddd") {
			$scope.paymentTypeLock = false;
			$scope.paymentTypeName = "Adjustment"
			$scope.amount = 0;
		}
		
		//Update the subtotal now that we changed the payment type
		$scope.updateSubTotal();

	}


	$scope.updateSubTotal = function() {
		$scope.totalAmountToApply = 0; //Reset the subtotal before we loop
		$scope.unassignedWarning = "";

		//Loop through all the amount fields and create a running subtotal
		angular.forEach($scope.appliedOrderPayment, function(obj, key) {
			//Don't count the field if its undefied or not a number
			if(obj.amount != undefined && !isNaN(obj.amount)) {
				//Charge / adjustment condition for subtotal
				if($scope.paymentType=="444df32dd2b0583d59a19f1b77869025" || $scope.paymentType == '68e3fb57d8102b47acc0003906d16ddd') {
					if(obj.paymentType=='444df32dd2b0583d59a19f1b77869025')
						$scope.totalAmountToApply += parseFloat(obj.amount);
					else if(obj.paymentType=='444df32e9b448ea196c18c66e1454c46')
						$scope.totalAmountToApply -= parseFloat(obj.amount);

				//Credit condition for subtotal
				} else if($scope.paymentType=="444df32e9b448ea196c18c66e1454c46") {
					if(obj.paymentType=='444df32dd2b0583d59a19f1b77869025')
						$scope.totalAmountToApply -= parseFloat(obj.amount);
					else if(obj.paymentType=='444df32e9b448ea196c18c66e1454c46')
						$scope.totalAmountToApply += parseFloat(obj.amount);
				}
			}
	    });

		//The amount not applied to an order
	    $scope.amountUnapplied = (Math.round(($scope.amount - $scope.totalAmountToApply) * 100) / 100);
		$scope.accountBalanceChange = $scope.amount;
		
		//Switch the account balance display amount to a negative if you are doing a charge
		if($scope.paymentType=='444df32dd2b0583d59a19f1b77869025')
			$scope.accountBalanceChange = $scope.accountBalanceChange * -1; //If charge, change to neg since we are lowering account balance
		else if($scope.paymentType=='68e3fb57d8102b47acc0003906d16ddd')
			$scope.accountBalanceChange += $scope.amountUnapplied; //If adjustment, use the amount unapplied to determine the balance change

	}
});

//============= END: Controllers ===================

//============= START: Services ===================

//reloadService to re-compile #adminModal element into Angular
ngSlatwall.factory('reloadService', ["$rootScope", "$compile", function ($rootScope, $compile) {
    return {
        recompile: function () {
            $compile($('#adminModal'))($rootScope); // Recompile the admin modal for the new elements we added
            $rootScope.$digest(); // Processes all watchers for the current scope
            return true;
        }
    }
}]);

//============= END: Services ===================

//============= START: Helper Functions ===================

//Compiles the new modal form elements into the angular scope using the angular reloadService
function angularCompileModal() {
	//get your angular controller
    var elem = angular.element(document.querySelector('[ng-controller]'));
    
    //get the injector.
    var injector = elem.injector();
    
    //get the service.
    var myService = injector.get('reloadService');

    myService.recompile();
}

//============= END: Helper Functions ===================
