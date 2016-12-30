/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAddFilterButtons{

    public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $http,
            $compile,
            $templateCache,
            collectionService,
            collectionPartialsPath,
            hibachiPathBuilder
        ) => new SWAddFilterButtons(
            $http,
            $compile,
            $templateCache,
            collectionService,
            collectionPartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = [
            '$http',
            '$compile',
            '$templateCache',
            'collectionService',
            'collectionPartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    }
    //@ngInject
    constructor(
        $http,
        $compile,
        $templateCache,
        collectionService,
        collectionPartialsPath,
        hibachiPathBuilder
    ){
        return {

          require:'^swFilterGroups',
          restrict: 'E',
          templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+"addfilterbuttons.html",
          scope:{
              itemInUse:"=",
              readOnly:"="
          },
          link: function(scope, element,attrs,filterGroupsController){
              scope.filterGroupItem = filterGroupsController.getFilterGroupItem();

              scope.addFilterItem = function(){
                  collectionService.newFilterItem(filterGroupsController.getFilterGroupItem(),filterGroupsController.setItemInUse);
              };

              scope.addFilterGroupItem = function(){
                  collectionService.newFilterItem(filterGroupsController.getFilterGroupItem(),filterGroupsController.setItemInUse,true);
              };
          }
      };
    }
}
export{
    SWAddFilterButtons
}


