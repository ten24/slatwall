/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
//services
import {WorkflowConditionService} from "./services/workflowconditionservice";

//filters


var workflowmodule = angular.module('hibachi.workflow',[]).config(()=>{
})
//services
.service('workflowConditionService',WorkflowConditionService)

//filters 

;  
export{
	workflowmodule
}