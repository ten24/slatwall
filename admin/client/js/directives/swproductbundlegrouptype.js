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
				if(angular.isUndefined($scope.productBundleGroup.data.productBundleGroupType)){
					var productBundleGroupType = $slatwall.newType();
					var parentType = $slatwall.newType();
					parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
					productBundleGroupType.$$setParentType(parentType);
					$scope.productBundleGroup.$$setProductBundleGroupType(productBundleGroupType);
				}

				$scope.productBundleGroupTypes.setAdding = function(isAdding){
					$scope.productBundleGroupTypes.$$adding = isAdding;

					var productBundleGroupType = $slatwall.newType();
					var parentType = $slatwall.newType();
					parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
					productBundleGroupType.$$setParentType(parentType);
					productBundleGroupType.data.typeName=$scope.productBundleGroup.data.productBundleGroupType.data.typeName;

					productBundleGroupType.data.typeDescription = '';
					productBundleGroupType.data.typeNameCode='';
					angular.extend($scope.productBundleGroup.data.productBundleGroupType,productBundleGroupType);

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
							if($scope.productBundleGroupTypes.value[i].typeCode === $scope.productBundleGroup.data.productBundleGroupType.data.typeCode){
								$scope.showAddProductBundleGroupTypeBtn = false;
							}
						}
						return $scope.productBundleGroupTypes.value;
					});
				};
				
				$scope.selectProductBundleGroupType = function ($item, $model, $label) {
				    $scope.$item = $item;
				    $scope.$model = $model;
				    $scope.$label = $label;
				 
					angular.extend($scope.productBundleGroup.data.productBundleGroupType.data,$item);
					var parentType = $slatwall.newType();
					parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
					$scope.productBundleGroup.data.productBundleGroupType.$$setParentType(parentType);
				    
				    $scope.showAddProductBundleGroupTypeBtn = false;
				};
				
				//Closes product bundle group type adding dialog
				$scope.closeAddScreen = function(){
					$scope.productBundleGroupTypes.$$adding = false;
					$scope.showAddProductBundleGroupTypeBtn = false;
				};
				
				$scope.clearTypeName = function(){
					$scope.productBundleGroup.data.productBundleGroupType.data.typeName = '';
				}
				
				//Saves product bundle group type
				$scope.saveProductBundleGroupType = function(){
					//Gets the promise from save
					var promise = $scope.productBundleGroup.data.productBundleGroupType.$$save();
					promise.then(function(response){
						//Calls close function
						$scope.closeAddScreen();
					});

				};
				
				//Sets up clickOutside Directive call back arguments
				$scope.clickOutsideArgs = {
					callBackActions : [$scope.closeAddScreen,$scope.clearTypeName]
				};
				
				//Works with swclickoutside directive to close dialog
				$scope.closeThis = function (clickOutsideArgs) {
					//Check against the object state
					if(!$scope.productBundleGroup.data.productBundleGroupType.$$isPersisted()){
						//Perform all callback actions
				        for(var callBackAction in clickOutsideArgs.callBackActions){
				        	clickOutsideArgs.callBackActions[callBackAction]();
				        }
					}
				};
			}
		};
	}
]);
	
