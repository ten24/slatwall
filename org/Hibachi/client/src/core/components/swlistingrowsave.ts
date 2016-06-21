/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingRowSaveController{

    //@ngInject
    constructor(
        public $injector
    ){

    }


}

class SWListingRowSave implements ng.IDirective{
    public templateUrl;
    public restrict:string = 'EA';
    public scope=true;
    public bindToController={

    };
    public controller=SWListingRowSaveController;
    public controllerAs="swListingRowSave";
    public static $inject = ['utilityService'];

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            hibachiPathBuilder,
            corePartialsPath,
            utilityService
        )=>new SWListingRowSave(
            hibachiPathBuilder,
            corePartialsPath,
            utilityService
        );
        directive.$inject = [
            'hibachiPathBuilder',
            'corePartialsPath',
            'utilityService'
        ];
        return directive;
    }
    constructor(private hibachiPathBuilder, 
                private corePartialsPath, 
                private utilityService
    ){
       this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.corePartialsPath)+'listingrowsave.html';
    }

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{

    }
}
export{
    SWListingRowSave
}