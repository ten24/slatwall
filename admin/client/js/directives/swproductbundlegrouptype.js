'use strict';
angular.module('slatwalladmin')
.directive('swProductBundleGroupType', 
['$http',
 '$log',
 '$slatwall',
 'alertService',
 'formService',
'productBundlePartialsPath',
'productBundleService',
function($http,
$log,
$slatwall,
alertService,
formService,
productBundlePartialsPath,
productBundleService){
	return {
		restrict: 'A',
		templateUrl:productBundlePartialsPath+"productbundlegrouptype.html",
		scope:{
			productBundleGroup:"="
		},
		link: function(scope, element,attrs,productBundleGroupsController){
			$log.debug('productBundleGrouptype');
			$log.debug(scope.productBundleGroup);
			scope.productBundleGroupTypes = {};
			scope.$$id="productBundleGroupType";
			scope.productBundleGroupTypes.value = [];
			scope.productBundleGroupTypes.$$adding = false;
			scope.productBundleGroupTypes.setAdding = function(isAdding){
				scope.productBundleGroupTypes.$$adding = isAdding;
				var processObjectPromise = $slatwall.getProcessObject(
					'Type',
					null,
					'AddProductBundleGroupType',
					'type.type,systemCode,typeDescription,parentType.TypeID'
				);
				
				processObjectPromise.then(function(value){
					$log.debug('getProcessObject');
					scope.processObject = value.data;
					formService.setForm(scope.form.addProductBundleGroup);
					$log.debug(scope.processObject);
				},function(reason){
					//display error message if getter fails
					var messages = reason.MESSAGES;
					var alerts = alertService.formatMessagesToAlerts(messages);
					alertService.addAlerts(alerts);
				});
				
			};
			
			scope.saveProductBundleGroupType = function(){
				console.log('saveProductBundleGroupTYpe');
				console.log(scope.productBundleGroup.productBundleGroupType);
				var productBundleGroupType = productBundleService.newProductBundleGroupType(scope.productBundleGroup.productBundleGroupType);
				console.log(productBundleGroupType);
			}
			
			scope.productBundleGroupTypes.getTypesByKeyword=function(keyword){
				$log.debug('getTypesByKeyword');
				var filterGroupsConfig = '['+  
				  ' {  '+
				      '"filterGroup":[  '+
				        ' {  '+
				           ' "propertyIdentifier":"Type.parentType.systemCode",'+
				           ' "comparisonOperator":"=",'+
				           ' "value":"productBundleGroupType",'+
				           ' "ormtype":"string",'+
				           ' "conditionDisplay":"Equals"'+
				         '},'+
				         '{'+
				         	'"logicalOperator":"AND",'+
				        	' "propertyIdentifier":"Type.type",'+
				        	' "comparisonOperator":"like",'+
				        	 ' "ormtype":"string",'+
				        	' "value":"%'+keyword+'%"'+
				       '  }'+
				     ' ]'+
				  ' }'+
				']';
				var typesByKeywordPromise = $slatwall.getEntity('type', {filterGroupsConfig:filterGroupsConfig.trim()});
				typesByKeywordPromise.then(function(value){
					$log.debug('typesByKeyword');
					$log.debug(value);
					scope.productBundleGroupTypes.value = value;
					var myLength = keyword.length;
					if (myLength > 0) {
						$('.s-add-bundle-type').show();
					}else{
						$('.s-add-bundle-type').hide();
					}
					
				},function(reason){
					//display error message if getter fails
					var messages = reason.MESSAGES;
					var alerts = alertService.formatMessagesToAlerts(messages);
					alertService.addAlerts(alerts);
				});
			}
		}
	};
}]);
	
