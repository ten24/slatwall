/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingDisplaySelectableCellController{
    /* local state variables */
    //@ngInject
    constructor(
    ){
        
    }
}

class SWListingDisplaySelectableCell implements ng.IDirective{

    public restrict:string = 'E';
    public scope = {};
    public transclude=true;
    public bindToController={

    };
    public controller=SWListingDisplaySelectableCellController;
    public controllerAs="swListingDisplaySelectableCell";
    public templateUrl;
    
    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            corePartialsPath,
            hibachiPathBuilder
        ) => new SWListingDisplaySelectableCell(
            corePartialsPath,
            hibachiPathBuilder
        );
        directive.$inject =[
            'corePartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    }
    //@ngInject
    constructor(
        public corePartialsPath,
        public hibachiPathBuilder
    ){
        this.corePartialsPath = corePartialsPath;
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.corePartialsPath)+'listingdisplayselectablecell.html';
    }

}
export{
    SWListingDisplaySelectableCell
}


