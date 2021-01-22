/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWRelatedProductsController {

    public alreadySelectedProductsCollectionConfig:any;
    public collectionConfig:any;
    public productId:string;
    public typeaheadDataKey:string;
    public edit:boolean;
    public productSortProperty:string;
    public productSortDefaultDirection:string;

    //@ngInject
    constructor(
        private collectionConfigService,
        private utilityService
    ){
        this.collectionConfig = collectionConfigService.newCollectionConfig("Product");
        this.collectionConfig.addDisplayProperty("productID,productName,productCode,calculatedSalePrice,activeFlag,publishedFlag,productType.productTypeNamePath,productType.productTypeName,defaultSku.price");
        this.alreadySelectedProductsCollectionConfig = collectionConfigService.newCollectionConfig("ProductRelationship");
        this.alreadySelectedProductsCollectionConfig.addDisplayProperty("productRelationshipID,sortOrder,relatedProduct.productID,relatedProduct.productName,relatedProduct.productCode,relatedProduct.calculatedSalePrice,relatedProduct.activeFlag,relatedProduct.publishedFlag");
        this.alreadySelectedProductsCollectionConfig.addFilter("product.productID", this.productId, "=");
        this.typeaheadDataKey = utilityService.createID(32);
    }
}

class SWRelatedProducts implements ng.IDirective{

    public templateUrl;
    public restrict = "EA";
    public scope = {};

    public bindToController = {
        productId:"@?",
        edit:"=?",
        productSortProperty:"@?",
        productSortDefaultDirection:"@?",
        selectedRelatedProductIds:"@?"
    };

    public controller=SWRelatedProductsController;
    public controllerAs="swRelatedProducts";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $http,
            $hibachi,
            paginationService,
		    productPartialsPath,
			slatwallPathBuilder
        ) => new SWRelatedProducts(
            $http,
            $hibachi,
            paginationService,
			productPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$http',
            '$hibachi',
            'paginationService',
			'productPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }

    //@ngInject
	constructor(
		private $http,
        private $hibachi,
        private paginationService,
	    private productPartialsPath,
		private slatwallPathBuilder
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(productPartialsPath) + "/relatedproducts.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
	SWRelatedProductsController,
	SWRelatedProducts
};
