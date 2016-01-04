/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
class SWAdminCreateSuperUser{
	public static Factory(){
		var directive = (
			$log,
			$slatwall,
			workflowPartialsPath,
			pathBuilderConfig
		)=> new SWAdminCreateSuperUser(
			$log,
			$slatwall,
			workflowPartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'$log',
			'$slatwall',
			'workflowPartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}
	constructor(
		$log,
		$slatwall,
		workflowPartialsPath,
			pathBuilderConfig
	){
		return {
			restrict: 'E',
			scope:{
			},
			templateUrl:pathBuilderConfig.buildPartialsPath(workflowPartialsPath)+"admincreatesuperuser.html",
			link: function(scope, element,attrs){
                scope.Account_SetupInitialAdmin = $slatwall.newAccount_SetupInitialAdmin();
			}
		};
	}
}
export{
	SWAdminCreateSuperUser
}
