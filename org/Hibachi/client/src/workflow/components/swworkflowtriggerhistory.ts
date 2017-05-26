/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowTriggerHistory{
    public static Factory(){
        var directive=(
            workflowPartialsPath,
            hibachiPathBuilder,
            $rootScope
        )=>new SWWorkflowTriggerHistory(
            workflowPartialsPath,
            hibachiPathBuilder,
            $rootScope
        );
        directive.$inject = [
            'workflowPartialsPath',
            'hibachiPathBuilder',
            '$rootScope'
        ];
        return directive;
    }
    constructor(
            workflowPartialsPath,
            hibachiPathBuilder,
            $rootScope){

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
