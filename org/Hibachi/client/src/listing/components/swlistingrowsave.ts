/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingRowSaveController{

    private listingID:string; 
    private pageRecord:any; 
    private pageRecordIndex:number; 

    //@ngInject
    constructor(
        private listingService
    ){

    }

    public save = () =>{
        this.listingService.markSaved(this.listingID,this.pageRecordIndex);
    }
}

class SWListingRowSave implements ng.IDirective{
    public templateUrl;
    public restrict:string = 'EA';
    public scope=true;
    public bindToController={

    };
    public controller=SWListingRowSaveController;
    public controllerAs="swListingRowSave";
    public static $inject = ['utilityService'];

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            hibachiPathBuilder,
            listingPartialPath,
            utilityService,
            scopeService
        )=>new SWListingRowSave(
            hibachiPathBuilder,
            listingPartialPath,
            utilityService,
            scopeService
        );
        directive.$inject = [
            'hibachiPathBuilder',
            'listingPartialPath',
            'utilityService',
            'scopeService'
        ];
        return directive;
    }
    constructor(private hibachiPathBuilder, 
                private listingPartialPath, 
                private utilityService,
                private scopeService
    ){
       this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.listingPartialPath)+'listingrowsave.html';
    }

    public link:ng.IDirectiveLinkFn = ($scope:any, element:any, attrs:any) =>{
            var currentScope = this.scopeService.getRootParentScope($scope, "pageRecord");
            if(angular.isDefined(currentScope["pageRecord"])){
                $scope.swListingRowSave.pageRecord = currentScope["pageRecord"];
            }
            
            var currentScope = this.scopeService.getRootParentScope($scope, "pageRecordKey");
            if(angular.isDefined(currentScope["pageRecordKey"])){
                $scope.swListingRowSave.pageRecordIndex = currentScope["pageRecordKey"];
            }

            var currentScope = this.scopeService.getRootParentScope($scope, "swListingDisplay");
            if(angular.isDefined(currentScope["swListingDisplay"])){
                $scope.swListingRowSave.listingID = currentScope["swListingDisplay"].tableID;
            }
    }
}
export{
    SWListingRowSave
}
