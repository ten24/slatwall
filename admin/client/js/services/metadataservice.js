'use strict';
angular.module('slatwalladmin')
.factory('metadataService',[
	'$filter',
	'$log',
	function(
		$filter,
		$log
	){
		var _propertiesList = {};
		var _orderBy = $filter('orderBy');
		
		var metadataService = {
			getPropertiesList:function(){
				return _propertiesList;
			},
			getPropertiesListByBaseEntityAlias: function(baseEntityAlias){
				return _propertiesList[baseEntityAlias];
			},
			setPropertiesList: function(value,key){
				_propertiesList[key] = value;
			},
			formatPropertiesList: function(propertiesList,propertyIdentifier){
				var simpleGroup = {
						$$group:'simple',
						displayPropertyIdentifier:'-----------------'
				};
				
				propertiesList.data.push(simpleGroup);
				var drillDownGroup = {
						$$group:'drilldown',
						displayPropertyIdentifier:'-----------------'
				};
				
				propertiesList.data.push(drillDownGroup);
				
				var compareCollections = {
						$$group:'compareCollections',
						displayPropertyIdentifier:'-----------------'
				};
				
				propertiesList.data.push(compareCollections);
				
				var attributeCollections = {
						$$group:'attribute',
						displayPropertyIdentifier:'-----------------'
				};
				
				propertiesList.data.push(attributeCollections);
				
				
				for(var i in propertiesList.data){
					if(angular.isDefined(propertiesList.data[i].ormtype)){
						if(angular.isDefined(propertiesList.data[i].attributeID)){
							propertiesList.data[i].$$group = 'attribute';
						}else{
							propertiesList.data[i].$$group = 'simple';
						}
					}
					if(angular.isDefined(propertiesList.data[i].fieldtype)){
						if(propertiesList.data[i].fieldtype === 'id'){
							propertiesList.data[i].$$group = 'simple';
						}
						if(propertiesList.data[i].fieldtype === 'many-to-one'){
							propertiesList.data[i].$$group = 'drilldown';
						}
						if(propertiesList.data[i].fieldtype === 'many-to-many' || propertiesList.data[i].fieldtype === 'one-to-many'){
							propertiesList.data[i].$$group = 'compareCollections';
						}
					}
					propertiesList.data[i].propertyIdentifier = propertyIdentifier + '.' +propertiesList.data[i].name;
				}
				propertiesList.data = _orderBy(propertiesList.data,['-$$group','propertyIdentifier'],false);
			},
			
			orderBy: function(propertiesList,predicate,reverse){
				return _orderBy(propertiesList,predicate,reverse);
			}
			
		};
		
		return metadataService;
	}
]);
