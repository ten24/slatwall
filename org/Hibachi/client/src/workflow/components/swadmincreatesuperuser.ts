/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAdminCreateSuperUser{
	public static Factory(){
		var directive = (
			$hibachi,
			workflowPartialsPath,
			hibachiPathBuilder
		)=> new SWAdminCreateSuperUser(
			$hibachi,
			workflowPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$hibachi',
			'workflowPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
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
