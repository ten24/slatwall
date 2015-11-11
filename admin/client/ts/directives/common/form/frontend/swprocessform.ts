/// <reference path='../../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../../client/typings/tsd.d.ts' />

/** The idea here is to use a single directive as a wrapper of all other frontend directives
 *  eliminating the need for the individual controllers for each directive.
 */
module slatwalladmin {
    export class swFormProcessController {
        private name;
        private partialsPath;
        
        constructor() {
            console.log('Instantiating: ', this.directiveName);
        }
    }
    export class swFormProcess implements ng.IDirective {
        restrict = 'E';
        name = "";
        require = "";
        scope = {};
        transclude = false;
        bindToController = {
            directiveName: "@?"
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



	
