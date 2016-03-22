/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowTriggerHistory{
    public static Factory(){
        var directive=(
            $log, $location, $hibachi, formService, workflowPartialsPath,
            hibachiPathBuilder, $rootScope
        )=>new SWWorkflowTriggerHistory(
            $log, $location, $hibachi, formService, workflowPartialsPath,
            hibachiPathBuilder, $rootScope
        );
        directive.$inject = [
            '$log',
            '$location',
            '$hibachi',
            'formService',
            'workflowPartialsPath',
            'hibachiPathBuilder',
            '$rootScope'
        ];
        return directive;
    }
    constructor($log, $location, $hibachi, formService, workflowPartialsPath,
                hibachiPathBuilder, $rootScope){

        return {
            restrict : 'A',
            scope : {
                workflow : "="
            },
            templateUrl : hibachiPathBuilder.buildPartialsPath(workflowPartialsPath) + "workflowtriggerhistory.html",
            link : function(scope, element, attrs) {
                $rootScope.workflowID = scope.workflow.data.workflowID;
            }
        };
    }
}
export{
    SWWorkflowTriggerHistory
}
