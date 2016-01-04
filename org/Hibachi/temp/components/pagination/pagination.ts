/// <reference path="../../../typings/tsd.d.ts" />
/// <reference path="../../../typings/slatwallTypeScript.d.ts" />
module hibachi.pagination{
    angular.module('hibachi.pagination',[])
    .service('paginationService', PaginationService)
    .directive('swPaginationBar',['$log','$timeout','partialsPath','paginationService',($log,$timeout,partialsPath,paginationService) => new SWPaginationBar($log,$timeout,partialsPath,paginationService)]);
   
    
}
