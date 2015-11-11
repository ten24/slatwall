/// <reference path="../../../typings/tsd.d.ts" />
/// <reference path="../../../typings/slatwallTypeScript.d.ts" />
//services
import pagination = require('./services/paginationservice');
import SWPaginationBar = require('./components/swpaginationbar');


export = angular.module('hibachi.pagination', [])
.run([function() {
	console.log(pagination.PaginationService);
}])
//services
.service('paginationService', pagination.PaginationService)
.directive('swPaginationBar', SWPaginationBar.factory());
;




