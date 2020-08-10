/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowBasic{
    
    public template = require("./workflowbasic.html");
    public restrict = 'A';
	public scope = {
	    workflow : "="
	};
	
	public static Factory(){
		return /** @ngInject */ ()=> new this();
	}
}
export{
	SWWorkflowBasic
}
