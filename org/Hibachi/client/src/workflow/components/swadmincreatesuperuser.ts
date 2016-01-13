/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
class SWAdminCreateSuperUser{
	public static Factory(){
		var directive = (
			$log,
			$hibachi,
			workflowPartialsPath,
			pathBuilderConfig
		)=> new SWAdminCreateSuperUser(
			$log,
			$hibachi,
			workflowPartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'$log',
			'$hibachi',
			'workflowPartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}
	constructor(
		$log,
		$hibachi,
		workflowPartialsPath,
			pathBuilderConfig
	){
		return {
			restrict: 'E',
			scope:{
			},
			templateUrl:pathBuilderConfig.buildPartialsPath(workflowPartialsPath)+"admincreatesuperuser.html",
			link: function(scope, element,attrs){
                scope.Account_SetupInitialAdmin = $hibachi.newAccount_SetupInitialAdmin();
			}
		};
	}
}
export{
	SWAdminCreateSuperUser
}
