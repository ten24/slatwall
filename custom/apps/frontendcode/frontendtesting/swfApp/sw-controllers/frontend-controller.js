/** Public Frontend Controller */
angular.module('frontEndApplication').controller('frontEndController', ['$scope','$window','$location','Cart','Account', function($scope, $window, $location, Cart, Account) {
    
   console.log("Grabbing Cart and Account");
   /** grab the cart that we are acting on */
   $scope.cart = Cart.get({data:"test data"},function() {}); // get() returns a single entry
   $scope.account = Account.get({data:"test data"}, function() {}); 
   
   /** grab the account that we are acting on */
   
   
   //$scope.account = new Account(); //You can instantiate resource class
    
   //$scope.account.firstName = 'TestFirstName';
   
   /*Account.save($scope.account, function() {
        
   });*/
     

}]);