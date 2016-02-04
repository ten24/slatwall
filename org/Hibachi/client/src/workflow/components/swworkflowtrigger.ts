
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowTrigger{
	public static Factory(){
		var directive = (
			$log,
			$hibachi,
			metadataService,
			workflowPartialsPath,
			hibachiPathBuilder,
            collectionConfigService,
            $http
		)=> new SWWorkflowTrigger(
			$log,
			$hibachi,
			metadataService,
			workflowPartialsPath,
			hibachiPathBuilder,
            collectionConfigService,
            $http
		);
		directive.$inject = [
			'$log',
			'$hibachi',
			'metadataService',
			'workflowPartialsPath',
			'hibachiPathBuilder',
            'collectionConfigService',
            '$http'
		];
		return directive;
	}
	constructor(
		$log,
		$hibachi,
		metadataService,
		workflowPartialsPath,
        hibachiPathBuilder,
        collectionConfigService,
        $http
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
				console.warn('workflow trigger init');

				/**
				 * Selects the current workflow trigger.
				 */
				scope.selectWorkflowTrigger = function(workflowTrigger){
					console.warn('SelectWorkflowTriggers');
					scope.done = false;
					console.warn(workflowTrigger);
					scope.finished = false;
					scope.workflowTriggers.selectedTrigger = undefined;

                    var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName(scope.workflowTrigger.data.workflow.data.workflowObject);
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





                var executingTrigger = false;
                scope.executeWorkflowTrigger = function(workflowTrigger){
                    if(executingTrigger) return;
                    executingTrigger = true;

                    var appConfig = $hibachi.getConfig();
                    var urlString = appConfig.baseURL+'/index.cfm/?'+appConfig.action+'=admin:workflow.executeScheduleWorkflowTrigger&workflowTriggerID='+workflowTrigger.data.workflowTriggerID;
                    $http.get(urlString).finally(function(){
                        executingTrigger = false;
                    })
                };

				/**
				 * Overrides the delete function for the confirmation modal. Delegates to the normal delete method.
				 */
				scope.deleteEntity = function(entity){
					console.warn("Delete Called");
					console.warn(entity);
					scope.deleteTrigger(entity);
				};

				/**
				 * Hard deletes a workflow trigger
				 */
				scope.deleteTrigger = function(workflowTrigger){
					var deleteTriggerPromise = $hibachi.saveEntity('WorkflowTrigger',workflowTrigger.data.workflowTriggerID,{},'Delete');
					deleteTriggerPromise.then(function(value){
						console.warn('deleteTrigger');
						scope.workflowTriggers.splice(workflowTrigger.$$index,1);
					});
				};

				/**
				 * Sets the editing state to show/hide the edit screen.
				 */
				scope.setHidden = function(trigger){
					if(!angular.isObject(trigger) || angular.isUndefined(trigger.hidden)){
						trigger.hidden=false;
					}else{
						console.warn("setHidden()", "Setting Hide Value To " + !trigger.hidden);
						trigger.hidden = !trigger.hidden;
					}
				};


			}
		};
	}
}
export{
	SWWorkflowTrigger
}