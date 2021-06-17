/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWLoading{
    
    public template = require("./loading.html");
    
    public restrict = 'A';
    public transclude = true;
    public scope = {
        swLoading:'='
    };

	public static Factory(){
		return /** @ngInject; */ () => new this();
	}

}
export{
    SWLoading
}