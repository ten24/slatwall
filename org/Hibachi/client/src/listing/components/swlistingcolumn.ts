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
    public swListingDisplay:any; 
    public fallbackPropertyIdentifiers:string;
    public processObjectProperty:any;
    public title:string;
    public tdclass:string;
    public search:boolean;
    public sort:boolean;
    public filter:boolean;
    public range:any;
    public buttonGroup:any;
    public aggregate:any;
    //@ngInject
    constructor(
        public $injector,
        public utilityService,
        public listingService
        
    ){
        this.$injector = $injector;
        this.utilityService = utilityService;
        this.listingService = listingService;
    }

    public $onInit=()=>{
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
        
        var column:any = {
            columnID: "C" + this.utilityService.createID(31),
            propertyIdentifier:this.propertyIdentifier,
            fallbackPropertyIdentifiers:this.fallbackPropertyIdentifiers,
            processObjectProperty:this.processObjectProperty,
            title:this.title,
            tdclass:this.tdclass,
            search:this.search,
            sort:this.sort,
            filter:this.filter,
            range:this.range,
            editable:this.editable,
            buttonGroup:this.buttonGroup,
            hasCellView:this.hasCellView,
            hasHeaderView:this.hasHeaderView, 
            isVisible:this.isVisible || true,
            action:this.action, 
            queryString:this.queryString
        };

        if(this.hasCellView){
            column.cellView = this.cellView;
        }
        if(this.hasHeaderView){
            column.headerView = this.utilityService.camelCaseToSnakeCase(this.headerView);
        }

        //aggregate logic
        if(this.aggregate){
            column.aggregate = this.aggregate;
            column.aggregate.propertyIdentifier = this.propertyIdentifier;
        }
        
        
console.log('listingdisplay',this);
        if(angular.isDefined(this.swListingDisplay) 
            && this.swListingDisplay.tableID
            && this.swListingDisplay.tableID.length
        ){
            
            var listingDisplayID = this.swListingDisplay.tableID;
            this.listingService.addColumn(listingDisplayID, column);
        }else {
            throw("listing display scope not available to sw-listing-column or there is no table id")
        }   
    }
}

class SWListingColumn implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public require = {swListingDisplay:"?^swListingDisplay"};
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

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
        )=>new SWListingColumn(
        );
        directive.$inject = [
        ];
        return directive;
    }
    constructor( 
    ){

    }
}
export{
    SWListingColumn
}
