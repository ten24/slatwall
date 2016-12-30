/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
 
var md5 = require('md5');
class SWGravatarController {

    public gravatarURL;
    public emailAddress;

    // @ngInject
	constructor(){
        this.gravatarURL = "http://www.gravatar.com/avatar/" + md5(this.emailAddress.toLowerCase().trim());
	}
}

class SWGravatar implements ng.IDirective{

	public static $inject=["$hibachi", "$timeout", "collectionConfigService", "corePartialsPath",
			'hibachiPathBuilder'];
	public template = `<img src='{{swGravatar.gravatarURL}}' />`;
    public transclude=false;
	public restrict = "E";
	public scope = {}

	public bindToController = {
        emailAddress:"@"
	}
	public controller=SWGravatarController;
	public controllerAs="swGravatar";

	constructor(){
	}

	public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any, controller:any, transclude:any) =>{
	}



	public static Factory(){
		var directive:ng.IDirectiveFactory = () => new SWGravatar();
		directive.$inject = [];
		return directive;
	}
}
export{
	SWGravatar,
	SWGravatarController
}
