
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowTrigger{
	public static Factory(){
		var directive = (
			$log,
			$hibachi,
			metadataService,
			workflowPartialsPath,
			hibachiPathBuilder
		)=> new SWWorkflowTrigger(
			$log,
			$hibachi,
			metadataService,
			workflowPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$log',
			'$hibachi',
			'metadataService',
			'workflowPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		$log,
		$hibachi,
		metadataService,
		workflowPartialsPath,
			hibachiPathBuilder
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
				$log.debug('workflow trigger init');

				/**
				 * Selects the current workflow trigger.
				 */
				scope.selectWorkflowTrigger = function(workflowTrigger){
					$log.debug('SelectWorkflowTriggers');
					scope.done = false;
					$log.debug(workflowTrigger);
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

				/**
				 * Overrides the delete function for the confirmation modal. Delegates to the normal delete method.
				 */
				scope.deleteEntity = function(entity){
					$log.debug("Delete Called");
					$log.debug(entity);
					scope.deleteTrigger(entity);
				};

				/**
				 * Hard deletes a workflow trigger
				 */
				scope.deleteTrigger = function(workflowTrigger){
					var deleteTriggerPromise = $hibachi.saveEntity('WorkflowTrigger',workflowTrigger.data.workflowTriggerID,{},'Delete');
					deleteTriggerPromise.then(function(value){
						$log.debug('deleteTrigger');
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
						$log.debug("setHidden()", "Setting Hide Value To " + !trigger.hidden);
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