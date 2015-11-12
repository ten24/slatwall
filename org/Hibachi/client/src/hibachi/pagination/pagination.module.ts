/// <reference path="../../../typings/tsd.d.ts" />
/// <reference path="../../../typings/slatwallTypeScript.d.ts" />
//services
import {PaginationService} from "./services/paginationservice";
import {SWPaginationBar} from "./components/swpaginationbar";


var paginationmodule = angular.module('hibachi.pagination', [])
.run([function() {
	console.log(PaginationService);
}])
//services
.service('paginationService', PaginationService)
.directive('swPaginationBar', SWPaginationBar.factory());
;

export{
	paginationmodule
}




