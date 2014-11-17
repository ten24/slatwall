'use strict';
angular.module('slatwalladmin').controller('create-bundle-controller', [
	'$scope',
	'$location',
	'$log',
	'$rootScope',
	'$slatwall',
	'dialogService',
	'alertService',
	'productBundleService',
	'formService',
	function(
		$scope,
		$location,
		$log,
		$rootScope,
		$slatwall,
		dialogService,
		alertService,
		productBundleService,
		formService
	){
		$scope.$id="create-bundle-controller";
		//if this view is part of the dialog section, call the inherited function
		if(angular.isDefined($scope.scrollToTopOfDialog)){
			$scope.scrollToTopOfDialog();
		}
		
		var productID = $location.search().productID;
		
		$scope.propertyDisplayData = {};
		
		$scope.getPropertyDisplayData = function(){
			var propertyDisplayDataPromise = $slatwall.getPropertyDisplayData('product',
					{propertyIdentifiersList:'productCode,productName,defaultSku.price,brand,productType'}
			);
			propertyDisplayDataPromise.then(function(value){
				$scope.propertyDisplayData = value.data;
				$log.debug('getting property Display meta data');
				$log.debug($scope.propertyDisplayData);
				$scope.product = {
					productID:"",
					productName:"",
					productCode:"",
					defaultSku:{
						skuID:"",
						price:"0",
						productBundleGroups:[]
					},
					brand:{
						brandID:""
					},
					productType:{
						typeID:""
					}
				};
			});
		};
		$scope.getPropertyDisplayData();
		
		if(angular.isDefined(productID)){
			var filterGroupsConfig = '[{"filterGroup":[{"propertyIdentifier":"_productBundleGroup.productBundleSku.product.productID","comparisonOperator":"=","value":"'+productID+'"}]}]';
			
			var productBundleGroupsOptions = {
					context:'edit',
					filterGroupsConfig:filterGroupsConfig.trim()
			};
			
			var productBundleGroupPromise = $slatwall.getEntity(
				'ProductBundleGroup',
				productBundleGroupsOptions
			);
			
			productBundleGroupPromise.then(function(value){
				$log.debug('getProductBundleGroups');
				$scope.product.defaultSku.productBundleGroups = value.pageRecords;
				$log.debug($scope.product.defaultSku.productBundleGroups);
				for(var i in $scope.product.defaultSku.productBundleGroups){
					$scope.product.defaultSku.productBundleGroups[i] = productBundleService.formatProductBundleGroup($scope.product.defaultSku.productBundleGroups[i]);
					$scope.product.defaultSku.productBundleGroups[i].$$editing = false;
					var productBundleGroupTypeOptions = {
						propertyIdentifiersList:'ProductBundleGroup.productBundleGroupType',
						id:$scope.product.defaultSku.productBundleGroups[i].productBundleGroupID
					};
					
					var skuFilterGroups = angular.fromJson($scope.product.defaultSku.productBundleGroups[i].skuCollectionConfig).filterGroups[0].filterGroup;
					var productBundleGroupFilters = [];
					for(var k in skuFilterGroups){
						var filter = {};
						if(skuFilterGroups[k].type && skuFilterGroups[k].name){
							filter = {
									type:skuFilterGroups[k].type,
									name:skuFilterGroups[k].name,
									comparisonOperator:skuFilterGroups[k].comparisonOperator
							};
						}
						
						productBundleGroupFilters.push(filter);
					}
					
					var productBundleGroupTypePromise = $slatwall.getEntity(
						'productBundleGroup',
						productBundleGroupTypeOptions
					);
					
					productBundleGroupTypePromise.then(function(value){
						$scope.product.defaultSku.productBundleGroups[i].productBundleGroupType = value.productBundleGroupType[0];
					});
					$scope.product.defaultSku.productBundleGroups[i].productBundleGroupFilters = productBundleGroupFilters;
					
				}
			});
		}
		
		$scope.setForm = function(form){
			formService.setForm(form);
		};
		
		$scope.addProductBundleGroup = function(){
			$log.debug('add bundle group');
			var productBundleGroup = productBundleService.newProductBundle();
			$scope.product.defaultSku.productBundleGroups.push(productBundleGroup);
			$log.debug($scope.product.defaultSku.productBundleGroups);
		};
		
		$scope.transformProductBundleGroupFilters = function(){
			
			for(var i in $scope.product.defaultSku.productBundleGroups){
				if(angular.isUndefined($scope.product.defaultSku.productBundleGroups[i].skuCollectionConfig)){
					$scope.product.defaultSku.productBundleGroups[i].skuCollectionConfig.filterGroups = [];
				}else{
					$scope.product.defaultSku.productBundleGroups[i].skuCollectionConfig = angular.fromJson($scope.product.defaultSku.productBundleGroups[i].skuCollectionConfig);
				}
				
				var productBundleGroupFilters = $scope.product.defaultSku.productBundleGroups[i].productBundleGroupFilters;
				var filterGroup = {};
				filterGroup['filterGroup'] = [];
				var filterCount = 0;
				for(var j in productBundleGroupFilters){
					$log.debug('productBundleGroupFilters[j]');
					$log.debug(productBundleGroupFilters[j]);
					var filter = {}; 
					switch(productBundleGroupFilters[j].type){
						case "productType":
							filter['propertyIdentifier'] = "Sku.product.productType.productTypeID";
							filter['value'] = productBundleGroupFilters[j].productTypeID;
							break;
						case "collection":
							break;
						case "brand":
							filter['propertyIdentifier'] = "Sku.product.brand.brandID";
							filter['value'] = productBundleGroupFilters[j].brandID;
							break;
						case "product":
							filter['propertyIdentifier'] = "Sku.product.productID";
							filter['value'] = productBundleGroupFilters[j].productID;
							break;
						case "sku":
							filter['propertyIdentifier'] = "Sku.skuID";
							filter['value'] = productBundleGroupFilters[j].skuID;
							break;
					}
					filter['comparisonOperator'] = productBundleGroupFilters[j].comparisonOperator;
					filter['type'] = productBundleGroupFilters[j].type;
					filter['name'] = productBundleGroupFilters[j].name;
					if(filterCount > 0){
						filter['logicalOperator'] = 'OR';
					}
					filterGroup['filterGroup'].push(filter);
					filterCount++;
					$log.debug('filterGroup');
					$log.debug(filterGroup);
				}
				$scope.product.defaultSku.productBundleGroups[i].skuCollectionConfig.filterGroups.push(filterGroup);
			}
		};
		
		$scope.saveProductBundle = function(closeDialogIndex){
			var createProductBundleForm = formService.getForm('form.createProductBundle');
			//only save the form if it passes validation
			createProductBundleForm.$submitted = true;
			if(createProductBundleForm.$valid === true){
				//custom validation for product BundleGroups
				if(isProductBundleGroupsValid()){
					$scope.transformProductBundleGroupFilters();
					var params = {
						
					};
					var context;
					if(angular.isUndefined(productID)){
						params["productID"]=$scope.product.productID;
						params["product.skus[1].skuID"]='';
						params["product.skus[1].price"]=createProductBundleForm["price"].$modelValue;
						params["product.productType.productTypeID"]=createProductBundleForm["productType"].$modelValue.value;
						params["product.productName"]=createProductBundleForm['productName'].$modelValue;
						params["product.productCode"]=createProductBundleForm['productCode'].$modelValue;
						params["product.brand.brandID"]=createProductBundleForm['brand'].$modelValue.value;
						context = 'CreateBundle';
					}else{
						context = "Save";
					}
					
					for(var i=0; i < $scope.product.defaultSku.productBundleGroups.length; i++){
						var productBundleGroup = $scope.product.defaultSku.productBundleGroups[i];
						var productBundleString;
						if(angular.isUndefined(productID)){
							productBundleString = 'product.Skus[1].productBundleGroups['+(i+1)+']';
						}else{
							
						}
						for(var key in productBundleGroup){
							if(!angular.isArray(productBundleGroup[key]) && key.charAt(0) !== '$'){
								if(!angular.isObject(productBundleGroup[key])){
									params[productBundleString+'.'+key] = productBundleGroup[key];
								}else{
									if(angular.isDefined(productBundleGroup[key].value)){
										params[productBundleString+'.'+key] = productBundleGroup[key].value;
									}
								}
							}
						}
						params[productBundleString+'.productBundleGroupID'] = productBundleGroup.productBundleGroupID;
						params[productBundleString+'.skuCollectionConfig'] = angular.toJson(productBundleGroup.skuCollectionConfig);
						params[productBundleString+'.productBundleGroupType.typeID'] = productBundleGroup.productBundleGroupType.typeID;
					}
					$log.debug(params);
					var saveProductBundlePromise = $slatwall.saveEntity('Product', null, params,context);
					saveProductBundlePromise.then(function(value){
						$log.debug('saving Product Bundle');
						if(angular.isDefined(closeDialogIndex)){
							$rootScope.closePageDialog(closeDialogIndex);
						}
						
						formService.resetForm(createProductBundleForm);
						
					});
				}
			}
		};
		
		var isProductBundleGroupsValid = function(){
			var isValid = true;
			if(!$scope.product.defaultSku.productBundleGroups.length){
				$log.debug('hasnogroup');
				var alert = {
						dismissable: false,
						msg: $.slatwall.rbKey('validate.define.bundleGroupRequired'),
						type: "error",
						};

				alertService.addAlert(alert);
				isValid = false;
			}else{
				//validate each productBundleGroup
				for(var i in $scope.product.defaultSku.productBundleGroups){
					var productBundleGroup = $scope.product.defaultSku.productBundleGroups[i];
					if(angular.isUndefined(productBundleGroup.productBundleGroupType.typeID)){
						$log.debug('hasnotypeid');
						var alert = {
								dismissable: false,
								msg: $.slatwall.rbKey('validate.define.typeIDRequired'),
								type: "error",
								};

						alertService.addAlert(alert);
						isValid = false;
					}
					if(!productBundleGroup.productBundleGroupFilters.length){
						$log.debug('hasnofilters');
						var alert = {
								dismissable: false,
								msg: $.slatwall.rbKey('validate.define.filtersRequired'),
								type: "error",
								};

						alertService.addAlert(alert);
						isValid = false;
					}
				}
			}
			return isValid;
		};
	}
]);
