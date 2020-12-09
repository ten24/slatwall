/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWRbKey{
	public static Factory(){
		var directive = (
			$hibachi,
			observerService,
			utilityService,
			$rootScope,
			$log,
            rbkeyService
		)=> new SWRbKey(
			$hibachi,
			observerService,
			utilityService,
			$rootScope,
			$log,
            rbkeyService
		);
		directive.$inject = [
			'$hibachi',
			'observerService',
			'utilityService',
			'$rootScope',
			'$log',
            'rbkeyService'
		];
		return directive;
	}
	constructor(
		$hibachi,
		observerService,
		utilityService,
		$rootScope,
		$log,
        rbkeyService
	){
		return {
			restrict: 'A',
			scope:{
				swRbkey:"="
			},
			link: function(scope, element, attrs){
				var rbKeyValue = scope.swRbkey;

				var bindRBKey = ()=>{
					if(angular.isDefined(rbKeyValue) && angular.isString(rbKeyValue)){
						element.text(rbkeyService.getRBKey(rbKeyValue));
					}
				}


				bindRBKey();

			}
		};
	}
}
export{
	SWRbKey
}
