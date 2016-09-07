/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWListingFilterGroupController{
    public filters = [];

    constructor(
            public $scope,
            public $transclude
    ){
            $transclude($scope,()=>{});
            $scope.$parent.swListingDisplay.filterGroups.push(this.filters);
    }

}
class SWListingFilterGroup implements ng.IDirective{
    public restrict:string = 'EA';
    public transclude=true;
    public scope=true;
    public bindToController={};
    public controller=SWListingFilterGroupController;
    public controllerAs="swListingFilterGroup";
    public static $inject = [];
    public static Factory(){
        var directive:ng.IDirectiveFactory=()=>new SWListingFilterGroup();
        directive.$inject = [];
        return directive;
    }

}
export{
    SWListingFilterGroup
}
