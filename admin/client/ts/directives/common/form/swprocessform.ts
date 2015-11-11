/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />

module slatwalladmin {
    export class swFormProcessController {
        private name;
        private partialsPath;
        
        constructor() {
            console.log('Instantiating: ', this.name);
        }
    }
    export class swFormProcess implements ng.IDirective {
        restrict = 'E';
        name = "";
        require = "";
        scope = {};
        transclude = false;
        bindToController = {
            name: "@?"
        };
        controller = swFormProcessController;
        
        templateUrl = "formprocess.html";
        $inject = ['partialsPath'];
        constructor(public partialsPath) {
            
            this.templateUrl = partialsPath + this.templateUrl;
            console.log(this.templateUrl);
            
        } 
    }
    angular.module('slatwalladmin').directive('swFormProcess', ['partialsPath', (partialsPath) => new swFormProcess(partialsPath)]);
}



	
