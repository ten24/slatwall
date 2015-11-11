/// <reference path='../../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {

    export class swFormControllerr {
		processObject = "";
		formData = {};
        constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private partialsPath:slatwalladmin.partialsPath, private $slatwall:ngSlatwall.SlatwallService, private dialogService:slatwalladmin.IDialogService){
            
			/** parse the name */
			let entityName = this.processObject.split("_")[0];
			if (entityName == "Order") { entityName = "Cart" };
			let processObject = this.processObject.split("_")[1];
			
			/** make sure we have our data */
			if (processObject == undefined || entityName == undefined) {
				throw ("ProcessObject Nameing Exception");
			}
			
			/** refactor to use $slatwall */
			
			//slatwall.newEntity(processObject)
			var processObj = this.$slatwall.newEntity(processObject);
			
			/** parse the response */
			processObj = processObj.$get({ processObject: processObject, entityName: entityName }).success(
				/** parse */
				function(response) {
					this.parseProcessObjectResponse(response);
				}
			).error(function() {
				throw ("Endpoint does not exist exception");
			});
			
			/** handles the process object structure - needs $slatwall and this goes away */
			this.parseProcessObjectResponse = (response) => {
				processObj = response;
				if (angular.isDefined(processObj.processObject) && processObj.processObject["PROPERTIES"]) {
					processObj.processObject["meta"] = [];
					for (var p of processObj.processObject["PROPERTIES"]) {

						angular.forEach(processObj.processObject["entityMeta"], (n) => {
							if (n["NAME"] == p["NAME"]) {
								processObj.processObject["meta"].push(n);
							}
						});
					}

					var processObjName = processObj.processObject["NAME"].split(".");
					processObjName = processObjName[processObjName.length - 1];

					processObj.processObject["NAME"] = processObjName;
					return processObj.processObject;
				}
			}
			
			/** We use these for our models */
			this.formData = {};
			this.getFormData = function() {
				angular.forEach(this["formCtrl"][this.processObject], (val, key) => {
					/** Check for form elements that have a name that doesn't start with $ */
					if (key.toString().indexOf('$') == -1) {
						this.formData[key] = val.$viewValue || val.$modelValue || val.$rawModelValue;
					}
				});

				return this.formData || "";
			}
			
			/** Handle parsing through the server errors and injecting the error text for that field
				*  If the form only has a submit, then simply call that function and set errors.
				*/
			this.parseErrors = function(result, $element) {
				if (angular.isDefined(result.errors) && result.errors.length != 0) {
					angular.forEach(result.errors, (val, key) => {
						if (angular.isDefined(this["formCtrl"][this.processObject][key])) {
							let primaryElement = $element.find("[error-for='" + key + "']");
							this.$timeout(function() {
							primaryElement.append("<span name='" + key + "Error'>" + result.errors[key] + "</span>");
							}, 0);
							this["formCtrl"][this.processObject][key].$setValidity(key, false);//set field invalid
						}
					}, this);
				}
			};
			
			/** find and clear all errors on form */
			this.clearErrors = function($element) {
				let errorElements = $element.find("[error-for]");
				errorElements.empty();
			}
			
			/** sets the correct factory to use for submission: $slatwall replaces this - using custom wrapper */
			this.setFactoryIterator = (fn) => {

				let account = this.AccountFactory.GetInstance();
				let cart = this.CartFactory.GetInstance();
				let factories = [account, cart];
				let factoryFound = false;
				for (var factory of factories) {
					if (!factoryFound) {
						angular.forEach(factory, (val, key) => {
							if (!factoryFound) {
								if (key == fn) {
									this.factoryIterator = factory;
									factoryFound = true;
								}
							}
						})
					}
				}
			}
			this.formType = { 'Content-Type': 'application/x-www-form-urlencoded' };
			this.toFormParams = function(data) {
				return data = $.param(data) || "";
			}
			/** iterates through the factory submitting data */
			this.iterateFactory = (submitFunction) => {
				this.setFactoryIterator(submitFunction);
				var factoryIterator = this.factoryIterator;

				if (factoryIterator != undefined) {
					var submitFn = factoryIterator[submitFunction];
					submitFn({ params: this.toFormParams(this.formData), formType: this.formType }, this.$http).then(function(result) {
						if (result.data.failureActions.length != 0) {
							this.parseErrors(result.data);
						} else {
							console.log("Successfully Posted Form");
						}
					}, angular.noop);
				} else {
					throw ("Action does not exist in Account or Cart: " + this.action);
				}
			}
			
			/** does either a single or multiple actions */
			this.doAction = (actionObject) => {
				if (angular.isArray(actionObject)) {
					for (var submitFunction of actionObject) {
						this.iterateFactory(submitFunction);
					}
				} else if (angular.isString(actionObject)) {
					this.iterateFactory(actionObject);
				} else {
					throw ("Unknown type of action exception");
				}
			}
			
			/** create the generic submit function */
			this.submit = function() {
				let action = this.action || this.actions;
				this.clearErrors();
				this.formData = this.getFormData() || "";
				this.doAction(action);
			}
        }
    }
    export class swFormR implements ng.IDirective {
        public restrict = "E";
        public transclude = true;
		public controller = "swFormControllerr"
        public controllerAs = "ctrl";
		public templateUrl = "";
        public bindToController = {
                object:"=?",
                context:"@?",
                name:"@?",
                entityName: "@?",
                processObject: "@?",
                hiddenFields: "=?",
                action: "&?",
                actions: "@?",
                formClass: "@?",
                formData: "=?",
                onSuccess: "@?",
                hideUntil: "@?",
                isProcessForm: "@"
		      };
        public replace = true;
		
		public static $inject = ['formService', 'ProcessObject', '$slatwall', 'AccountFactory', 'CartFactory',
            '$compile', '$templateCache', '$timeout', '$rootScope', 'partialsPath', '$http'];
        constructor(public formService, public ProcessObject, public $slatwall, public AccountFactory, public CartFactory, public $compile, public $templateCache, public $timeout, public $rootScope, public partialsPath, public $http) {
            this.templateUrl = this.partialsPath + "formPartial.html";
			return this;
        }
    }
    angular.module('slatwalladmin').directive('swFormR', ['formService', 'ProcessObject', '$slatwall', 'AccountFactory', 'CartFactory',
        '$compile', '$templateCache', '$timeout', '$rootScope', 'partialsPath', '$http', (formService, ProcessObject, $slatwall, AccountFactory, CartFactory, $compile, $templateCache, $timeout, $rootScope, partialsPath, $http) => new swFormR(formService, ProcessObject, $slatwall, AccountFactory, CartFactory, $compile, $templateCache, $timeout, $rootScope, partialsPath, $http)]);
}

	
