/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAdminCreateSuperUser{
	public static Factory(){
		var directive = (
			$log,
			$hibachi,
			workflowPartialsPath,
			hibachiPathBuilder
		)=> new SWAdminCreateSuperUser(
			$log,
			$hibachi,
			workflowPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$log',
			'$hibachi',
			'workflowPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		$log,
		$hibachi,
		workflowPartialsPath,
			hibachiPathBuilder
	){
		return {
			restrict: 'E',
			scope:{
			},
			templateUrl:hibachiPathBuilder.buildPartialsPath(workflowPartialsPath)+"admincreatesuperuser.html",
			link: function(scope, element,attrs){
                scope.Account_SetupInitialAdmin = $hibachi.newAccount_SetupInitialAdmin();
			}
		};
	}
}
export{
	SWAdminCreateSuperUser
}
