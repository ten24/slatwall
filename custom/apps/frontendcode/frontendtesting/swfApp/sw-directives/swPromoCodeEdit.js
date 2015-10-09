/**
 * This directive will create a form for displaying and editing promotion codes
 * 
 */
angular.module('hibachiScope')
    .directive('swPromoCodeEdit', [
        '$slatwall',
        'hibachiScopeService',
        function($slatwall, hibachiScopeService) {
            return {
                restrict: 'EA',
                transclude: true,
                scope: false,
                templateUrl: '/custom/apps/slatwallcms/incstore/assets/js/sw-directive-partials/swPromoCodeEditPartial.html',
                replace: false,
                link: 
                    function(scope, element, attrs) {
                      console.log("Promo Code Edit");
                      scope.promoCode = "";
                      scope.promotionCodeError = "";
                       
                       /**
                         * public:cart.addPromotionCode
                         */
                        scope.addPromotionCode = function(promoCode) {
                            console.log("Adding promotion code:", promoCode)
                            if (promoCode == ""){
                                scope.promotionCodeError = "enter a valid promotion code";
                            }else{
                            	scope.$emit('loginLoaderOn', "on");
                            	console.log("ngPromo", scope.cart);
                                var jsonData = {
                                    "promotionCode": promoCode
                                };
                                hibachiScopeService.addPromotionCode(jsonData, scope.promoSuccessCallback, scope.promoErrorCallback);
                            }
                        };
                        
                        
                        /**
                         ** CALLBACK FUNCTIONS
                         **
                         **/
                        
                        /**
                         *add promo success
                         */
                        scope.promoSuccessCallback = function(data) {
                        	console.log("Promo Data: ", data);
                        	if (data.failureActions.length > 0){
                        		scope.promotionCodeError = "that promotion code is invalid";
                        	}
                        	scope.$emit('loginLoaderOff', "off");
                            scope.getCart(scope.cartSuccessCallback, scope.errorCallback);
                        };
                        /**
                         * add promo error
                         */
                        scope.promoErrorCallback = function(data) {
                        	scope.$emit('loginLoaderOff', "");
                            console.log(data);
                        };
                        
                        
                    }//<--end link
            };
        }
    ]);