/// <reference path='../../../typings/hibachiTypescript.d.ts' />

class SWCollectionOrderByController{
    constructor(){}
}

class SWCollectionOrderBy implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public bindToController={
        orderBy:"@"
    };
    public controller=SWCollectionOrderByController;
    public controllerAs="SWCollectionOrderBy";
    public template = "";

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            scopeService
        )=>new SWCollectionOrderBy(
            scopeService
        );
        directive.$inject = [
            'scopeService'
        ];
        return directive;
    }

    //@ngInject
    constructor(public scopeService){}

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
        var orderBy = scope.SWCollectionOrderBy.orderBy;


        var currentScope = this.scopeService.getRootParentScope(scope, "swCollectionConfig");

        if(angular.isDefined(currentScope.swCollectionConfig)){
            currentScope.swCollectionConfig.orderBys.push(orderBy);
            currentScope.swCollectionConfig.orderBysDeferred.resolve();
        } else {
            throw("could not find swCollectionConfig in the parent scope from swcollectionorderby");
        }
    }
}
export{
    SWCollectionOrderByController,
    SWCollectionOrderBy
}