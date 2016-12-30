/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDirective{
	public static Factory(){
		var directive = (
			$compile
		)=>new SWDirective(
			$compile
		);
		directive.$inject = [
			'$compile'
		];
		return directive;
	}
    //@ngInject
	constructor(
		$compile
	){
		return {
			restrict: 'A',
			replace:true,
			scope:{
				variables:"=", //{key:value}
				directive:"="
			},
			link: function(scope, element, attrs) {

		        var template = '<span ' + scope.directive + ' ';
		        if(angular.isDefined(scope.variables)){
			        angular.forEach(scope.variables, function(value,key){
			        	template += ' ' + key + '=' + value + ' ';
			        });
			    }

		        template += + '>';
		        template += '</span>';

		        // Render the template.
		        element.html('').append($compile(template)(scope));
		    }
		};
	}
}
export{
	SWDirective
}