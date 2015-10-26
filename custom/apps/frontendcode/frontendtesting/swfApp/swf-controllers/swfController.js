/** Public Frontend Controller */
angular.module('slatwall').controller('swfController', ['$scope','$window','$location','$rootScope', 'CartFactory','AccountFactory', function($scope, $window, $location, $rootScope, CartFactory, AccountFactory) {
   
   var vm = this; 
   vm.cart = {};
   vm.account = {};
   
   
   /** grab the cart and account that we are acting on the slatwall object so we can access via sw.cart... */
   vm.refreshCart = function(){
       CartFactory.$getCart(
           	function() {
           	    console.log("Cart Success");
           	},
           	function() {
           		console.log("Error");
           		
           	}).then(function(response){
                vm.cart = response.data;
           	}); 
   }
   	
   vm.refreshAccount = function(){
        AccountFactory.$getAccount(
            function() {
                console.log("Account Success");
            },
            function() {
                console.log("Error");
                
            }).then(function(response){
                vm.account = response.data;
            });
   }    
       
   $rootScope.$on("refreshAccount", function(event, data){
   	    vm.refreshAccount();
   });
   
   $rootScope.$on("refreshCart", function(event, data){
        vm.refreshCart();
   });
   
   $rootScope.$on("refreshAccountAndCart", function(event, data){
        vm.refreshAccount();
        vm.refreshCart();
   });
   
   
   
   
   
   
   
   
   
   //startup
   vm.refreshAccount();
   vm.refreshCart();
   
}]);
