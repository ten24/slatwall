/** Public Frontend Controller */
angular.module('slatwall').controller('slatwall', ['$scope','$window','$location','Cart','Account', function($scope, $window, $location, Cart, Account) {

   /** grab the cart that we are acting on */
   $scope.cart = Cart.get({},function() {}); // get() returns a single entry
   $scope.account = Account.get({}, function() {}); 
   
}]);
