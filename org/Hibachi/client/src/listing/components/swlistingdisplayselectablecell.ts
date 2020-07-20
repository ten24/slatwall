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
    
    public template= require('./listingdisplayselectablecell.html');
    
    public static Factory(){
        return /** @ngInject */ () => new this();
    }    

}
export{
    SWListingDisplaySelectableCell
}


