/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import { CollectionConfig } from "../../collection/services/collectionconfigservice";

//'use strict';

class SWCollectionConfigAsPropertyController{
    public baseEntityName:string;
    public entityCollectionConfig:CollectionConfig;
    public tableID:string;
    public inputValue:string;
    public propertyName:string;
    public value:string; //NEEDS TO BE encodedForHTML if you're passing this from CF into Angular
    
    //@ngInject
    constructor(
        public collectionConfigService,
        public utilityService,
        public observerService,
    ){
        this.tableID = this.utilityService.createID();
        this.observerService.attach(this.handleConfigChange,'swPaginationUpdate',this.tableID);
        if(this.value){
            this.entityCollectionConfig = this.collectionConfigService.loadJson(this.value);
            return;
        }
        this.entityCollectionConfig = this.collectionConfigService.newCollectionConfig(this.baseEntityName);
        
    }
    
    private handleConfigChange = (data)=>{
        this.inputValue = angular.toJson(data.collectionConfig);
    }

}

 class SWCollectionConfigAsProperty implements ng.IDirective{

    public restrict:string = 'E';
    public scope = {};
    public bindToController={
        baseEntityName:"=",
        propertyName:"=",
        value:"=?",
    };
    public controller=SWCollectionConfigAsPropertyController;
    public controllerAs="swCollectionConfigAsProperty";
    public templateUrl;
   public static Factory(){
        var directive = (
            coreFormPartialsPath,
            hibachiPathBuilder
        ) => new SWCollectionConfigAsProperty(
            coreFormPartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = ['coreFormPartialsPath','hibachiPathBuilder'];
        return directive;
    }
    // @ngInject
    constructor( public coreFormPartialsPath, public hibachiPathBuilder) {
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + "collectionconfigasproperty.html";
    }

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{}
}


export {
    SWCollectionConfigAsProperty
};
