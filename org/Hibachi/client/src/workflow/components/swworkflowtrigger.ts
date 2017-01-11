
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowTrigger{
	public static Factory(){
		var directive = (
            $http,
			$hibachi,
            alertService,
			metadataService,
			workflowPartialsPath,
			hibachiPathBuilder,
            utilityService
		)=> new SWWorkflowTrigger(
            $http,
			$hibachi,
            alertService,
			metadataService,
			workflowPartialsPath,
			hibachiPathBuilder,
            utilityService
		);
		directive.$inject = [
			'$http',
			'$hibachi',
            'alertService',
			'metadataService',
			'workflowPartialsPath',
			'hibachiPathBuilder',
            'utilityService'
		];
		return directive;
	}
	constructor(
		$http,
		$hibachi,
        alertService,
		metadataService,
		workflowPartialsPath,
        hibachiPathBuilder,
        utilityService
        
	){
		return {
			restrict: 'A',
			replace: true,
			scope:{
				workflowTrigger:"=",
				workflowTriggers:"="
			},
			templateUrl:hibachiPathBuilder.buildPartialsPath(workflowPartialsPath)+"workflowtrigger.html",
			link: function(scope, element,attrs){

				/**
				 * Selects the current workflow trigger.
				 */
				scope.selectWorkflowTrigger = function(workflowTrigger){
					scope.done = false;
					scope.finished = false;
					scope.workflowTriggers.selectedTrigger = undefined;

                    var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName(scope.workflowTrigger.data.workflow.data.workflowObject, true);
					filterPropertiesPromise.then(function(value){
						scope.filterPropertiesList = {
							baseEntityName:		scope.workflowTrigger.data.workflow.data.workflowObject,
							baseEntityAlias:"_"+ scope.workflowTrigger.data.workflow.data.workflowObject
						};


						metadataService.setPropertiesList(value, scope.workflowTrigger.data.workflow.data.workflowObject);
						scope.filterPropertiesList[scope.workflowTrigger.data.workflow.data.workflowObject] = metadataService.getPropertiesListByBaseEntityAlias(scope.workflowTrigger.data.workflow.data.workflowObject);
						metadataService.formatPropertiesList(scope.filterPropertiesList[scope.workflowTrigger.data.workflow.data.workflowObject], scope.workflowTrigger.data.workflow.data.workflowObject);
						scope.workflowTriggers.selectedTrigger = workflowTrigger;

                    });
				};

                scope.executingTrigger = false;
                scope.executeWorkflowTrigger = function(workflowTrigger){
                    if(scope.executingTrigger) return;

                    if(!workflowTrigger.data.workflow.data.workflowTasks || !workflowTrigger.data.workflow.data.workflowTasks.length) {
                        var alert = alertService.newAlert();
                        alert.msg =  "You don't have any Task yet!";
                        alert.type = "error";
                        alert.fade = true;
                        alertService.addAlert(alert);
                        return;
                    }
                    scope.executingTrigger = true;

                    var appConfig = $hibachi.getConfig();
                    var urlString = appConfig.baseURL+'/index.cfm/?'+appConfig.action+'=api:workflow.executeScheduleWorkflowTrigger&workflowTriggerID='+workflowTrigger.data.workflowTriggerID+'&x='+utilityService.createID();
                    $http.get(urlString).finally(()=>{
                        scope.executingTrigger = false;
                        var alert = alertService.newAlert();
                        alert.msg =  "Task Triggered Successfully. Check History for Status";
                        alert.type = "success";
                        alert.fade = true;
                        alertService.addAlert(alert);
                    })
                };

				/**
				 * Overrides the delete function for the confirmation modal. Delegates to the normal delete method.
				 */
				scope.deleteEntity = function(entity, index){
					scope.deleteTrigger(entity, index);
				};

				/**
				 * Hard deletes a workflow trigger
				 */
				scope.deleteTrigger = function(workflowTrigger, index){
					var deleteTriggerPromise = $hibachi.saveEntity('WorkflowTrigger',workflowTrigger.data.workflowTriggerID,{},'Delete');
					deleteTriggerPromise.then(function(value){
						scope.workflowTriggers.splice(index,1);
					});
				};

			}
		};
	}
}
export{
	SWWorkflowTrigger
}