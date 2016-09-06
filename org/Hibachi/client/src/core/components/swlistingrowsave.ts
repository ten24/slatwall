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
<<<<<<< HEAD
            var currentScope = this.scopeService.locateParentScope($scope, "pageRecord");
=======
            var currentScope = this.scopeService.getRootParentScope($scope, "pageRecord");
>>>>>>> 8752089deaa3a8bd5071e97f8e60c1e1b7ff9486
            if(angular.isDefined(currentScope["pageRecord"])){
                $scope.swListingRowSave.pageRecord = currentScope["pageRecord"];
            }
            
<<<<<<< HEAD
            var currentScope = this.scopeService.locateParentScope($scope, "pageRecordKey");
=======
            var currentScope = this.scopeService.getRootParentScope($scope, "pageRecordKey");
>>>>>>> 8752089deaa3a8bd5071e97f8e60c1e1b7ff9486
            if(angular.isDefined(currentScope["pageRecordKey"])){
                $scope.swListingRowSave.pageRecordIndex = currentScope["pageRecordKey"];
            }

<<<<<<< HEAD
            var currentScope = this.scopeService.locateParentScope($scope, "swListingDisplay");
=======
            var currentScope = this.scopeService.getRootParentScope($scope, "swListingDisplay");
>>>>>>> 8752089deaa3a8bd5071e97f8e60c1e1b7ff9486
            if(angular.isDefined(currentScope["swListingDisplay"])){
                $scope.swListingRowSave.listingID = currentScope["swListingDisplay"].tableID;
            }
    }
}
export{
    SWListingRowSave
}