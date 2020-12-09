/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowTriggerHistory{
    public static Factory(){
        var directive=(
            workflowPartialsPath,
            hibachiPathBuilder,
            $rootScope,
            collectionConfigService
        )=>new SWWorkflowTriggerHistory(
            workflowPartialsPath,
            hibachiPathBuilder,
            $rootScope,
            collectionConfigService
        );
        directive.$inject = [
            'workflowPartialsPath',
            'hibachiPathBuilder',
            '$rootScope',
            'collectionConfigService'
        ];
        return directive;
    }
    constructor(
            workflowPartialsPath,
            hibachiPathBuilder,
            $rootScope,
            collectionConfigService){

        return {
            restrict : 'A',
            scope : {
                workflow : "="
            },
            templateUrl : hibachiPathBuilder.buildPartialsPath(workflowPartialsPath) + "workflowtriggerhistory.html",
            link : function(scope, element, attrs) {
                $rootScope.workflowID = scope.workflow.data.workflowID;
                //Build the history collection.
                scope.workflowTriggerHistoryCollection = collectionConfigService.newCollectionConfig("WorkflowTriggerHistory");
                scope.workflowTriggerHistoryCollection.addFilter("workflowTrigger.workflow.workflowID", $rootScope.workflowID ,"=")
                scope.workflowTriggerHistoryCollection.addDisplayProperty("workflowTrigger.triggerType");
                scope.workflowTriggerHistoryCollection.addDisplayProperty("response");
                scope.workflowTriggerHistoryCollection.addDisplayProperty("endTime");
                scope.workflowTriggerHistoryCollection.addDisplayProperty("startTime");
                scope.workflowTriggerHistoryCollection.addDisplayProperty("successFlag");
            }
        };
    }
}
export{
    SWWorkflowTriggerHistory
}
