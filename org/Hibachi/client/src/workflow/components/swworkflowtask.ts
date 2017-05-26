/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowTask{
	public static Factory(){
		var directive = (
			workflowPartialsPath,
			hibachiPathBuilder
		)=> new SWWorkflowTask(
			workflowPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'workflowPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		workflowPartialsPath,
			hibachiPathBuilder
	){
		return {
			restrict: 'E',
			scope:{
				workflowTask:"=",
				workflowTasks:"=",

			},
			templateUrl:hibachiPathBuilder.buildPartialsPath(workflowPartialsPath)+"workflowtask.html",
			link: function(scope, element,attrs){

				scope.removeWorkflowTask = function(workflowTask){
					var deletePromise = workflowTask.$$delete();
		    		deletePromise.then(function(){
						if(workflowTask === scope.workflowTasks.selectedTask){
							delete scope.workflowTasks.selectedTask;
						}
						scope.workflowTasks.splice(workflowTask.$$index,1);
						for(var i in scope.workflowTasks){
							scope.workflowTasks[i].$$index = i;
						}
					});
				};
			}
		};
	}
}
export{
	SWWorkflowTask
}