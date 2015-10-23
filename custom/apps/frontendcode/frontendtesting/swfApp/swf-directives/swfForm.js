/**
 * This directive will create a form logging in a user.
 * 
 */
angular.module('slatwall').directive('swfForm', [
        'ProcessObject',
        'AccountFactory',
        'CartFactory',
        '$compile', 
        '$templateCache', 
        function(ProcessObject, AccountFactory, CartFactory, $compile, $templateCache) {
             
            return {
                restrict: 'E',
                transclude: true,
                controller: 
                	function($scope, $element, $attrs) { 
                		 
                        $scope.children = [];
                        $scope.hiddenFields = $attrs.hiddenFields  || [];
                        $scope.entityName   = $attrs.entityName    || "Account";
                        $scope.processObject= $attrs.processObject || "login";
                        $scope.action       = $attrs.action;
                        
                        var entityName = $attrs.processObject.split("_")[0];
                        if (entityName == "Order") {entityName = "Cart"};
                        var processObject = $attrs.processObject.split("_")[1];
                        
                        
                        if (processObject == undefined || entityName == undefined){
                        	throw("ProcessObject Nameing Exception");
                        }
                        /*Retrieves the process object so we can get data.
                        **/
                        var processObj = ProcessObject.get({ entityName: entityName, processObject: processObject },
                        function() {
                            processObj.processObject["meta"] = [];
                            for (var p in processObj.processObject["PROPERTIES"]){
                                 
                                 angular.forEach(processObj.processObject["entityMeta"], function(n){
                                     if (n["NAME"] == processObj.processObject["PROPERTIES"][p]["NAME"]){
                                         processObj.processObject["meta"].push(n);
                                     }
                                 }, $scope);
                            }
                            
                            var processObjName = processObj.processObject["NAME"].split(".");
                            processObjName = processObjName[processObjName.length-1];
                            
                            processObj.processObject["NAME"] = processObjName;
                            return processObj.processObject;
                        });
                        
                        /** We use these for our models */
                        $scope.formData = {};
                       
                        //grab all the data and submit the form using the endpoint specified on the form.
                        var submitFunction = $scope.action;
                        this.submit = function(){
                        	console.log("Submitting");
                        	angular.forEach(AccountFactory, function(val, key){
                        		if (key == submitFunction){
                        			AccountFactory[key](this.formData).then(function(result){
                                        console.log("Account Action Result", result);
                                        if (result.data.failureActions.length || result.status != 200){
                                            console.log("Has errors!");
                                            $scope.hasFormErrors = true;
                                            $scope[$scope.processObject].$invalid = true;
                                        }
                                    });
                        		}
                        	}, $scope);
                        	
                        	angular.forEach(CartFactory, function(val, key){
                                if (key == submitFunction){
                                    CartFactory[key](this.formData).then(function(result){
                                    	console.log("Cart Action Result", result);
                                    	if (result.data.failureActions || result.status != 200){
                                    		console.log("Has errors!");
                                    		$scope.hasFormErrors = true;
                                    		$scope[$scope.processObject].$invalid = true;
                                    	}
                                    });
                                }
                            }, $scope);
                        }
                        
                },
                scope: {
                    entityName: "@?",
                    processObject: "@?",
                    hiddenFields: "=?",
                    action: "&?",
                    actions: "@?",
                    formClass: "@?"
                },
                template: "<ng-form class='{{formClass}}' name='{{processObject}}' ng-transclude></ng-form>",
                link: 
                    function(scope) {}
            };
        }
    ]);