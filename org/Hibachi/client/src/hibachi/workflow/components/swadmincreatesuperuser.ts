class SWAdminCreateSuperUser{
	public static Factory(){
		var directive = (
			$log,
			$slatwall,
			partialsPath
		)=> new SWAdminCreateSuperUser(
			$log,
			$slatwall,
			partialsPath
		);
		directive.$inject = [
			'$log',
			'$slatwall',
			'partialsPath'
		];
		return directive;
	}
	constructor(
		$log,
		$slatwall,
		partialsPath
	){
		return {
			restrict: 'E',
			scope:{
			},
			templateUrl:partialsPath+"admincreatesuperuser.html",
			link: function(scope, element,attrs){
                scope.Account_SetupInitialAdmin = $slatwall.newAccount_SetupInitialAdmin();
			} 
		};
	}
}
export{
	SWAdminCreateSuperUser
}
