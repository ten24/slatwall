/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwallFrontend {
    export interface IPostFactory {
            dataFactory: {},
            Get: () => {};
    }
    export class ProcessObject implements IPostFactory {
        /**
         * DataFactory contains all endpoints available to the Account Object.
         */
        dataFactory = {
            $get: (processObject, entityName) => {
                var urlBase = "/index.cfm/api/scope/getProcessObjectDefinition/?ajaxRequest=1&processObject="+processObject+"&entityName="+entityName+"";
                return this.http.get(urlBase);
            }
        };
        
        public http: ng.IHttpService;
        static $inject = ['$http'];
        
        constructor($http: ng.IHttpService) {
            this.http = $http;
        }

        /**
         * Returns an instance of the dataFactory
         */
        Get = (): {} =>{
            return this.dataFactory;
        }
    }
    angular.module('slatwalladmin').service('ProcessObject',['$http',($http) => new ProcessObject($http)]);
}

