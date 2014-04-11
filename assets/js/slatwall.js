var ngSlatwall = angular.module('ng-slatwall', []);

//============= START: Controllers ===================

ngSlatwall.controller('admin-entity-preprocessaccount_addaccountpayment', function($scope, $compile) {

	$scope.updateSubTotal = function() {
		$scope.totalAmountToApply = 0;

		//Loop through all the amount fields and create a running subtotal
		angular.forEach($scope.appliedOrderPayment, function(obj, key){
			//Charge / Credit condition for subtotal
			if(obj.chargeType=='444df32dd2b0583d59a19f1b77869025' && obj.amount != undefined)
				$scope.totalAmountToApply += parseFloat(obj.amount);
			else if(obj.chargeType=='444df32e9b448ea196c18c66e1454c46' && obj.amount != undefined)
				$scope.totalAmountToApply -= parseFloat(obj.amount);
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
