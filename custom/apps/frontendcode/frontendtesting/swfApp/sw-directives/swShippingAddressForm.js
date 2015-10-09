/**
 * This directive will create a form for editing and saving an address including handling errors.
 * 
 * Usage: <sw:ShippingAddressForm prefix="newOrderPayment.address" field-list="streetAddress, street2address, postalCode, stateCode, countryCode", name="Billing Address">
 * 			   </sw:ShippingAddressForm>
 * 
 */
angular.module('hibachiScope')
    .directive('swShippingAddressForm', [
        '$slatwall',
        'hibachiScopeService',
        '$templateRequest',
        '$compile',
        function($slatwall, hibachiScopeService, $templateRequest, $compile) {
        	
            return {
                restrict: 'E',
                transclude: true,
                scope: {
                	addressType: "=",
                	title: "@",
                	addressToggle: "@"
                },
                replace: true,
                link: 
        		function(scope, element, attrs) {
        			
        			 attrs.$observe('addressToggle', function() {
                         scope.addressToggle = scope.$eval(attrs.addressToggle);
                         console.log("toggle called on address", scope.addressToggle);
                     });
        			
        			scope.addressToggle = attrs.addressToggle;
        			/** encapsulates the getting of the template */
        			var getAddressTemplate = function(name){
                        var address = "/custom/apps/slatwallcms/incstore/assets/js/sw-directive-partials/"+name+".html";
                        $templateRequest(address)
                            .then(function(html){
                                var template = angular.element(html);
                                element.append(template);
                                $compile(template)(scope);
                            });
                    }
        			
        			/** figures out which address type we are to display */
        			var addressType = attrs.addressType || "Address";
        			
        			switch(addressType){
        				case "billingAddress":
        				    getAddressTemplate("swBillingAddressFormPartial");
        				    scope.billingAddress = {};
        				    break;
        				case "shippingAddress":
        				    getAddressTemplate("swShippingAddressFormPartial");
        				    scope.shippingAddress = {};
        				    break;
        				case "accountAddress":
        				    getAddressTemplate("swAccountAddressFormPartial");
        				    scope.accountAddress = {};
        				    break;
        				default:
        				    getAddressTemplate("swAddressFormPartial");
        				    scope.address = {}; 
        				    break;
        			}
                }
            };
        }
    ]);