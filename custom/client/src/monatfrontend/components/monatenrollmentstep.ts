class MonatEnrollmentStep {

	public restrict:string = 'EA';
	public templateUrl:string;
	public replace:boolean = true;
	public transclude:boolean = true;
	public scope ={
		stepClass : '@',
		showMiniCart : '@',
		onNext : '=?',
		showFlexshipCart : '@?',
	}
	public require = '^monatEnrollment';

	public static Factory(){
		var directive:any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}
    // Cant't use require here as the template includes < ng-transclusde > 
    // which gets included inside another ng-transclude
	constructor( private monatFrontendBasePath ){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatenrollmentstep.html";
	}
	
	public link = (scope, element, attrs, monatEnrollment) =>{
		
		if(angular.isUndefined(scope.onNext)){
			scope.onNext = () => true;
		}
		monatEnrollment.addStep(scope);
		scope.$on('$destroy', function(){
			monatEnrollment.removeStep(scope);
		});
	}
}

export {
	MonatEnrollmentStep
};

