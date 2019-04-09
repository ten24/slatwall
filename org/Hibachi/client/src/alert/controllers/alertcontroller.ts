class AlertController{
	//@ngInject
	constructor(
		$scope,
		alertService
	){
		$scope.$id="alertController";
		$scope.alerts = alertService.getAlerts();
	}
}
export{AlertController}
