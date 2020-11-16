/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDirective {
    
    public restrict = 'AE';
	//replace:true,
	public scope = {
		variables:"=", //{key:value}
		directiveTemplate:"="
	};
	public controllerAs = "swDirective";

	public static Factory(){
		return /** @ngInject */ ( $compile, utilityService ) => new SWDirective( $compile, utilityService );
	}
	
    //@ngInject
	constructor(
		private $compile,
		private utilityService
	){}
	
	public link : ng.IDirectiveLinkFn = (scope, element, attrs) => {
		var tempVariables = {}; 
		angular.forEach(scope.variables, (value,key)=>{
       	 if(key.toString().charAt(0) != "$" && value !== " "){
        	    tempVariables[this.utilityService.keyToAttributeString(key)] = value;
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
        element.html(this.$compile(template)(scope));
    }
}
export{
	SWDirective
}