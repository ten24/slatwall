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

	public template = require('./monatenrollmentstep.html');

	public static Factory() {
		return () => new this();
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

