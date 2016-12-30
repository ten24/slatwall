/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {SWPropertyDisplay,SWPropertyDisplayController} from "./swpropertydisplay";

class SWFPropertyDisplayController extends SWPropertyDisplayController {
    //@ngInject
    constructor(
        public $filter,
        public utilityService,
        public $injector,
        public metadataService
    ){
        super($filter,utilityService,$injector,metadataService);

        this.editing = true;
    }
}

class SWFPropertyDisplay extends SWPropertyDisplay{
    public controller=SWFPropertyDisplayController;
    public controllerAs="swfPropertyDisplay";
    //@ngInject
    constructor(
        public coreFormPartialsPath,
        public hibachiPathBuilder,
        public swpropertyPartialPath
    ){
        super(
            coreFormPartialsPath,
            hibachiPathBuilder,
            swpropertyPartialPath
        )
    }

    public link=(scope,element,attrs)=>{

    }

}
export{
    SWFPropertyDisplay,
    SWFPropertyDisplayController
}