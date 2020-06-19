/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {SWPropertyDisplay,SWPropertyDisplayController} from "./swpropertydisplay";

class SWFPropertyDisplayController extends SWPropertyDisplayController {
    //@ngInject
    constructor(
        public $filter,
        public utilityService,
        public $injector,
        public metadataService,
        public observerService
    ){
        super($filter,utilityService,$injector,metadataService,observerService);

        this.edit = true;

    }
}

class SWFPropertyDisplay extends SWPropertyDisplay{
    public controller=SWFPropertyDisplayController;
    public controllerAs="swfPropertyDisplay";
    public scope={};
    //@ngInject
    constructor(
        public $compile,
        public scopeService,
        public coreFormPartialsPath,
        public hibachiPathBuilder,
        public swpropertyPartialPath
    ){
        super(
            $compile,
            scopeService,
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