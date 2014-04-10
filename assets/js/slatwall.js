var ngSlatwall = angular.module('ng-slatwall', []);

ngSlatwall.controller('admin-entity-preprocessaccount_addaccountpayment', function($scope, $compile) {
	console.log($compile);
	$scope.updateSubTotal = function() {
		$scope.totalAmountToApply = 0;
		
		//Loop through all the amount fields and create a running subtotal
		angular.forEach($scope.appliedOrderPayment, function(value, key){
			$scope.totalAmountToApply += parseFloat(value);
	    });
	}
});

//Service with scope and compile dependencies
ngSlatwall.factory('reloadService', ["$rootScope", "$compile", function ($rootScope, $compile) {
    return {
        recompile: function () {
            $compile($('#adminModal'))($rootScope); // Recompile the admin modal for the new elements we added
            $rootScope.$digest(); // Processes all wathers for the current scope
            return true;
        }
    }
}]);


function angularCompileModal() {
	//get your angular controller
    var elem = angular.element(document.querySelector('[ng-controller]'));
    
    //get the injector.
    var injector = elem.injector();
    
    //get the service.
    var myService = injector.get('reloadService');

    myService.recompile();
}