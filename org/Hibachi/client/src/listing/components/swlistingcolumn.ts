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
    public isExportable:boolean; 
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
    public persistent:boolean;
    public isDeletable:boolean;
    public column:any;
    public formatType:string;

    //@ngInject
    constructor(
        public $injector,
        public utilityService,
        public listingService,
        public rbkeyService

    ){
        this.$injector = $injector;
        this.utilityService = utilityService;
        this.listingService = listingService;
        this.rbkeyService = rbkeyService;
    }

    public $onInit=()=>{

        if(angular.isUndefined(this.isVisible)){
             this.isVisible = true;
        }
        if(angular.isUndefined(this.isExportable)){
            this.isExportable = true; 
        }
        if(angular.isUndefined(this.isDeletable)){
             this.isDeletable = true;
        }

        if(angular.isUndefined(this.search)){
            this.search = true;
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


        this.column = {
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
            isVisible:this.isVisible,
            isDeletable:this.isDeletable,
            isSearchable:this.search,
            isExportable:this.isExportable,
            action:this.action,
            queryString:this.queryString,
            persistent:this.persistent
        };



        if(this.hasCellView){
            this.column.cellView = this.cellView;
        }
        if(this.hasHeaderView){
            this.column.headerView = this.utilityService.camelCaseToSnakeCase(this.headerView);
        }

        //aggregate logic
        if(this.aggregate){
            this.column.aggregate = this.aggregate;
            this.column.aggregate.propertyIdentifier = this.propertyIdentifier;
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
        isDeletable:"=?",
        isExportable:"=?",
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
            listingService
        )=>new SWListingColumn(
            listingService
        );
        directive.$inject = [
            'listingService'
        ];
        return directive;
    }
    //@ngInject
    constructor(
        public listingService
    ){

    }

    public link=(scope,elem,attr,listingService)=>{

        if(angular.isDefined(scope.swListingDisplay)
            && scope.swListingDisplay.tableID
            && scope.swListingDisplay.tableID.length
        ){
            var listingDisplayID = scope.swListingDisplay.tableID;
            if(
                scope.swListingDisplay.usePersonalCollection !=true
                && scope.swListingDisplay.columns
            ){
                this.listingService.addColumn(listingDisplayID, scope.swListingColumn.column);
                this.listingService.setupColumn(listingDisplayID,scope.swListingColumn.column);
            }

        }else if(
            angular.isDefined(scope.swListingColumn.swListingDisplay)
            && scope.swListingColumn.swListingDisplay.tableID
            && scope.swListingColumn.swListingDisplay.tableID.length
            && scope.swListingColumn.swListingDisplay.usePersonalCollection !=true
            && scope.swListingColumn.swListingDisplay.columns
        ){
            var listingDisplayID = scope.swListingColumn.swListingDisplay.tableID;

            this.listingService.addColumn(listingDisplayID, scope.swListingColumn.column);

        }else {
            throw("listing display scope not available to sw-listing-column or there is no table id")
        }

    }
}
export{
    SWListingColumn
}
