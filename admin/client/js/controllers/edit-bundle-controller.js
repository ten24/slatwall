'use strict';
angular.module('slatwalladmin').controller('edit-bundle-controller', [
	'$scope',
	'$location',
	'$log',
	'$rootScope',
	'$slatwall',
	'dialogService',
	'productBundleService',
	'formService',
function(
	$scope,
	$location,
	$log,
	$rootScope,
	$slatwall,
	dialogService,
	productBundleService,
	formService
){
	$scope.$id="edit-bundle-controller";
	/*used til we convert to use route params*/
	var QueryString = function () {
	  // This function is anonymous, is executed immediately and 
	  // the return value is assigned to QueryString!
	  var query_string = {};
	  var query = window.location.search.substring(1);
	  var vars = query.split("&");
	  for (var i=0;i<vars.length;i++) {
	    var pair = vars[i].split("=");
	    	// If first entry with this name
	    if (typeof query_string[pair[0]] === "undefined") {
	      query_string[pair[0]] = pair[1];
	    	// If second entry with this name
	    } else if (typeof query_string[pair[0]] === "string") {
	      var arr = [ query_string[pair[0]], pair[1] ];
	      query_string[pair[0]] = arr;
	    	// If third or later entry with this name
	    } else {
	      query_string[pair[0]].push(pair[1]);
	    }
	  } 
	    return query_string;
	} ();
	var productID = QueryString.productID;
	/*
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
	*/
	
	if(angular.isDefined(productID)){
		var filterGroupsConfig = '[{"filterGroup":[{"propertyIdentifier":"ProductBundleGroup.productBundleSku.product.productID","comparisonOperator":"=","value":"'+productID+'"}]}]';
		
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
				
				var skuFilterGroups = angular.fromJson($scope.product.defaultSku.productBundleGroups[i].skuCollectionConfig).filterGroups.filterGroup;
				var productBundleGroupFilters = [];
				for(var k in skuFilterGroups){
					var filter = {
							type:skuFilterGroups[k].type,
							name:skuFilterGroups[k].name
					};
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
						filter['comparisonOperator'] = '=';
						filter['value'] = productBundleGroupFilters[j].productTypeID;
						break;
					case "collection":
						break;
					case "brand":
						filter['propertyIdentifier'] = "Sku.product.brand.brandID";
						filter['comparisonOperator'] = '=';
						filter['value'] = productBundleGroupFilters[j].brandID;
						break;
					case "product":
						filter['propertyIdentifier'] = "Sku.product.productID";
						filter['comparisonOperator'] = '=';
						filter['value'] = productBundleGroupFilters[j].productID;
						break;
					case "sku":
						filter['propertyIdentifier'] = "Sku.skuID";
						filter['comparisonOperator'] = '=';
						filter['value'] = productBundleGroupFilters[j].skuID;
						break;
				}
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
					params["productID"] = productID;
					context = "Save";
				}
				
				//"product.defaultSku.productBundleGroups":angular.toJson()
				for(var i=0; i < $scope.product.defaultSku.productBundleGroups.length; i++){
					var productBundleGroup = $scope.product.defaultSku.productBundleGroups[i];
					var productBundleString = 'product.Skus[1].productBundleGroups['+(i+1)+']';
					for(var key in productBundleGroup){
						if(!angular.isArray(productBundleGroup[key]) && key.charAt(0) !== '$' && !angular.isObject(productBundleGroup[key])){
							params[productBundleString+'.'+key] = productBundleGroup[key];
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
	}
]);
