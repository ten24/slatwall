/**
 * This directive will create a form for editing and saving a billing address including handling errors.
 * 
 * Usage: <sw:AddressForm prefix="newOrderPayment.address" field-list="streetAddress, street2address, postalCode, stateCode, countryCode", name="Billing Address">
 * 			   </sw:AddressForm>
 * 
 */
angular.module('hibachiScope')
    .directive('swBillingAddressForm', [
        '$slatwall',
        'hibachiScopeService',
        function($slatwall, hibachiScopeService) {
            return {
                restrict: 'E',
                transclude: true,
                scope: {
                    prefix: "@",
                    fieldList: "=",
                    formName: "@"
                },
                templateUrl: '/custom/apps/slatwallcms/incstore/assets/js/ng-directives/swBillingAddressPartial.html',
                replace: true,
                link: 
                		function(scope, element, attrs) {
                			console.log("This is a test.");
                			
                			
                			
                		}
            };
        }
    ]);