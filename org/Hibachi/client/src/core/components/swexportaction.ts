/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWExportAction{
    
    public template = require("./exportaction.html");
    public restrict = 'A';

	public static Factory(){
		return /** @ngInject; */ () => new this();
	}
}
export{
	SWExportAction
}
