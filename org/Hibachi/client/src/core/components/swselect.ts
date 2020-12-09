/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

interface ISWSelectScope {
    collection:string;
    id?:string;
    value:string;
}

class SWSelectController{
    public collection;
    public collectionConfig;
    public id;
    public value;
    public collectionObject;

    private selectCollectionConfig;
    private exampleEntity;

    private selectedOption;
    private options;
    //@ngInject
    constructor(
        protected $scope: ISWSelectScope,
        protected $hibachi,
        protected observerService,
        protected collectionConfigService
    ){
        this.init();

    }

    public init =()=> {
        if(angular.isString(this.collection)){
            this.collectionObject = this.collection;
        }else{
            this.collectionObject =  this.collection.baseEntityName;
        }

        this.selectCollectionConfig = this.collectionConfigService.newCollectionConfig(this.collectionObject);

        if(angular.isUndefined(this.id)){
            //this.id = $hibachi.getPrimaryIDPropertyNameByEntityName(this.objectName); // Not Working!!!
            this.exampleEntity = this.$hibachi.newEntity(this.collectionObject);
            this.id = this.exampleEntity.$$getIDName();
        }

        if(angular.isUndefined(this.value)){
            this.value = this.collectionObject.charAt(0).toLowerCase() + this.collectionObject.slice(1) +'Name';
        }

        if(!angular.isString(this.collection)){
            this.selectCollectionConfig.loadJson(this.collection);
        }

        this.selectCollectionConfig.addDisplayProperty(this.id+','+this.value);
        this.selectCollectionConfig.setAllRecords(true);

        this.selectCollectionConfig.getEntity().then((res) =>{
            this.options = res.records;
        });
    };

    public selectOption = ()=>{
        this.observerService.notify('optionsChanged',this.selectedOption);
    }


}

class SWSelect implements ng.IDirective{

    public restrict:string = 'EA';
    public scope=true;
    public bindToController: ISWSelectScope ={
        collection:"=",
        id:"@?",
        value:"@?"
    };
    public controller=SWSelectController;
    public controllerAs="swSelect";
    public static $inject = ['corePartialsPath','hibachiPathBuilder'];

    public templateUrl;
    //@ngInject
    constructor(
        public corePartialsPath,
        public hibachiPathBuilder
    ){
        this.corePartialsPath = corePartialsPath;
        this.hibachiPathBuilder = hibachiPathBuilder;
        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.corePartialsPath+'select.html');
    }
    public static Factory(){
        var directive = (
            corePartialsPath,
            hibachiPathBuilder
        )=>new SWSelect(
            corePartialsPath,
                hibachiPathBuilder
        );
        directive.$inject = [
            'corePartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    }
    
    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}
export{
    SWSelect
}