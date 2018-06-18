/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//services
import {WorkflowConditionService} from "./services/workflowconditionservice";
import {ScheduleService} from "./services/scheduleservice";

//directives
import {SWAdminCreateSuperUser} from "./components/swadmincreatesuperuser";
import {SWWorkflowBasic} from "./components/swworkflowbasic";
import {SWWorkflowCondition} from "./components/swworkflowcondition";
import {SWWorkflowConditionGroupItem} from "./components/swworkflowconditiongroupitem";
import {SWWorkflowConditionGroups} from "./components/swworkflowconditiongroups";
import {SWWorkflowTask} from "./components/swworkflowtask";
import {SWWorkflowTaskActions} from "./components/swworkflowtaskactions";
import {SWWorkflowTasks} from "./components/swworkflowtasks";
import {SWWorkflowTrigger} from "./components/swworkflowtrigger";
import {SWWorkflowTriggers} from "./components/swworkflowtriggers";
import {SWWorkflowTriggerHistory} from "./components/swworkflowtriggerhistory";
import {SWSchedulePreview} from "./components/swschedulepreview";

//filters

//modules
import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {UpgradeModule, downgradeInjectable} from '@angular/upgrade/static';


@NgModule({
	declarations : [],
	providers : [
		ScheduleService,
		WorkflowConditionService

	],
	imports : [
		CommonModule,
		UpgradeModule
	]
})

export class WorkflowModule{
	constructor(){

	}
}


var workflowmodule = angular.module('hibachi.workflow',['hibachi.collection']).config(()=>{
})
//constants
.constant('workflowPartialsPath','workflow/components/')
//services
.service('workflowConditionService',downgradeInjectable(WorkflowConditionService))
.service('scheduleService',downgradeInjectable(ScheduleService))
//directives
.directive('swAdminCreateSuperUser',SWAdminCreateSuperUser.Factory())
.directive('swWorkflowBasic',SWWorkflowBasic.Factory())
.directive('swWorkflowCondition',SWWorkflowCondition.Factory())
.directive('swWorkflowConditionGroupItem',SWWorkflowConditionGroupItem.Factory())
.directive('swWorkflowConditionGroups',SWWorkflowConditionGroups.Factory())
.directive('swWorkflowTask',SWWorkflowTask.Factory())
.directive('swWorkflowTaskActions',SWWorkflowTaskActions.Factory())
.directive('swWorkflowTasks',SWWorkflowTasks.Factory())
.directive('swWorkflowTrigger',SWWorkflowTrigger.Factory())
.directive('swWorkflowTriggers',SWWorkflowTriggers.Factory())
.directive('swWorkflowTriggerHistory',SWWorkflowTriggerHistory.Factory())
.directive('swSchedulePreview',SWSchedulePreview.Factory())
//filters

;
export{
	workflowmodule
}