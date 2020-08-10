/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSchedulePreviewController {
    constructor(){}
}

class SWSchedulePreview implements ng.IDirective{

    public template = require("./schedulepreview.html");
	
    public restrict = 'AE';
    public scope = {};

    public bindToController = {
        schedule: "="
    };
    public controller=SWSchedulePreviewController;
    public controllerAs="swSchedulePreview";
    
	public static Factory(){
		return /** @ngInject */ ()=> new this();
	}
}
export{
    SWSchedulePreview
}