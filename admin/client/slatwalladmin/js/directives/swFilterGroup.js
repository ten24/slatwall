angular.module('slatwalladmin')
.directive('swFilterGroups', function(){
	return {
		/*
		//restrict 'AEC' attribute element class
		restrict: String,
		//priority is what order the directive gets renders in
		priority: Number,
		//terminal if true sets priority to lowest
		terminal: Boolean,
		//
		template: String or Template Function:
		function(tElement, tAttrs) (...}, templateUrl: String,
		replace: Boolean or String,
		//scope if true creates a scope for the directive, if set to {} then isolate scope item in struct {} use @ for one way bind, = for two way binding, & for
		scope: Boolean or Object, transclude: Boolean,
		controller: String or
		function(scope, element, attrs, transclude, otherInjectables) { ... },
		controllerAs: String,
		require: String,
		link: function(scope, iElement, iAttrs) { ... }, compile: // return an Object OR the link function
		              // as in below:
		function(tElement, tAttrs, transclude) { return {
			pre: function(scope, iElement, iAttrs, controller) { ... },
			post: function(scope, iElement, iAttrs, controller) { ... } }
			// or
			return function postLink(...) { ... } }
		};*/
		
		restrict: 'A',
		templateUrl:'/admin/client/slatwalladmin/js/directives/partials/filterItem.html',
		require:'?ngModel',
		link: function(scope, element, attrs, ngModelController){
			console.log(ngModelController);
		}
	}
});
	
