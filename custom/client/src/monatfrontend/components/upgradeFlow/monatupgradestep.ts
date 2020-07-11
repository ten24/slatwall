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

	public template = require('./monatupgradestep.html');

	public static Factory() {
		return () => new this();
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

