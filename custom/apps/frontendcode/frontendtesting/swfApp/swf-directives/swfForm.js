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
        '$timeout',
        '$rootScope',
        function(ProcessObject, AccountFactory, CartFactory, $compile, $templateCache, $timeout, $rootScope) {
            return {
                restrict: 'E',
                transclude: true,
                controller: 
                	function($scope, $element, $attrs) { 
                		
                		var errorPlacements = ["above", "below", "before", "after"];
                		
                        $scope.hiddenFields = $attrs.hiddenFields  || [];
                        $scope.entityName   = $attrs.entityName    || "Account";
                        $scope.processObject= $attrs.processObject || "login";
                        $scope.action       = $attrs.action;
                        $scope.actions      = $attrs.actions || [];
                        
                        var entityName = $attrs.processObject.split("_")[0];
                        if (entityName == "Order") {entityName = "Cart"};
                        var processObject = $attrs.processObject.split("_")[1];
                        
                        
                        /** check if this form should be hidden until another form submits successfully */
                        this.hideUntilHandler = function(){
                            if ($attrs.hideUntil != undefined){
                                var e = $element;
                                e.hide();
                            }
                        }()
                        
                        /** set a listener for other success events and show hide this depending */
                        $rootScope.$on("onSuccess", function(event, data){
                        	if (data.hide == $scope.processObject){
                        		$element.hide();
                        	}else if(data.show == $scope.processObject){
                        		$element.show();
                        	}
                        });
                        
                        /** make sure we have our data */
                        if (processObject == undefined || entityName == undefined){
                        	throw("ProcessObject Nameing Exception");
                        }
                        
                        /*<-->Retrieves the process object so we can get data.
                        **/
                        var processObj = ProcessObject.get({ entityName: entityName, processObject: processObject },
                        function() {
                        	if (angular.isDefined(processObj.processObject) && processObj.processObject["PROPERTIES"]){
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
                            }
                        });
                        
                        /** We use these for our models */
                        $scope.formData = {};
                        $scope.getFormData = function(){
                        	//console.log("Returning form data");
                        	angular.forEach(this[this.processObject], function(val, key){
                        		/** check for form elements that have a name that doesn't start with $ */
                        	   	if (key.toString().indexOf('$') == -1){
                        	   		//console.log("Key", key);
                        	   		this.formData[key] = val.$viewValue || val.$modelValue || val.$rawModelValue;
                        	   	}
                        	}, $scope);
                        	
                        	return $scope.formData || "";
                        }
                        
                        /**handle parsing through the server errors and injecting the error text for that field
                         * if the form only has a submit, then simply call that function and set errors.
                         */
                        $scope.parseErrors = function(result){
                        	if (angular.isDefined(result.errors) && result.errors.length != 0){
                        		angular.forEach(result.errors, function(val, key){
                        			if (angular.isDefined(this[this.processObject][key])){
                        				var primaryElement = $element.find("[error-for='"+key+"']");
                        				$timeout(function() {
                        					primaryElement.append("<span name='"+key+"Error'>"+result.errors[key]+"</span>");
                                        }, 0);
                                        this[this.processObject][key].$setValidity(key, false);//set field invalid
                        			}
                        		}, $scope);
                        	}
                        };
                        
                        /** find and clear all errors on form */
                        $scope.clearErrors = function(){
                        	var errorElements = $element.find("[error-for]");
                        	errorElements.empty();
                        }
                        
                        /** sets the correct factory to use for submission */
                        this.setFactoryIterator = function(fn){
                        	var factories = [AccountFactory, CartFactory];
                        	var factoryFound = false;
                        	for (factory in factories){
                        		if (!factoryFound){
                                	angular.forEach(factories[factory], function(val, key){
                                		if (!factoryFound){
                                            if (key == fn){
                                            	$scope.factoryIterator = factories[factory];
                                            	factoryFound = true;
                                            }
                                        }
                                    }, $scope);
                                }
                            }
                        }
                        
                        /** iterates through the factory submitting data */
                        this.iterateFactory = function(submitFunction){
                            this.setFactoryIterator(submitFunction);
                            var factoryIterator = $scope.factoryIterator;
                            if (factoryIterator != undefined){
                                factoryIterator[submitFunction]($scope.formData).then(function(result){
                                    if (result.data.failureActions.length != 0){
                                        $scope.parseErrors(result.data);
                                    }else{
                                        if ($attrs.onSuccess != undefined){
                                            $rootScope.$emit("onSuccess", {"hide": $scope.processObject, "show": $attrs.onSuccess});
                                            $rootScope.$emit("refreshAccountAndCart", {});
                                        }
                                    }
                                }, angular.noop);
                            }else{
                                throw("Action does not exist in Account or Cart.");
                            }
                        }
                        
                        /** starts the process of calling single or multiple doActions */
                        this.submit = function(){
                        	//console.log("Submitting form: ");
                        	var action = $scope.action || $scope.actions;
                        	$scope.clearErrors();
                        	$scope.formData = $scope.getFormData() || "";
                        	this.doAction(action);
                        }
                        
                        /** does either a single or multiple actions */
                        this.doAction = function(actionObject){
                            if (angular.isArray(actionObject)){
                            	for(submitFunction in actionObject){
                                	this.iterateFactory(actionObject[submitFunction]);
                                }
                            }else if(angular.isString(actionObject)){
                              	this.iterateFactory(actionObject);
                            }else{
                            	throw("Unknown type of action exception");
                            }
                        }
                        
                        this.resetForm = function(){
                        	/** this stub will reset the form */
                        }
                        
                        /** search dom hiding any forms listed in a onSuccess method on startup */
                        if ($attrs.onSuccess != undefined){
                            $rootScope.$emit("onStart", {"show": $scope.processObject, "hide": $attrs.onSuccess});
                        }
                },
                scope: {
                    entityName: "@?",
                    processObject: "@?",
                    hiddenFields: "=?",
                    action: "&?",
                    actions: "@?",
                    formClass: "@?",
                    formData: "=?",
                    onSuccess: "@?",
                    hideUntil: "@?"
                },
                template: "<ng-form class='{{formClass}}' name='{{processObject}}' ng-transclude no-validate></ng-form>",
                link: 
                    function(scope) {
                    	
                    }
            };
        }
    ]);