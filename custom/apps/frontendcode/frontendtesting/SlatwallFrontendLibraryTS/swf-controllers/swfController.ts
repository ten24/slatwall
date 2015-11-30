/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwallFrontend {

    export class swfController {
        public cart = {};
        public account = {};
        public static $inject = ['$scope', '$window', '$location', '$rootScope', 'CartFactory', 'AccountFactory'];
        constructor(private $scope: ng.IScope, private $window: any, private $location: any, public $rootScope: any, private CartFactory: any, private AccountFactory: any) {
           this.$scope = $scope;
           this.$window = $window;
           this.$location = $location;
           this.$rootScope = $rootScope
           this.CartFactory = CartFactory;
           this.AccountFactory = AccountFactory;
           
           //startup
           console.log("Getting cart and account");
           this.refreshAccount();
           this.refreshCart();
           
           //** events */
           this.$rootScope.$on("refreshAccount", (event, data)=>{
                this.refreshAccount();
           });
        
           this.$rootScope.$on("refreshCart", function(event, data){
                    this.refreshCart();
           });
            
           this.$rootScope.$on("refreshAccountAndCart", function(event, data){
                    this.refreshAccount();
                    this.refreshCart();
           });
           
        }
        /** grab the cart and account that we are acting on the slatwall object so we can access via cart... */
        public refreshCart =():void => {
            this.CartFactory.$getCart(
                function() {
                    console.log("Cart Success");
                },
                function() {
                    console.log("Error");
                    
                }).then(function(response){
                    this.cart = response.data;
                }); 
        };
   	
        public refreshAccount =():void =>{
            this.AccountFactory.$getAccount(
                function() {
                    console.log("Account Success");
                },
                function() {
                    console.log("Error");
                    
                }).then(function(response){
                    this.account = response.data;
                });
        };  
        
       
}
angular.module('slatwallFrontend').directive('swfController',['$scope', '$window', '$location', '$rootScope', 'CartFactory', 'AccountFactory', ($scope, $window, $location, $rootScope, CartFactory, AccountFactory) => new swfController($scope, $window, $location, $rootScope, CartFactory, AccountFactory)]); 

