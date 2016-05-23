/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingColumnController{
    public editable:boolean;
    public cellView:string;
    public hasCellView:boolean=false;
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
                console.log('directive Found!');
                this.hasCellView = true;
            }else{
                throw(this.cellView + ' is not an existing directive');
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
        fallbackPropertyIdentifiers:"@?"
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
            isVisible:scope.swListingColumn.isVisible || true
        };

        if(scope.swListingColumn.hasCellView){
            column.cellView = scope.swListingColumn.cellView;
        }

        //aggregate logic
        if(scope.swListingColumn.aggregate){
            column.aggregate = scope.swListingColumn.aggregate;
            column.aggregate.propertyIdentifier = scope.swListingColumn.propertyIdentifier;
        }
        //TEMP OVERRIDES for TEMP multilisting directive
        if(angular.isDefined(scope.$parent.$parent.swMultiListingDisplay)){
             var listingDisplayScope = scope.$parent.$parent.swMultiListingDisplay;
        }else if(angular.isDefined(scope.$parent.swListingDisplay)){
             var listingDisplayScope = scope.$parent.swListingDisplay;
        }else {
            throw("listing display scope not available to sw-listing-column")
        }
        
        if(this.utilityService.ArrayFindByPropertyValue(listingDisplayScope.columns,'propertyIdentifier',column.propertyIdentifier) === -1){
            console.log("whitewhale", scope)
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