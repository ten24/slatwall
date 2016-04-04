/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class CollectionFilterItem{
	constructor(
		public name:string,
		public type:string,
		public displayPropertyIdentifier:string,
		public propertyIdentifier:string,
		public displayValue:string,
		public value:string,
		public comparisonOperator?:string,
		public logicalOperator?:string){

	}
}

class SWProductBundleGroupController {

	public $id;
	public showAdvanced;
	public productBundleGroup;
	public maxRecords;
	public recordsCount;
	public pageRecordsStart;
	public pageRecordsEnd;
	public showAll;
	public currentPage;
	public pageShow;
    public recordsPerPage;
	public timeoutPromise;
	public navigation;
	public filterTemplatePath;
	public productBundleGroupFilters;
	public index;
    public keyword;
    public filterTerm;
	public loading;
	public searchOptions;
	public value;
	public collection;
	public collectionConfig;
	public selected;
	public searchCollectionConfig;
    public searchAllCollectionConfigs;
	public formName;
	public filterPropertiesList;
	public totalPages;
	public skuCollectionConfig;
	public removeProductBundleGroup;
    public addProductBundleGroup;
    public productBundleGroups; 

    // @ngInject
	constructor(private $log:ng.ILogService,
                private $timeout:ng.ITimeoutService,
				private collectionConfigService,
				private productBundleService,
                private metadataService,
                private utilityService,
                private formService,
				private $hibachi,
                private productBundlePartialsPath            
    ){
		this.init(); 
	}

    public init = () => {
        this.maxRecords = 10;
        this.recordsCount = 0;
        this.pageRecordsStart = 0;
        this.pageRecordsEnd = 0;
        this.recordsPerPage = 10;
        this.showAll = false;
        this.showAdvanced = false;
        this.currentPage = 1;
        this.pageShow = 10;
        this.searchAllCollectionConfigs = [];

        if(angular.isUndefined(this.filterPropertiesList)){
            this.filterPropertiesList = {};
            var filterPropertiesPromise = this.$hibachi.getFilterPropertiesByBaseEntityName('_sku');
            filterPropertiesPromise.then((value)=>{
                this.metadataService.setPropertiesList(value,'_sku');
                this.filterPropertiesList['_sku'] = this.metadataService.getPropertiesListByBaseEntityAlias('_sku');
                this.metadataService.formatPropertiesList(this.filterPropertiesList['_sku'],'_sku');
            });
        }

		this.searchOptions = {
			options:[
				{
					name:"All",
					value:"All"
				},
				{
					name:"Product Type",
					value:"productType"
				},
				{
					name:"Brand",
					value:"brand"
				},
				{
					name:"Products",
					value:"product"
				},
				{
					name:"Skus",
					value:"sku"
				}
			],
			selected:{
				name:"All",
				value:"All"
			},
			setSelected:(searchOption)=>{
				this.searchOptions.selected = searchOption;
			}
		};

		this.navigation = {
			value:'Basic',
			setValue:(value)=>{
				this.value = value;
			}
		};

		this.filterTemplatePath = this.productBundlePartialsPath +"productbundlefilter.html";
		this.productBundleGroupFilters = {};
		this.productBundleGroupFilters.value = [];
        
        if(angular.isUndefined(this.productBundleGroup.data.skuCollectionConfig) || this.productBundleGroup.data.skuCollectionConfig === null){
            this.productBundleGroup.data.skuCollectionConfig = this.collectionConfigService.newCollectionConfig("Sku").getCollectionConfig();
        }

		var options = {
				filterGroupsConfig:this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup,
				columnsConfig:this.productBundleGroup.data.skuCollectionConfig.columns,
		};

		this.getCollection();
    }

	public deleteEntity = (type?) =>{
        this.removeProductBundleGroup({index:this.index});
        this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup = [];
	};

	public getCollection = () =>{
		var options = {
            filterGroupsConfig:angular.toJson(this.productBundleGroup.data.skuCollectionConfig.filterGroups),
            columnsConfig:angular.toJson(this.productBundleGroup.data.skuCollectionConfig.columns),
            currentPage:1,
            pageShow:10
        };
        var collectionPromise = this.$hibachi.getEntity('Sku',options);
        collectionPromise.then((response)=>{
            this.collection = response;
        });
	}

	public increaseCurrentCount = () =>{
			if(angular.isDefined(this.totalPages) && this.totalPages != this.currentPage){
					this.currentPage++;
			} else {
				this.currentPage = 1;
			}
	};

	public resetCurrentCount = () =>{
			this.currentPage = 1;
	};

	
    public save = () =>{
        var savePromise = this.productBundleGroup.$$save();
        savePromise.then((response)=>{
            this.productBundleGroup.data.$$toggleEdit()
        }).catch((data)=>{
            //error handling handled by $$save
        });
    }
    
    public saveAndAddBundleGroup = () =>{
        var savePromise = this.productBundleGroup.$$save();
        savePromise.then((response)=>{
            this.productBundleGroup.data.$$toggleEdit()
            this.addProductBundleGroup();
        }).catch((data)=>{
            //error handling handled by $$save
        });
    }

}

class SWProductBundleGroup implements ng.IDirective{

	public templateUrl;
	public restrict = "EA";
	public scope = {};

	public bindToController = {
		productBundleGroup:"=",
        productBundleGroups:"=",
		index:"=",
		addProductBundleGroup:"&",
		removeProductBundleGroup:"&",
		formName:"@"
	};
    
	public controller=SWProductBundleGroupController;
	public controllerAs="swProductBundleGroup";

    // @ngInject
	constructor(private $log:ng.ILogService,
                private $timeout:ng.ITimeoutService,
				private collectionConfigService,
				private productBundleService,
                private metadataService,
                private utilityService,
                private formService,
				private $hibachi,
                private productBundlePartialsPath,
			    slatwallPathBuilder){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(productBundlePartialsPath) + "productbundlegroup.html";
	}

	public link:ng.IDirectiveLinkFn = ($scope:any, element:any, attrs:any, ctrl:any) =>{
    }

	public static Factory(){
		var directive = (
            $log, $timeout, collectionConfigService, productBundleService, metadataService, utilityService, formService, $hibachi, productBundlePartialsPath,
			slatwallPathBuilder
        )=> new SWProductBundleGroup(
            $log, $timeout, collectionConfigService, productBundleService, metadataService, utilityService, formService, $hibachi, productBundlePartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            "$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "formService", "$hibachi", "productBundlePartialsPath",
			"slatwallPathBuilder"
        ];
        
        return directive;
	}
}

export{
	SWProductBundleGroup
}
