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
			restrict: 'AE',
			replace:true,
			scope:{
				variables:"=", //{key:value}
				directive:"="
			},
			link: function(scope, element, attrs) {

		        var template = '<' + scope.directive + ' ';

		        if(angular.isDefined(scope.variables)){
			        angular.forEach(scope.variables, function(value,key){
			        	template += ' ' + key + '=' + value + ' ';
			        });
			    }

		        template += '>';
		        template += '</'+scope.directive+'>';

		        // Render the template.
				console.log('renderDirective',template);
		        element.html($compile(template)(scope));
		    }
		};
	}
}
export{
	SWDirective
}