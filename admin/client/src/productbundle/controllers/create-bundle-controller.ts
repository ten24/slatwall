/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class CreateBundleController{
	
	public $inject=[
		'$scope',
		'$location',
		'$log',
		'$rootScope',
		'$window',
		'$hibachi',
		'dialogService',
		'alertService',
		'productBundleService',
		'formService',
		'productBundlePartials'
	];
	//@ngInject
	constructor(
		public $scope,
		public $location,
		public $log,
		public $rootScope,
		public $window,
		public $hibachi,
		public dialogService,
		public alertService,
		public productBundleService,
		public formService,
		public productBundlePartialsPath
	){
		$scope.productBundlePartialsPath = productBundlePartialsPath;
		this.productBundleService=productBundleService;
		var getParameterByName = (name) =>{
		    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
		    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
		        results = regex.exec(location.search);
		    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
		}

		$scope.$id="create-bundle-controller";
		//if this view is part of the dialog section, call the inherited function
		if(angular.isDefined($scope.scrollToTopOfDialog)){
			$scope.scrollToTopOfDialog();

		}

		var productID = getParameterByName('productID');

		var productBundleConstructor = () =>{

			$log.debug($scope);

			if(angular.isDefined($scope.product)){

				for(var form in $scope.product.forms){
					formService.resetForm($scope.product.forms[form]);
				}

				if(angular.isDefined($scope.product.data.skus[0])){
					for(var form in $scope.product.data.skus[0].forms){
						formService.resetForm($scope.product.data.skus[0].forms[form]);
					}
				}

				if(angular.isDefined($scope.product.data.skus[0].data.productBundleGroups.selectedProductBundleGroup)){
					for(var form in $scope.product.data.skus[0].data.productBundleGroups.selectedProductBundleGroup.forms){
						formService.resetForm( $scope.product.data.skus[0].data.productBundleGroups.selectedProductBundleGroup.forms[form]);
					}
				}
			}

			$scope.product = $hibachi.newProduct();
			var brand = $hibachi.newBrand();
			var productType = $hibachi.newProductType();
			$scope.product.$$setBrand(brand);
			$scope.product.$$setProductType(productType);
			$scope.product.$$addSku();
			$scope.product.data.skus[0].data.productBundleGroups = [];
		};

		$scope.productBundleGroup;

		if(angular.isDefined(productID) && productID !== ''){
			var productPromise = $hibachi.getProduct({id:productID});

			productPromise.promise.then(()=>{
				$log.debug(productPromise.value);
				productPromise.value.$$getSkus().then(()=>{
					productPromise.value.data.skus[0].$$getProductBundleGroups().then(()=>{

						$scope.product = productPromise.value;
						angular.forEach($scope.product.data.skus[0].data.productBundleGroups,(productBundleGroup)=>{
							productBundleGroup.$$getProductBundleGroupType();
							this.productBundleService.decorateProductBundleGroup(productBundleGroup);
							productBundleGroup.data.$$editing = false;
						});
					});
				});
			}, productBundleConstructor());

		} else {
			productBundleConstructor();
		}
	}
}
export{
	CreateBundleController
}