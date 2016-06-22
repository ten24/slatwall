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
            corePartialsPath,
            utilityService,
            scopeService
        )=>new SWListingRowSave(
            hibachiPathBuilder,
            corePartialsPath,
            utilityService,
            scopeService
        );
        directive.$inject = [
            'hibachiPathBuilder',
            'corePartialsPath',
            'utilityService',
            'scopeService'
        ];
        return directive;
    }
    constructor(private hibachiPathBuilder, 
                private corePartialsPath, 
                private utilityService,
                private scopeService
    ){
       this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.corePartialsPath)+'listingrowsave.html';
    }

    public link:ng.IDirectiveLinkFn = ($scope:any, element:any, attrs:any) =>{
            var currentScope = this.scopeService.locateParentScope($scope, "pageRecord");
            if(angular.isDefined(currentScope["pageRecord"])){
                $scope.swListingRowSave.pageRecord = currentScope["pageRecord"];
            }
            
            var currentScope = this.scopeService.locateParentScope($scope, "pageRecordKey");
            if(angular.isDefined(currentScope["pageRecordKey"])){
                $scope.swListingRowSave.pageRecordIndex = currentScope["pageRecordKey"];
            }

            var currentScope = this.scopeService.locateParentScope($scope, "swMultiListingDisplay");
            if(angular.isDefined(currentScope["swMultiListingDisplay"])){
                $scope.swListingRowSave.listingID = currentScope["swMultiListingDisplay"].tableID;
            }
    }
}
export{
    SWListingRowSave
}