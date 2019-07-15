/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingDisplayCellController{
    /* local state variables */
    public swListingDisplay:any;
    public pageRecord:any;
    public pageRecordKey:string;
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
        public $scope,
        public observerService
    ){
        
        if(!this.pageRecordKey && this.column){
            this.pageRecordKey = this.listingService.getPageRecordKey(this.column.propertyIdentifier);
        }
        
        if(!this.value && this.pageRecord && this.pageRecordKey){
            this.value = this.pageRecord[this.pageRecordKey];        
        }
        
        this.popover = this.utilityService.replaceStringWithProperties(this.column.tooltip, this.pageRecord)

        this.hasActionCaller = false;
        
        if(this.column.action && this.column.queryString){
            
            this.hasActionCaller = true;
            this.actionCaller = {
                action:this.column.action
            }
            
            this.actionCaller.queryString=this.utilityService.replaceStringWithProperties(this.column.queryString,this.pageRecord);
            
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
        
        } else if(!this.hasActionCaller){
            
            this.templateUrl = this.getDirectiveTemplate();
        }


    }

    public hasAggregate = ()=>{
        return this.column.aggregate && this.column.aggregate.aggregateFunction && this.column.aggregate.aggregateFunction.length;
    }

    public getDirectiveTemplate = ()=>{
        
        var basePartialPath = this.hibachiPathBuilder.buildPartialsPath(this.listingPartialPath);
        
        if(this.column.isEditable){
            
            if(!this.column.type){
                this.column.type = 'text';
            }
            
            if(this.column.defaultValue){
                this.pageRecord[this.column.propertyIdentifier] = this.column.defaultValue;
            }
            
            return basePartialPath + 'listingdisplaycelledit.html';
        }
        
        var templateUrl = basePartialPath + 'listingdisplaycell.html';
        
        var listingDisplayIsExpandableAndPrimaryColumn = (this.swListingDisplay.expandable && this.column.tdclass && this.column.tdclass === 'primary');
        
        if(this.expandable || listingDisplayIsExpandableAndPrimaryColumn){
            templateUrl = basePartialPath + 'listingdisplayselectablecellexpandable.html';
        } else if(!listingDisplayIsExpandableAndPrimaryColumn){
            
            if(this.column.ormtype === 'timestamp'){
                templateUrl = basePartialPath + 'listingdisplaycelldate.html';
            }else if(this.column.type === 'currency'){
                if(this.hasAggregate() && this.pageRecord){
                    var pageRecordKey = this.swListingDisplay.getPageRecordKey(this.column.aggregate.aggregateAlias);
                    this.value = this.pageRecord[pageRecordKey];
                }
                templateUrl = basePartialPath + 'listingdisplaycellcurrency.html';
            }else if([
                "double", 
                "float", 
                "integer", 
                "long", 
                "short", 
                "big_decimal"
            ].indexOf(this.column.ormtype) != -1){  
                templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.listingPartialPath)+'listingdisplaycellnumeric.html'; 
            }else if(this.hasAggregate()){
                this.value = this.pageRecord[this.swListingDisplay.getPageRecordKey(this.column.aggregate.aggregateAlias)];
                templateUrl = basePartialPath + 'listingdisplaycellaggregate.html';
            }
        
            
        }

        return templateUrl;
    }
    
    //prevent listing display edit cell from submitting the form if enter key is pressed
    public handleKeyPress = (keyEvent) =>{
        if (keyEvent.keyCode === 13) {
            keyEvent.preventDefault();
            keyEvent.stopPropagation();
        }
        
        this.cellModified();
    }
    
    // announce cell has been modified
    public cellModified = () =>{
        this.observerService.notifyById("cellModified", this.pageRecord.$$hashKey, this.pageRecord);
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


