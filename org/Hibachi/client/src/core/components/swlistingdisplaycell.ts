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
    //@ngInject
    constructor(
        public corePartialsPath,
        public hibachiPathBuilder,
        public utilityService,
        public $scope
    ){
        console.log('controller');
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.corePartialsPath = corePartialsPath;
        this.$scope = $scope;
        this.value = this.pageRecord[this.swListingDisplay.getPageRecordKey(this.column.propertyIdentifier)];
        this.popover = this.utilityService.replaceStringWithProperties(this.column.tooltip, this.pageRecord)
        
        this.templateUrl = this.getDirectiveTemplate();
    }
    
    public getDirectiveTemplate = ()=>{
        console.log('test');
        console.log(this);
        var templateUrl = 'none';
        if(this.swListingDisplay.expandable && this.column.tdclass && this.column.tdclass === 'primary'){
            templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.corePartialsPath)+'listingdisplayselectablecellexpandable.html';
        }
        
        if(!this.swListingDisplay.expandable || !this.column.tdclass || this.column.tdclass !== 'primary'){
            if(this.column.ormtype === 'timestamp'){
                templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.corePartialsPath)+'listingdisplaycelldate.html';
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
        pageRecord:"=?"  
    }
    public controller=SWListingDisplayCellController;
    public controllerAs="swListingDisplayCell";
    public template='{{swListingDisplayCell.templateUrl}}<div ng-include src="swListingDisplayCell.templateUrl"></div>';
    
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


