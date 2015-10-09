/** Public Frontend Controller */
angular.module('slatwalladmin').controller('frontEndController', ['$scope','$window','$location','$slatwall','$timeout','Cart','Account', function($scope, $window, $location, $slatwall, $timeout, Cart, Account) {
    
   console.log("Grabbing Cart and Account");
   /** grab the cart that we are acting on */
   $scope.cart = Cart.get({data:"test data"},function() {}); // get() returns a single entry
   $scope.account = Account.get({data:"test data"}, function() {}); 
   //$scope.cart = new Cart(); //You can instantiate resource class
   //$scope.cart.data = 'TestFirstName';
   
   /*Cart.save($scope.cart, function() {
        //saved firstName
        console.log($scope.cart);
   });*/
   
   /** grab the account that we are acting on */
   
   
   //$scope.account = new Account(); //You can instantiate resource class
    
   //$scope.account.firstName = 'TestFirstName';
   
   /*Account.save($scope.account, function() {
        
   });*/
     

}]);