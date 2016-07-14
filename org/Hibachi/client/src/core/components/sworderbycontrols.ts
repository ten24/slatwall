/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWOrderByControlsController {

    public collectionConfig:any; 
    public selectedOrderByColumnIndex:any; 
    public sortCode:string = "ASC";
    public columns:any[]; 

    // @ngInject
    constructor(
        ){
            this.columns = this.collectionConfig.columns; 
    }

    public changeSortProperty = ():void =>{
        switch(this.sortCode){
            case "ASC":
                this.collectionConfig.toggleOrderBy(this.columns[this.selectedOrderByColumnIndex].propertyIdentifier,true);//single column mode true
                break; 
            case "DESC":
                this.collectionConfig.toggleOrderBy(this.columns[this.selectedOrderByColumnIndex].propertyIdentifier,true);//single column mode true
                break; 
            case "MANUAL":
                //flip listing
                break; 
        }
    }

    public sortAscending = ():void =>{
        this.sortCode = 'ASC'; 
    }

    public sortDescending = ():void =>{
        this.sortCode = 'DESC'; 
    }

    public manualSort = ():void =>{
        this.sortCode = 'MANUAL'
    }

}

class SWOrderByControls implements ng.IDirective{

    public templateUrl;
    public transclude=true; 
    public restrict = "EA";
    public scope = {};

    public bindToController = {
        collectionConfig:"=?",
        selectedOrderByColumn:"=?"
    };
    public controller=SWOrderByControlsController;
    public controllerAs="swOrderByControls";

    // @ngInject
    constructor(public $compile, private scopeService, private corePartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "orderbycontrols.html";
    }

    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {

            }
        };
    }

    public static Factory(){
        var directive:ng.IDirectiveFactory = (
            $compile
            ,scopeService 
            ,corePartialsPath
            ,hibachiPathBuilder

        )=> new SWOrderByControls(
            $compile
            ,scopeService
            ,corePartialsPath
            ,hibachiPathBuilder
        );
        directive.$inject = ["$compile","scopeService","corePartialsPath",
            "hibachiPathBuilder"];
        return directive;
    }
}
export{
    SWOrderByControls,
    SWOrderByControlsController
}
