/**
 * This directive will create a form for displaying and editing promotion codes
 * 
 */
angular.module('hibachiScope')
    .directive('swPromoCodeDisplay', [
        '$slatwall',
        'hibachiScopeService',
        function($slatwall, hibachiScopeService) {
            return {
                restrict: 'E',
                transclude: true,
                scope: false,
                templateUrl: '/custom/apps/slatwallcms/incstore/assets/js/sw-directive-partials/swPromoCodeDisplayPartial.html',
                replace: false,
                link: 
                    function(scope, element, attrs) {
                        console.log("Promo Code Display");
                        //$scope.promoCode = "";
                        /**
                         * removes a promotion code
                         */
                        scope.removePromoCode = function(promotionCodeID) {
                        	scope.$emit('loginLoaderOn', "on");
                            console.log("Removing Promo", promotionCodeID);
                    
                            var data = {
                                "promotionCode": promotionCodeID,
                                "orderID": scope.cart.orderID || ""
                            };
                            hibachiScopeService.removePromotionCode(data, scope.removePromoSuccessCallback, scope.removePromoErrorCallback);
                        };
                        
                        //CALLBACKS
                        /**
                         *promo removal success
                         */
                        scope.removePromoSuccessCallback = function(data) {
                        	scope.$emit('loginLoaderOff', "off");
                            console.log(data);
                            scope.getCart(scope.cartSuccessCallback, scope.errorCallback);
                        };
                        /**
                         *promo removal error
                         */
                        scope.removePromoErrorCallback = function(data) {
                        	scope.$emit('loginLoaderOff', "off");
                            console.log("error removing");
                        };
                        
                        
                    }//<--end link
            };
        }
    ]);