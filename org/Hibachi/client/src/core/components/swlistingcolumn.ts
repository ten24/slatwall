/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingColumnController{
    public editable:boolean;

    constructor(

    ){
        this.init();
    }

    public init = () =>{
        this.editable = this.editable || false;
    }
}

class SWListingColumn implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public bindToController={
        propertyIdentifier:"@",
        processObjectProperty:"@?",
        title:"@?",
        tdclass:"@?",
        search:"=?",
        sort:"=?",
        filter:"=?",
        range:"=?",
        editable:"=?",
        buttonGroup:"=?"
    };
    public controller=SWListingColumnController;
    public controllerAs="swListingColumn";
    public static $inject = ['utilityService'];

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            utilityService
        )=>new SWListingColumn(
            utilityService
        );
        directive.$inject = [
            'utilityService'
        ];
        return directive;
    }
    constructor(private utilityService){

    }

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{

        var column = {
            propertyIdentifier:scope.swListingColumn.propertyIdentifier,
            processObjectProperty:scope.swListingColumn.processObjectProperty,
            title:scope.swListingColumn.title,
            tdclass:scope.swListingColumn.tdclass,
            search:scope.swListingColumn.search,
            sort:scope.swListingColumn.sort,
            filter:scope.swListingColumn.filter,
            range:scope.swListingColumn.range,
            editable:scope.swListingColumn.editable,
            buttonGroup:scope.swListingColumn.buttonGroup
        };
        if(this.utilityService.ArrayFindByPropertyValue(scope.$parent.swListingDisplay.columns,'propertyIdentifier',column.propertyIdentifier) === -1){
            scope.$parent.swListingDisplay.columns.unshift(column);
        }
    }
}
export{
    SWListingColumn
}