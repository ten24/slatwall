angular.module('MyModule', [])
	.controller('MyMainController', function($scope) {
			$scope.name = "Ian";
			$scope.sayHello = 
				function() {
					$scope.greeting = "Hello " + $scope.name; 
				} 
	});
