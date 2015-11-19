class SWWorkflowTask{
	public static Factory(){
		var directive = (
			$log,
			$location,
			$timeout,
			$slatwall,
			metadataService,
			collectionService,
			workflowPartialsPath
		)=> new SWWorkflowTask(
			$log,
			$location,
			$timeout,
			$slatwall,
			metadataService,
			collectionService,
			workflowPartialsPath
		);
		directive.$inject = [
			'$log',
			'$location',
			'$timeout',
			'$slatwall',
			'metadataService',
			'collectionService',
			'workflowPartialsPath'
		];
		return directive;
	}
	constructor(
		$log,
		$location,
		$timeout,
		$slatwall,
		metadataService,
		collectionService,
		workflowPartialsPath
	){
		return {
			restrict: 'E',
			scope:{
				workflowTask:"=",
				workflowTasks:"=",
				
			},
			templateUrl:workflowPartialsPath+"workflowtask.html",
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