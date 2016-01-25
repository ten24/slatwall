/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

//import pagination = require('../services/paginationservice');
//var PaginationService = pagination.PaginationService;
//'use strict';

class SWPaginationBarController{
    public paginator;
    //@ngInject
    constructor(paginationService){
        if(angular.isUndefined(this.paginator)){
            this.paginator = paginationService.createPagination();
        }
    }
}

 class SWPaginationBar implements ng.IDirective{

    public restrict:string = 'E';
    public scope = {};
    public bindToController={
        paginator:"="
    };
    public controller=SWPaginationBarController;
    public controllerAs="swPaginationBar";
    public templateUrl;
    public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (hibachiPathBuilder,partialsPath) => new SWPaginationBar(hibachiPathBuilder,partialsPath);
        directive.$inject = ['hibachiPathBuilder','partialsPath'];
        return directive;
    }

    //@ngInject
    constructor(hibachiPathBuilder,partialsPath){


        this.templateUrl = hibachiPathBuilder.buildPartialsPath(partialsPath)+'paginationbar.html';
    }


    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

    }
}

//class SWPaginationBarFactory{
//    public static getFactoryFor<T extends SWPaginationBar>(classType:Function):ng.IDirectiveFactory {
//        var factory = (...args:any[]):T=>{
//            var directive = <any>classType;
//            return new directive(args);
//        }
//
//        factory.$inject = classType.$inject;
//        return factory;
//        // var directive: ng.IDirectiveFactory =
//        //                ($log:ng.ILogService, $timeout:ng.ITimeoutService, partialsPath, paginationService) => new SWPaginationBar( $log,  $timeout, partialsPath,  paginationService);
//        // directive.$inject = ['$log','$timeout','partialsPath','paginationService'];
//        // return directive;
//    }
//}
export {
    SWPaginationBar,
    SWPaginationBarController
};

	//angular.module('hibachi.pagination').directive('swPaginationBar',['$log','$timeout','partialsPath','paginationService',($log,$timeout,partialsPath,paginationService) => new SWPaginationBar($log,$timeout,partialsPath,paginationService)]);

