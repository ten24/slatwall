'use strict';
angular.module('slatwalladmin')
.directive('swProductBundleGroupType', [
	'$http',
	'$log',
	'$slatwall',
	'formService',
	'productBundlePartialsPath',
	'productBundleService',
	function(
		$http,
		$log,
		$slatwall,
		formService,
		productBundlePartialsPath,
		productBundleService
	){
		return {
			restrict: 'A',
			templateUrl:productBundlePartialsPath+"productbundlegrouptype.html",
			scope:{
				productBundleGroup:"="
			},
			controller: function($scope, $element,$attrs){
				$log.debug('productBundleGrouptype');
				$log.debug($scope.productBundleGroup);
				$scope.productBundleGroupTypes = {};
				$scope.$$id="productBundleGroupType";
				$scope.productBundleGroupTypes.value = [];
				$scope.productBundleGroupTypes.$$adding = false;
				$scope.productBundleGroupType = {};

				$scope.productBundleGroupTypes.setAdding = function(isAdding){
					$scope.productBundleGroupTypes.$$adding = isAdding;

					var productBundleGroupType = $slatwall.newType();
					var parentType = $slatwall.newType();
					parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
					productBundleGroupType.$$setParentType(parentType);
					productBundleGroupType.data.typeName=$scope.productBundleGroup.data.productBundleGroupType.data.typeName;

					productBundleGroupType.data.typeDescription = '';
					productBundleGroupType.data.typeNameCode='';
					$scope.productBundleGroup.data.productBundleGroupType = productBundleGroupType;

					console.log('productBundleGroupType.data.typeName');
					console.log($scope.productBundleGroup.data.productBundleGroupType);
				};
				
				$scope.showAddProductBundleGroupTypeBtn = false;
				
				$scope.productBundleGroupTypes.getTypesByKeyword=function(keyword){
					$log.debug('getTypesByKeyword');
					var filterGroupsConfig = '['+  
					  ' {  '+
					      '"filterGroup":[  '+
					        ' {  '+
					           ' "propertyIdentifier":"_type.parentType.systemCode",'+
					           ' "comparisonOperator":"=",'+
					           ' "value":"productBundleGroupType",'+
					           ' "ormtype":"string",'+
					           ' "conditionDisplay":"Equals"'+
					         '},'+
					         '{'+
					         	'"logicalOperator":"AND",'+
					        	' "propertyIdentifier":"_type.typeName",'+
					        	' "comparisonOperator":"like",'+
					        	 ' "ormtype":"string",'+
					        	' "value":"%'+keyword+'%"'+
					       '  }'+
					     ' ]'+
					  ' }'+
					']';
					return $slatwall.getEntity('type', {filterGroupsConfig:filterGroupsConfig.trim()})
					.then(function(value){
						$log.debug('typesByKeyword');
						$log.debug(value);
						$scope.productBundleGroupTypes.value = value.pageRecords;
						var myLength = keyword.length;
						
						if (myLength > 0) {
							$scope.showAddProductBundleGroupTypeBtn = true;
							//$('.s-add-bundle-type').show();
						}else{
							$scope.showAddProductBundleGroupTypeBtn = false;
							//$('.s-add-bundle-type').hide();
						}
						
						for(var i in $scope.productBundleGroupTypes.value){
							console.log('test');
							console.log($scope.productBundleGroup);
							console.log($scope.productBundleGroupTypes);
							if($scope.productBundleGroupTypes.value[i].typeCode === $scope.productBundleGroup.data.productBundleGroupType.data.typeCode){
								$scope.showAddProductBundleGroupTypeBtn = false;
							}
						}
						return $scope.productBundleGroupTypes.value;
					});
				};
				
				$scope.selectProductBundleGroupType = function ($item, $model, $label) {
					console.log('select');
				    $scope.$item = $item;
				    $scope.$model = $model;
				    $scope.$label = $label;
				    console.log('item');
				    console.log($item);
				    console.log($model);
				    console.log($label);
				    var productBundleGroupType = $slatwall.newType();
				    angular.extend(productBundleGroupType,$item);
					var parentType = $slatwall.newType();
					parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
					productBundleGroupType.$$setParentType(parentType);
					productBundleGroupType.data.typeName=$scope.productBundleGroup.data.productBundleGroupType.data.typeName;
				    $scope.productBundleGroup.$$setProductBundleGroupType(productBundleGroupType);
				    $scope.showAddProductBundleGroupTypeBtn = false;
				};
			}
		};
	}
]);
	
