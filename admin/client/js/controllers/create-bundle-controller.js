'use strict';
angular.module('slatwalladmin').controller('create-bundle-controller', [
	'$scope',
	'$location',
	'$slatwall',
	'$log',
	'$rootScope',
	'dialogService',
	'productBundleService',
	'formService',
function(
	$scope,
	$location,
	$slatwall,
	$log,
	$rootScope,
	dialogService,
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
				{propertyIdentifiersList:'productCode,productName,defaultSku.price,brand'}
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
		/*var filterGroupsConfig = '[{"filterGroup":[{"propertyIdentifier":"ProductBundleGroup.productBundleSku.product.productID","comparisonOperator":"=","value":"'+productID+'"}]}]';
		
		var productBundleGroupsOptions = {
				context:'edit',
				filterGroupsConfig:filterGroupsConfig.trim()
		};
		
		$scope.processObject ={ 
			productBundleGroups:{
				value:[]
			}
		};
			
		var productBundleGroupPromise = $slatwall.getEntity(
			'ProductBundleGroup',
			productBundleGroupsOptions
		);
		
		productBundleGroupPromise.then(function(value){
			$log.debug('getProcessObject');
			$scope.processObject.productBundleGroups.value = value.pageRecords;
			for(var i in $scope.processObject.productBundleGroups.value){
				$scope.processObject.productBundleGroups.value[i] = productBundleService.formatProductBundleGroup($scope.processObject.productBundleGroups.value[i]);
				$scope.processObject.productBundleGroups.value[i].$$editing = false;
				var productBundleGroupTypeOptions = {
						propertyIdentifiersList:'ProductBundleGroup.productBundleGroupType',
						id:$scope.processObject.productBundleGroups.value[i].productBundleGroupID
				};
				
				var productBundleGroupTypePromise = $slatwall.getEntity(
					'productBundleGroup',
					productBundleGroupTypeOptions
				);
				
				productBundleGroupTypePromise.then(function(value){
					$scope.processObject.productBundleGroups.value[i].productBundleGroupType = value.productBundleGroupType[0];
				},function(reason){
					//display error message if getter fails
					var messages = reason.MESSAGES;
					var alerts = alertService.formatMessagesToAlerts(messages);
					alertService.addAlerts(alerts);
				});
			}
			$log.debug($scope.productBundleGroups);
		},function(reason){
			//display error message if getter fails
			var messages = reason.MESSAGES;
			var alerts = alertService.formatMessagesToAlerts(messages);
			alertService.addAlerts(alerts);
		});*/
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
			$scope.product.defaultSku.productBundleGroups[i].skuCollectionConfig.filterGroups = [];
			var productBundleGroupFilters = $scope.product.defaultSku.productBundleGroups[i].productBundleGroupFilters;
			var filterGroup = {};
			filterGroup['filterGroup'] = [];
			var filterCount = 0;
			for(var productBundleGroupFilter in productBundleGroupFilters){
				var filter = {}; 
				switch(productBundleGroupFilter.type){
					case "productType":
						filter['propertyIdentifier'] = "Sku.product.productType.productTypeID";
						filter['comparisonOperator'] = '=';
						filter['value'] = productBundleGroupFilter.productTypeID;
						break;
					case "collection":
						break;
					case "brand":
						filter['propertyIdentifier'] = "Sku.product.brand.brandID";
						filter['comparisonOperator'] = '=';
						filter['value'] = productBundleGroupFilter.brandID;
						break;
					case "product":
						filter['propertyIdentifier'] = "Sku.product.productID";
						filter['comparisonOperator'] = '=';
						filter['value'] = productBundleGroupFilter.productID;
						break;
					case "sku":
						filter['propertyIdentifier'] = "Sku.skuID";
						filter['comparisonOperator'] = '=';
						filter['value'] = productBundleGroupFilter.skuID;
						break;
				}
				if(filterCount > 0){
					filter['logicalOperator'] = 'OR';
				}
				filterGroup['filterGroup'].push(filter);
				//ArrayAppend(,filter);
				filterCount++;
			}
			$scope.product.defaultSku.productBundleGroups[i].skuCollectionConfig.filterGroups = filterGroup;
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
					"productID":$scope.product.productID,
					"product.Skus[1].price":createProductBundleForm["price"].$modelValue,
					//"product.productType.productTypeID":createProductBundleForm["product.productType"].$modelValue.value,
					"product.productType.productTypeID":"154dcdd2f3fd4b5ab5498e93470957b8",
					"product.productName":createProductBundleForm['productName'].$modelValue,
					"product.productCode":createProductBundleForm['productCode'].$modelValue,
					"product.brand.brandID":createProductBundleForm['brand'].$modelValue.value,
				};
				//"product.defaultSku.productBundleGroups":angular.toJson()
				for(var i=0; i < $scope.product.defaultSku.productBundleGroups.length; i++){
					var productBundleGroup = $scope.product.defaultSku.productBundleGroups[i];
					var productBundleString = 'product.Skus[1].productBundleGroups['+(i+1)+']';
					console.log('productBundleGroup');
					console.log(productBundleGroup);
					for(var key in productBundleGroup){
						if(!angular.isArray(productBundleGroup[key]) && key.charAt(0) !== '$' && !angular.isObject(productBundleGroup[key])){
							params[productBundleString+'.'+key] = productBundleGroup[key];
						}
					}
					params[productBundleString+'.productBundleGroupID'] = '';
					params[productBundleString+'.skuCollectionConfig'] = angular.toJson(productBundleGroup.skuCollectionConfig);
					params[productBundleString+'.productBundleGroupType'] = productBundleGroup.productBundleGroupType.typeID;
					
				}
				$log.debug(params);
				var saveProductBundlePromise = $slatwall.saveEntity('Product', null, params,'CreateBundle');
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
		console.log('productBundleGroups');
		console.log($scope.product.defaultSku.productBundleGroups);
		if(!$scope.product.defaultSku.productBundleGroups.length){
			$log.debug('hasnogroup');
			isValid = false;
		}else{
			//validate each productBundleGroup
			for(var i in $scope.product.defaultSku.productBundleGroups){
				var productBundleGroup = $scope.product.defaultSku.productBundleGroups[i];
				if(angular.isUndefined(productBundleGroup.productBundleGroupType.typeID)){
					$log.debug('hasnotypeid');
					isValid = false;
				}
				if(!productBundleGroup.productBundleGroupFilters.length){
					$log.debug('hasnofilters');
					isValid = false;
				}
			}
		}
		return isValid;
	};
}]);
