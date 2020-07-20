/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowConditionGroupItem{
    public template = require("./workflowconditiongroupitem.html");
    public restrict = 'E';

	public static Factory(){
		return /** @ngInject */ ()=> new this();
	}
}
export{
	SWWorkflowConditionGroupItem
}
