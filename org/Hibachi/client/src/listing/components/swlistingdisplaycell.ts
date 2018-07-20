/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingDisplayCellController{
    /* local state variables */
    public swListingDisplay:any;
    public pageRecord:any;
    public column:any;
    public popover:any;
    public value:any;
    public templateUrl:any;
    public hasActionCaller:boolean;
    public actionCaller:any;
    //string that should translate to a custom directive
    public cellView:string;
    public template:string;
    public templateVariables:any; 
    public expandable:boolean=false; 
    public expandableRules; 

    //@ngInject
    constructor(
        public listingPartialPath,
        public hibachiPathBuilder,
        public listingService, 
        public utilityService,
        public $scope
    ){
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.listingPartialPath = listingPartialPath;
        this.$scope = $scope;
        if(!this.value && this.pageRecord && this.column){
            this.value = this.listingService.getPageRecordValueByColumn(this.pageRecord, this.column);        
        }
        this.popover = this.utilityService.replaceStringWithProperties(this.column.tooltip, this.pageRecord)

        this.hasActionCaller = false;
        if(this.column.action && this.column.queryString){
            this.hasActionCaller = true;
            this.actionCaller = {
                action:this.column.action
            }
            if(this.column.queryString){
                this.actionCaller.queryString=this.utilityService.replaceStringWithProperties(this.column.queryString,this.pageRecord);
            }
        }

        if(this.cellView){
            var htmlCellView = this.utilityService.camelCaseToSnakeCase(this.cellView);
            this.template = htmlCellView;
            
            //convert the page records into attrs
            this.templateVariables = this.pageRecord; 
            if(angular.isDefined(this.column.columnID)){
                this.templateVariables["column"] = this.column.columnID;
            }
            if(angular.isDefined(this.swListingDisplay.baseEntityName) && angular.isDefined(this.swListingDisplay.baseEntityId)){
                this.templateVariables["baseEntityId"] = this.swListingDisplay.baseEntityId; 
                this.templateVariables["baseEntityName"] = this.swListingDisplay.baseEntityName; 
            }
            if(angular.isDefined(this.column.propertyIdentifier)){
                this.templateVariables["columnPropertyIdentifier"] = this.column.propertyIdentifier;
            }
            this.templateVariables["listingDisplayID"] = this.swListingDisplay.tableID; 
        
        }else if(!this.hasActionCaller){
            
            this.templateUrl = this.getDirectiveTemplate();
        }


    }

    public getDirectiveTemplate = ()=>{
        
        var templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.listingPartialPath)+'listingdisplaycell.html';
        
        if(this.expandable || (this.swListingDisplay.expandable && this.column.tdclass && this.column.tdclass === 'primary')){
            templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.listingPartialPath)+'listingdisplayselectablecellexpandable.html';
        }

        if(!this.swListingDisplay.expandable || !this.column.tdclass || this.column.tdclass !== 'primary'){
            if(this.column.ormtype === 'timestamp'){
                templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.listingPartialPath)+'listingdisplaycelldate.html';
            }else if(this.column.type==='currency'){
                if(this.column.aggregate && this.pageRecord){
                    var pageRecordKey = this.swListingDisplay.getPageRecordKey(this.column.aggregate.aggregateAlias);
                    this.value = this.pageRecord[pageRecordKey];
                }
                templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.listingPartialPath)+'listingdisplaycellcurrency.html';
            }else if([
                "double", 
                "float", 
                "integer", 
                "long", 
                "short", 
                "big_decimal"
            ].indexOf(this.column.ormtype) != -1){  
                templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.listingPartialPath)+'listingdisplaycellnumeric.html'; 
            }else if(this.column.aggregate){
                this.value = this.pageRecord[this.swListingDisplay.getPageRecordKey(this.column.aggregate.aggregateAlias)];
                templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.listingPartialPath)+'listingdisplaycellaggregate.html';
            }
        }

        return templateUrl;
    }
}

class SWListingDisplayCell {

    public restrict:string = 'E';
    public scope = {};
    public bindToController={
        swListingDisplay:"=?",
        column:"=?",
        pageRecord:"=?",
        value:"=?",
        cellView:"@?",
        expandableRules:"=?"
    }
    public controller=SWListingDisplayCellController;
    public controllerAs="swListingDisplayCell";
    public template=`
        <div ng-if="swListingDisplayCell.template" sw-directive data-variables="swListingDisplayCell.templateVariables" data-directive-template="swListingDisplayCell.template"></div>
        <div ng-if="swListingDisplayCell.templateUrl" ng-include src="swListingDisplayCell.templateUrl"></div>
        <sw-action-caller ng-if="swListingDisplayCell.hasActionCaller"
                    data-action="{{swListingDisplayCell.actionCaller.action}}"
                    data-query-string="{{swListingDisplayCell.actionCaller.queryString}}"
                    data-text="{{swListingDisplayCell.value}}"
                    data-tooltip-text="{{swListingDisplayCell.popover}}"
                    data-is-angular-route="false"

        >
        </sw-action-caller>
    `;

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
        ) => new SWListingDisplayCell(
        );
        directive.$inject =[
        ];
        return directive;
    }
    //@ngInject
    constructor(
    ){

    }
}
export{
    SWListingDisplayCell
}


