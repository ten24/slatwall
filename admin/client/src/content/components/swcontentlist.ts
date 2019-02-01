/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWContentListController{
    public getCollection:Function;
    public openRoot:boolean;
    public pageShowOptions:any;
    public pageShow:any;
    public loadingCollection:boolean;
    public selectedSite:any;
    public orderBy:any;
    public collectionConfig:any;
    public collectionListingPromise:any;
    public collection:any;
    public firstLoad:boolean;
    public isSearching:boolean;
    public keywords:string;
    public searchCollection:any;

    //@ngInject
    constructor(
        public $scope:ng.IScope,
        public $log:ng.ILogService,
        public $timeout:ng.ITimeoutService,
        public $hibachi,
        public paginationService,
        public observerService,
        public collectionConfigService,
        public localStorageService
    ){
            this.openRoot = true;
            this.$log.debug('slatwallcontentList init');
            var pageShow = 50;
            if(this.pageShow !== 'Auto'){
                pageShow = this.pageShow;
            }

            this.pageShowOptions = [
                {display:10,value:10},
                {display:20,value:20},
                {display:50,value:50},
                {display:250,value:250}
            ];

            this.loadingCollection = false;


            if(this.localStorageService.hasItem('selectedSiteOption')){
                this.selectedSite = this.localStorageService.getItem('selectedSiteOption');
            }

            this.orderBy;
            var orderByConfig;

            this.getCollection = (isSearching)=>{

                this.collectionConfig = collectionConfigService.newCollectionConfig('Content');


                var columnsConfig = [
                    //{"propertyIdentifier":"_content_childContents","title":"","isVisible":true,"isDeletable":true,"isSearchable":true,"isExportable":true,"ormtype":"string","aggregate":{"aggregateFunction":"COUNT","aggregateAlias":"childContentsCount"}},
                    {
                        propertyIdentifier:'_content.contentID',
                        isVisible:false,
                        ormtype:'id',
                        isSearchable:true
                    },
                    {
                            propertyIdentifier: '_content.urlTitlePath',
                            isVisible: false,
                            isSearchable: true
                    },
                    //need to get template via settings
                    {
                        propertyIdentifier:'_content.allowPurchaseFlag',
                        isVisible:true,
                        ormtype:'boolean',
                        isSearchable:false
                    },
                    {
                        propertyIdentifier:'_content.productListingPageFlag',
                        isVisible:true,
                        ormtype:'boolean',
                        isSearchable:false
                    },
                    {
                        propertyIdentifier:'_content.activeFlag',
                        isVisible:true,
                        ormtype:'boolean',
                        isSearchable:false
                    }
                ];



                var options:any = {
                    currentPage:'1',
                    pageShow:'1',
                    keywords:this.keywords
                };
                var column:any = {};
                if(!isSearching || this.keywords === ''){
                    this.isSearching = false;
                    var filterGroupsConfig:any[] =[
                        {
                            "filterGroup": [
                            {
                                "propertyIdentifier": "parentContent",
                                "comparisonOperator": "is",
                                "value": 'null'
                            }
                            ]
                        }
                        ];
                    column = {
                        propertyIdentifier:'_content.title',
                        isVisible:true,
                        ormtype:'string',
                        isSearchable:true,
                        tdclass:'primary'
                    };
                    columnsConfig.unshift(column);
                }else{
                    this.collectionConfig.setKeywords(this.keywords);
                    this.isSearching = true;
                    var filterGroupsConfig:any[] =[
                        {
                            "filterGroup": [
                            {
                                "propertyIdentifier": "excludeFromSearch",
                                "comparisonOperator": "!=",
                                "value": true
                            }
                            ]
                        }
                        ];
                    column = {
                        propertyIdentifier:'_content.title',
                        isVisible:false,
                        ormtype:'string',
                        isSearchable:true
                    };
                    columnsConfig.unshift(column);

                    var titlePathColumn = {
                        propertyIdentifier:'_content.titlePath',
                        isVisible:true,
                        ormtype:'string',
                        isSearchable:false
                    };
                    columnsConfig.unshift(titlePathColumn);
                }
                //if we have a selected Site add the filter
                if(this.selectedSite && this.selectedSite.siteID){
                    var selectedSiteFilter = {
                        logicalOperator:"AND",
                        propertyIdentifier:"site.siteID",
                        comparisonOperator:"=",
                        value:this.selectedSite.siteID
                    };
                    filterGroupsConfig[0].filterGroup.push(selectedSiteFilter);
                }

                if(angular.isDefined(this.orderBy)){
                    var orderByConfig = [];
                    orderByConfig.push(this.orderBy);
                    options.orderByConfig = angular.toJson(orderByConfig);
                }

                angular.forEach(columnsConfig,(column:any)=>{
                    this.collectionConfig.addColumn(column.propertyIdentifier,column.title,column);
                });
                this.collectionConfig.addDisplayAggregate('childContents','COUNT','childContentsCount',{isVisible:false,isSearchable:false,title:'test'});
                this.collectionConfig.addDisplayProperty(
                    'site.siteID',
                    undefined,
                    {
                        isVisible:false,
                        ormtype:'id',
                        isSearchable:false
                    }
                );
                this.collectionConfig.addDisplayProperty(
                    'site.domainNames',
                    undefined,
                    {
                        isVisible: false,
                        isSearchable: true
                    }
                );

                angular.forEach(filterGroupsConfig[0].filterGroup,(filter:any)=>{

                    this.collectionConfig.addFilter(filter.propertyIdentifier,filter.value,filter.comparisonOperator,filter.logicalOperator);
                });



                this.collectionListingPromise = this.collectionConfig.getEntity();
                this.collectionListingPromise.then((value)=>{
                    this.$timeout(()=>{
                        this.collection = value;
                        this.collection.collectionConfig = this.collectionConfig;

                        this.firstLoad = true;
                        this.loadingCollection = false;
                    });
                });
                return this.collectionListingPromise;
            };
            //this.getCollection(false);

            this.loadingCollection = false;

            this.searchCollection = ()=>{


               $log.debug('search with keywords');
               $log.debug(this.keywords);
               $('.childNode').remove();
               //Set current page here so that the pagination does not break when getting collection
               this.loadingCollection = true;
               var promise = this.getCollection(true);
               promise.then(()=>{
                   this.collection.collectionConfig = this.collectionConfig;
                   this.loadingCollection = false;
               });
            };


        var siteChanged = (selectedSiteOption)=>{

            this.localStorageService.setItem('selectedSiteOption',selectedSiteOption);
            this.selectedSite = this.localStorageService.getItem('selectedSiteOption');
            this.openRoot = true;
            this.getCollection();
        }

        this.observerService.attach(siteChanged,'optionsChanged','siteOptions');

        var sortChanged = (orderBy)=>{
            this.orderBy = orderBy;
            this.getCollection();
        };
        this.observerService.attach(sortChanged,'sortByColumn','siteSorting');

        var optionsLoaded = ()=>{
            var option;
            if(this.selectedSite){
                option = this.selectedSite;
            }
            this.observerService.notify('selectOption',option);

        }

        this.observerService.attach(optionsLoaded,'optionsLoaded','siteOptionsLoaded');


    }
}
class SWContentList implements ng.IDirective{

    public restrict:string = 'E';

    //public bindToController=true;
    public controller=SWContentListController;
    public controllerAs="swContentList";
    public templateUrl;
    public partialsPath;
    public observerService;

    public static Factory(){
        var directive = (
            contentPartialsPath,
            observerService,
            slatwallPathBuilder
        )=> new SWContentList(
            contentPartialsPath,
            observerService,
            slatwallPathBuilder
        );
        directive.$inject = [
            'contentPartialsPath',
            'observerService',
            'slatwallPathBuilder'
        ];
        return directive;
    }
    //@ngInject
    constructor(
            contentPartialsPath,
            observerService,
            slatwallPathBuilder
    ){

        this.observerService = observerService;
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(contentPartialsPath)+'contentlist.html';
    }

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes,controller, transclude) =>{
        scope.$on('$destroy', function handler() {
            this.observerService.detachByEvent('optionsChanged');
            this.observerService.detachByEvent('sortByColumn');
        });
    }
}
export{
    SWContentList
}
