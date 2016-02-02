/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFormFieldSearchSelect{
	public static Factory(){
		var directive = (
			$http,
			$log,
			$hibachi,
			formService,
			coreFormPartialsPath,
			hibachiPathBuilder
		)=>new SWFormFieldSearchSelect(
			$http,
			$log,
			$hibachi,
			formService,
			coreFormPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$http',
			'$log',
			'$hibachi',
			'formService',
			'coreFormPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		$http,
		$log,
		$hibachi,
		formService,
		coreFormPartialsPath,
		hibachiPathBuilder
	){
		return{
			templateUrl:hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath)+'search-select.html',
			require:"^form",
			restrict: 'E',
			scope:{
				propertyDisplay:"="
			},
			link:function(scope,element,attr,formController){
				//set up selectionOptions
				scope.selectionOptions = {
					value:[],
					$$adding:false
				};
				//match in matches track by
				//function to set state of adding new item
				scope.setAdding = function(isAdding){
					scope.isAdding = isAdding;
					scope.showAddBtn = false;
				};

				scope.selectedOption = {};
				scope.showAddBtn = false;
				var propertyMetaData = scope.propertyDisplay.object.$$getMetaData(scope.propertyDisplay.property);
				//create basic
				var object = $hibachi.newEntity(propertyMetaData.cfc);

//				scope.propertyDisplay.template = '';
//				//check for a template
//				//rules are tiered: check if an override is specified at scope.template, check if the cfc name .html exists, use
//				var templatePath = coreFormPartialsPath + 'formfields/searchselecttemplates/';
//				if(angular.isUndefined(scope.propertyDisplay.template)){
//					var templatePromise = $http.get(templatePath+propertyMetaData.cfcProperCase+'.html',function(){
//						$log.debug('template');
//						scope.propertyDisplay.template = templatePath+propertyMetaData.cfcProperCase+'.html';
//					},function(){
//						scope.propertyDisplay.template = templatePath+'index.html';
//						$log.debug('template');
//						$log.debug(scope.propertyDisplay.template);
//					});
//				}

				//set up query function for finding related object
				scope.cfcProperCase = propertyMetaData.cfcProperCase;
				scope.selectionOptions.getOptionsByKeyword=function(keyword){
					var filterGroupsConfig = '['+
					' {  '+
						'"filterGroup":[  '+
							'{'+
								' "propertyIdentifier":"_'+scope.cfcProperCase.toLowerCase()+'.'+scope.cfcProperCase+'Name",'+
								' "comparisonOperator":"like",'+
								' "ormtype":"string",'+
								' "value":"%'+keyword+'%"'+
						'  }'+
						' ]'+
					' }'+
					']';
					return $hibachi.getEntity(propertyMetaData.cfc, {filterGroupsConfig:filterGroupsConfig.trim()})
					.then(function(value){
						$log.debug('typesByKeyword');
						$log.debug(value);
						scope.selectionOptions.value = value.pageRecords;

						var myLength = keyword.length;

						if (myLength > 0) {
							scope.showAddBtn = true;
						}else{
							scope.showAddBtn = false;
						}
						return scope.selectionOptions.value;
					});
				};
				var propertyPromise = scope.propertyDisplay.object['$$get'+propertyMetaData.nameCapitalCase]();
				propertyPromise.then(function(data){

				});

				//set up behavior when selecting an item
				scope.selectItem = function ($item, $model, $label) {
					scope.$item = $item;
					scope.$model = $model;
					scope.$label = $label;
					scope.showAddBtn = false; //turns off the add btn on select
					//angular.extend(inflatedObject.data,$item);
					object.$$init($item);
					$log.debug('select item');
					$log.debug(object);
					scope.propertyDisplay.object['$$set'+propertyMetaData.nameCapitalCase](object);
				};

//				if(angular.isUndefined(scope.propertyDipslay.object[scope.propertyDisplay.property])){
//					$log.debug('getmeta');
//					$log.debug(scope.propertyDisplay.object.metaData[scope.propertyDisplay.property]);
//
//					//scope.propertyDipslay.object['$$get'+]
//				}
//
//				scope.propertyDisplay.object.data[scope.propertyDisplay.property].$dirty = true;
			}
		};
	}
}
export{
	SWFormFieldSearchSelect
}

