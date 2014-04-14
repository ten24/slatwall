var ngSlatwall = angular.module('ng-slatwall', []);

//============= START: Controllers ===================

ngSlatwall.controller('admin-entity-preprocessaccount_addaccountpayment', function($scope, $compile) {
	$scope.totalAmountToApply = 0; //Default value to show on new form
	
	$scope.updateSubTotal = function() {
		$scope.totalAmountToApply = 0; //Reset the subtotal before we loop

		//Loop through all the amount fields and create a running subtotal
		angular.forEach($scope.appliedOrderPayment, function(obj, key) {
			//Reset the object value to null if there is no value or only value is NaN
			if(obj.amount.length == 0 || (isNaN(obj.amount) && obj.amount.length == 1)) {
					obj.amount = null;
			} else {
				//Trim off invalid characters
				if(obj.amount.length > 1 && isNaN(obj.amount))
					obj.amount = obj.amount.substring(0, obj.amount.length - 1);
				
				//Charge / Credit condition for subtotal
				if(obj.paymentType=='444df32dd2b0583d59a19f1b77869025')
					$scope.totalAmountToApply += parseFloat(obj.amount);
				else if(obj.paymentType=='444df32e9b448ea196c18c66e1454c46')
					$scope.totalAmountToApply -= parseFloat(obj.amount);
			}
	    });
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
