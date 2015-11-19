class SWRbKey{
	public static Factory(){
		var directive = (
			$slatwall,
			observerService,
			utilityService,
			$rootScope,
			$log
		)=> new SWRbKey(
			$slatwall,
			observerService,
			utilityService,
			$rootScope,
			$log
		);
		directive.$inject = [
			'$slatwall',
			'observerService',
			'utilityService',
			'$rootScope',
			'$log',
		];
		return directive;
	}
	constructor(
		$slatwall,
		observerService,
		utilityService,
		$rootScope,
		$log
	){
		return {
			restrict: 'A',
			scope:{
				swRbkey:"="
			},
			link: function(scope, element, attrs){
				var rbKeyValue = scope.swRbkey;
				
				var bindRBKey = function(){
					if(angular.isDefined(rbKeyValue) && angular.isString(rbKeyValue)){
						element.text($slatwall.getRBKey(rbKeyValue));
					}
				}
				
				if(!$slatwall.getRBLoaded()){
					observerService.attach(bindRBKey,'hasResourceBundle');
				}else{
					bindRBKey();
				}
			}
		};
	}
}
export{
	SWRbKey
}
