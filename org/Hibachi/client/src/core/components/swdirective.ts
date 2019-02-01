/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDirective{
	public static Factory(){
		var directive = (
			$compile,
			utilityService
		)=>new SWDirective(
			$compile,
			utilityService
		);
		directive.$inject = [
			'$compile',
			'utilityService'
		];
		return directive;
	}
    //@ngInject
	constructor(
		$compile,
		utilityService
	){
		return {
			restrict: 'AE',
			//replace:true,
			scope:{
				variables:"=", //{key:value}
				directiveTemplate:"="
			},
			controllerAs: "swDirective",
			link: function(scope, element, attrs) {
				var tempVariables = {}; 
				angular.forEach(scope.variables, (value,key)=>{
               	 if(key.toString().charAt(0) != "$" && value !== " "){
                	    tempVariables[utilityService.keyToAttributeString(key)] = value;
                	}
            	});
				scope.variables = tempVariables;
		        var template = '<' + scope.directiveTemplate + ' ';
		        if(angular.isDefined(scope.variables)){
			        angular.forEach(scope.variables, (value,key)=>{
						if(!angular.isString(value) && !angular.isNumber(value)){
							template += ' ' + key + '="swDirective.' + 'variables.' + key + '" ';
						} else { 
			        		template += ' ' + key + '="' + value + '" ';
						}
			        });
			    }

		        template += '>';
		        template += '</'+scope.directiveTemplate+'>';

		        // Render the template.
		        element.html($compile(template)(scope));
		    }
		};
	}
}
export{
	SWDirective
}