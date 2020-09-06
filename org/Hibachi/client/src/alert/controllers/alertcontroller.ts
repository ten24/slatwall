/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
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
