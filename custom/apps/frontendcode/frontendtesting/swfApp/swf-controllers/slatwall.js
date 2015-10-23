/** Public Frontend Controller */
angular.module('slatwall').controller('slatwall', ['$scope','$window','$location','CartFactory','AccountFactory', function($scope, $window, $location, CartFactory, AccountFactory) {
   
   
   /** grab the cart and account that we are acting on the slatwall object so we can access via slatwall.cart... */
   $scope.cart = CartFactory.$getCart(
       	function() {
       	    console.log("Cart Success");
       	},
       	function() {
       		console.log("Error");
       		
       	}).then(function(response){
       		$scope.cart = response.data;
       	}); 
   	
   $scope.cart = AccountFactory.$getAccount(
        function() {
            console.log("Account Success");
        },
        function() {
            console.log("Error");
            
        }).then(function(response){
            $scope.account = response.data;
        });
   
   
   
}]);
