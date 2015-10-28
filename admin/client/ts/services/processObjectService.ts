/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
    interface IPostFactory {
            dataFactory: {},
            GetInstance: () => {};
    }
    export class ProcessObject implements IPostFactory {
        /**
         * DataFactory contains all endpoints available to the Account Object.
         */
        dataFactory = {
            $get: (data) => {
                var urlBase = "/index.cfm/api/scope/getProcessObjectDefinition/?ajaxRequest=1&processObject="+data.processObject+"&entityName="+data.entityName+"";
                return this.http.get(urlBase);
            }
        };
        
        public http: ng.IHttpService;
        static $inject = ['$http'];
        
        toFormParams(data){
            return data = $.param(data) || "";
        }
        constructor($http: ng.IHttpService) {
            this.http = $http;
        }

        /**
         * Returns an instance of the dataFactory
         */
        GetInstance = (): {} =>{
            return this.dataFactory;
        }
    }
    angular.module('slatwalladmin').service('ProcessObject',['$http',($http) => new ProcessObject($http)]);
}

