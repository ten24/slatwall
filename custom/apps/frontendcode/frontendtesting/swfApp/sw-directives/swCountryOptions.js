/**
 * This directive will create a form logging in a user.
 * 
 */
angular.module('frontEndApplication')
    .directive('swCountryOptions', [
        '$slatwall',
        'frontEndService',
        function($slatwall, hibachiScopeService) {
            return {
                restrict: 'E',
                transclude: true,
                scope: {
                	addressObject: "=",
                	statesFunction: ""
                },
                templateUrl: '/custom/apps/slatwallcms/incstore/assets/js/sw-directive-partials/swCountryOptionsPartial.html',
                replace: false,
                link: 
                    function(scope, element, attrs) {
                    	scope.addressType = attrs.addressType;
                    	scope.stateFunction = attrs.stateFunction || "";
                    	scope.stateFunction("US");
                    	
                        console.log("initializing country options");
                        
                        /** updates the country based on user selection. cascades to states to update the states based on country. */
                        scope.updateCountry = function(selectedCountry) {
                            console.log("Selected country:", selectedCountry);
                            scope.addressObject.countrycode = selectedCountry.value;
                            
                            //console.log("Updating states based on country code:", selectedCountry.value);
                            //$slatwall.getStatesByCountryCode(selectedCountry.value, scope.stateOptionsSuccess, $scope.countryError);
                        }       
                    }
            };
        }
    ]);