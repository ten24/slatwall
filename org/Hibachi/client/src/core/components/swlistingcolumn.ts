/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingColumnController{
    public editable:boolean;
    public cellView:string;
    public hasCellView:boolean=false;
    public headerView:string; 
    public hasHeaderView:boolean=false;
    //@ngInject
    constructor(
        public $injector
    ){
        this.$injector = $injector;
        this.init();
    }

    public init = () =>{
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
                throw(this.hasHeaderView + ' is not an existing directive');
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
        fallbackPropertyIdentifiers:"@?"
    };
    public controller=SWListingColumnController;
    public controllerAs="swListingColumn";
    public static $inject = ['utilityService'];

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            scopeService,
            utilityService
        )=>new SWListingColumn(
            scopeService,
            utilityService
        );
        directive.$inject = [
            'scopeService',
            'utilityService'
        ];
        return directive;
    }
    constructor(private scopeService, private utilityService){

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
            isVisible:scope.swListingColumn.isVisible || true
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
        
        var listingDisplayScope = this.scopeService.locateParentScope("swListingDisplay");
        if(angular.isDefined(listingDisplayScope.swListingDisplay)){
            listingDisplayScope = listingDisplayScope.swListingDisplay;
        }else {
            throw("listing display scope not available to sw-listing-column")
        }
        
        if(this.utilityService.ArrayFindByPropertyValue(listingDisplayScope.columns,'propertyIdentifier',column.propertyIdentifier) === -1){
            if(column.aggregate){
                listingDisplayScope.aggregates.unshift(column.aggregate);
            }else{
                listingDisplayScope.columns.unshift(column);
            }
        }
    }
}
export{
    SWListingColumn
}