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
            listingPartialPath,
            hibachiPathBuilder
        ) => new SWListingDisplaySelectableCell(
            listingPartialPath,
            hibachiPathBuilder
        );
        directive.$inject =[
            'listingPartialPath',
            'hibachiPathBuilder'
        ];
        return directive;
    }
    //@ngInject
    constructor(
        public listingPartialPath,
        public hibachiPathBuilder
    ){
        this.listingPartialPath = listingPartialPath;
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.listingPartialPath)+'listingdisplayselectablecell.html';
    }

}
export{
    SWListingDisplaySelectableCell
}


