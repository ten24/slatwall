class MonatUpgradeStep {

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
	public require = '^monatUpgrade';

	public static Factory(){
		var directive:any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}
    
    // Cant't use require here as the template includes < ng-transclusde > 
    // which gets included inside another ng-transclude
	constructor( private monatFrontendBasePath ){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/upgradeFlow/monatupgradestep.html";
	}
	
	public link = (scope, element, attrs, monatUpgrade) =>{
		
		if(angular.isUndefined(scope.onNext)){
			scope.onNext = () => true;
		}
		monatUpgrade.addStep(scope);
		scope.$on('$destroy', function(){
			monatUpgrade.removeStep(scope);
		});
	}
}

export {
	MonatUpgradeStep
};