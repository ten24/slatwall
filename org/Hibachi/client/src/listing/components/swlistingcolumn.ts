/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingColumnController{
    public propertyIdentifier:string; 
    public editable:boolean;
    public cellView:string;
    public hasCellView:boolean=false;
    public headerView:string; 
    public hasHeaderView:boolean=false;
    public action:string; 
    public queryString:string; 
    public isVisible:boolean; 
    //@ngInject
    constructor(
        public $injector
    ){
        this.$injector = $injector;
        this.init();
    }

    public init = () =>{
        if(angular.isUndefined(this.isVisible)){
             this.isVisible = true;
        }
        
        this.editable = this.editable || false;
        //did a cellView get suggested, if so does it exist
        if(this.cellView){
            if(this.$injector.has(this.cellView+'Directive')){
                this.hasCellView = true;
            }else{
                throw(this.cellView + ' is not an existing directive');
            }
        }
        if(this.headerView){
            if(this.$injector.has(this.headerView+'Directive')){
                this.hasHeaderView = true;
            }else{
                throw(this.headerView + ' is not an existing directive');
            }
        }
    }
}

class SWListingColumn implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public bindToController={
        propertyIdentifier:"@",
        processObjectProperty:"@?",
        //defined as aggregate = {aggregateFunction:'COUNT',aggregateAlias:'aliasstring'}
        aggregate:"=?",
        title:"@?",
        tdclass:"@?",
        search:"=?",
        sort:"=?",
        filter:"=?",
        isVisible:"=?",
        range:"=?",
        editable:"=?",
        buttonGroup:"=?",
        cellView:"@?",
        headerView:"@?",
        fallbackPropertyIdentifiers:"@?",
        action:"@?",
        queryString:"@?"
    };
    public controller=SWListingColumnController;
    public controllerAs="swListingColumn";
    public static $inject = ['utilityService'];

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            listingService, 
            scopeService,
            utilityService
        )=>new SWListingColumn(
            listingService, 
            scopeService,
            utilityService
        );
        directive.$inject = [
            'listingService', 
            'scopeService',
            'utilityService'
        ];
        return directive;
    }
    constructor( private listingService, 
                 private scopeService, 
                 private utilityService
    ){

    }

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{

        var column:any = {
            columnID: "C" + this.utilityService.createID(31),
            propertyIdentifier:scope.swListingColumn.propertyIdentifier,
            fallbackPropertyIdentifiers:scope.swListingColumn.fallbackPropertyIdentifiers,
            processObjectProperty:scope.swListingColumn.processObjectProperty,
            title:scope.swListingColumn.title,
            tdclass:scope.swListingColumn.tdclass,
            search:scope.swListingColumn.search,
            sort:scope.swListingColumn.sort,
            filter:scope.swListingColumn.filter,
            range:scope.swListingColumn.range,
            editable:scope.swListingColumn.editable,
            buttonGroup:scope.swListingColumn.buttonGroup,
            hasCellView:scope.swListingColumn.hasCellView,
            hasHeaderView:scope.swListingColumn.hasHeaderView, 
            isVisible:scope.swListingColumn.isVisible,
            action:scope.swListingColumn.action, 
            queryString:scope.swListingColumn.queryString
        };

        if(scope.swListingColumn.hasCellView){
            column.cellView = scope.swListingColumn.cellView;
        }
        if(scope.swListingColumn.hasHeaderView){
            column.headerView = this.utilityService.camelCaseToSnakeCase(scope.swListingColumn.headerView);
        }

        //aggregate logic
        if(scope.swListingColumn.aggregate){
            column.aggregate = scope.swListingColumn.aggregate;
            column.aggregate.propertyIdentifier = scope.swListingColumn.propertyIdentifier;
        }
        
        var listingDisplayScope = this.scopeService.getRootParentScope(scope,"swListingDisplay");

        if(angular.isDefined(listingDisplayScope) 
            && angular.isDefined(listingDisplayScope.swListingDisplay)
            && angular.isDefined(listingDisplayScope.swListingDisplay.tableID)
            && listingDisplayScope.swListingDisplay.tableID.length
        ){
            var listingDisplayID = listingDisplayScope.swListingDisplay.tableID;
            this.listingService.addColumn(listingDisplayID, column);
        }else {
            throw("listing display scope not available to sw-listing-column or there is no table id")
        }   
    }
}
export{
    SWListingColumn
}
