/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWEditFilterItem{
	public static Factory(){
		var directive = (
			$log,
			$filter,
            $timeout,
			$hibachi,
			collectionPartialsPath,
			collectionService,
			metadataService,
			hibachiPathBuilder,
            rbkeyService,
            observerService
		)=> new SWEditFilterItem(
			$log,
			$filter,
            $timeout,
			$hibachi,
			collectionPartialsPath,
			collectionService,
			metadataService,
			hibachiPathBuilder,
            rbkeyService,
            observerService
		);
		directive.$inject = [
			'$log',
			'$filter',
            '$timeout',
			'$hibachi',
			'collectionPartialsPath',
			'collectionService',
			'metadataService',
			'hibachiPathBuilder',
            'rbkeyService',
            'observerService'
		];
		return directive;
	}
	constructor(
		$log,
		$filter,
        $timeout,
		$hibachi,
		collectionPartialsPath,
		collectionService,
		metadataService,
		hibachiPathBuilder,
        rbkeyService,
        observerService
	){
		return {
			require:'^swFilterGroups',
			restrict: 'E',
			scope:{
				collectionConfig:"=",
				filterItem:"=",
				filterPropertiesList:"=",
				saveCollection:"&",
				removeFilterItem:"&",
				filterItemIndex:"=",
				comparisonType:"=",
                simple:"="
			},
			templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+"editfilteritem.html",
			link: function(scope, element,attrs,filterGroupsController){
                function daysBetween(first, second) {

                    // Copy date parts of the timestamps, discarding the time parts.
                    var one = new Date(first.getFullYear(), first.getMonth(), first.getDate());
                    var two = new Date(second.getFullYear(), second.getMonth(), second.getDate());

                    // Do the math.
                    var millisecondsPerDay = 1000 * 60 * 60 * 24;
                    var millisBetween = two.getTime() - one.getTime();
                    var days = millisBetween / millisecondsPerDay;

                    // Round down.
                    return Math.floor(days);
                }
               if(angular.isUndefined(scope.filterItem.breadCrumbs)){

                    scope.filterItem.breadCrumbs = [];
                    if(scope.filterItem.propertyIdentifier === ""){

                        scope.filterItem.breadCrumbs = [
                                                {
                                                    rbKey:rbkeyService.getRBKey('entity.'+scope.collectionConfig.baseEntityAlias.replace('_','')),
                                                    entityAlias:scope.collectionConfig.baseEntityAlias,
                                                    cfc:scope.collectionConfig.baseEntityAlias,
                                                    propertyIdentifier:scope.collectionConfig.baseEntityAlias
                                                }
                                            ];
                    }else{
                        var entityAliasArrayFromString = scope.filterItem.propertyIdentifier.split('.');
                        entityAliasArrayFromString.pop();
                        for(var i in entityAliasArrayFromString){
                            var breadCrumb = {
                                    rbKey:rbkeyService.getRBKey('entity.'+scope.collectionConfig.baseEntityAlias.replace('_','')),
                                    entityAlias:entityAliasArrayFromString[i],
                                    cfc:entityAliasArrayFromString[i],
                                    propertyIdentifier:entityAliasArrayFromString[i]
                            };
                            scope.filterItem.breadCrumbs.push(breadCrumb);
                        }
                    }
                }else{

                    angular.forEach(scope.filterItem.breadCrumbs,function(breadCrumb,key){
                        if(angular.isUndefined(scope.filterPropertiesList[breadCrumb.propertyIdentifier])){
                            var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName(breadCrumb.cfc);
                            filterPropertiesPromise.then(function(value){
                                metadataService.setPropertiesList(value,breadCrumb.propertyIdentifier);
                                scope.filterPropertiesList[breadCrumb.propertyIdentifier] = metadataService.getPropertiesListByBaseEntityAlias(breadCrumb.propertyIdentifier);
                                metadataService.formatPropertiesList(scope.filterPropertiesList[breadCrumb.propertyIdentifier],breadCrumb.propertyIdentifier);
                                var entityAliasArrayFromString = scope.filterItem.propertyIdentifier.split('.');
                                entityAliasArrayFromString.pop();

                                entityAliasArrayFromString = entityAliasArrayFromString.join('.').trim();
                                if(angular.isDefined(scope.filterPropertiesList[entityAliasArrayFromString])){
                                    for(var i in scope.filterPropertiesList[entityAliasArrayFromString].data){
                                        var filterProperty = scope.filterPropertiesList[entityAliasArrayFromString].data[i];
                                        if(filterProperty.propertyIdentifier === scope.filterItem.propertyIdentifier){
                                            //selectItem from drop down
                                            scope.selectedFilterProperty = filterProperty;
                                            //decorate with value and comparison Operator so we can use it in the Condition section
                                            scope.selectedFilterProperty.value = scope.filterItem.value;
                                            scope.selectedFilterProperty.comparisonOperator = scope.filterItem.comparisonOperator;
                                        }
                                    }
                                }
                            });
                        }else{
                            var entityAliasArrayFromString = scope.filterItem.propertyIdentifier.split('.');
                            entityAliasArrayFromString.pop();

                            entityAliasArrayFromString = entityAliasArrayFromString.join('.').trim();
                            if(angular.isDefined(scope.filterPropertiesList[entityAliasArrayFromString])){
                                for(var i in scope.filterPropertiesList[entityAliasArrayFromString].data){
                                    var filterProperty = scope.filterPropertiesList[entityAliasArrayFromString].data[i];
                                    if(filterProperty.propertyIdentifier === scope.filterItem.propertyIdentifier){
                                        //selectItem from drop down

                                        scope.selectedFilterProperty = filterProperty;
                                        //decorate with value and comparison Operator so we can use it in the Condition section
                                        scope.selectedFilterProperty.value = scope.filterItem.value;
                                        scope.selectedFilterProperty.comparisonOperator = scope.filterItem.comparisonOperator;
                                    }
                                }
                            }

                        }
                    });
                }

                if(angular.isUndefined(scope.filterItem.$$isClosed)){
                    scope.filterItem.$$isClosed = true;
                }


                scope.filterGroupItem = filterGroupsController.getFilterGroupItem();


                scope.togglePrepareForFilterGroup = function(){
                    scope.filterItem.$$prepareForFilterGroup = !scope.filterItem.$$prepareForFilterGroup;
                };

                //public functions

                scope.selectBreadCrumb = function(breadCrumbIndex){
                    //splice out array items above index
                    var removeCount = scope.filterItem.breadCrumbs.length - 1 - breadCrumbIndex;
                    scope.filterItem.breadCrumbs.splice(breadCrumbIndex + 1,removeCount);
                    $log.debug('selectBreadCrumb');
                    $log.debug(scope.selectedFilterProperty);
                    //scope.selectedFilterPropertyChanged(scope.filterItem.breadCrumbs[scope.filterItem.breadCrumbs.length -1].filterProperty);
                    scope.selectedFilterPropertyChanged(null);
                };

                scope.selectedFilterPropertyChanged = function(selectedFilterProperty){
                    $log.debug('selectedFilterProperty');
                    $log.debug(selectedFilterProperty);

                    if(angular.isDefined(scope.selectedFilterProperty) && scope.selectedFilterProperty === null){
                        scope.selectedFilterProperty = {};
                    }
                    if(angular.isDefined(scope.selectedFilterProperty) && angular.isDefined(scope.selectedFilterProperty.selectedCriteriaType)){
                        delete scope.selectedFilterProperty.selectedCriteriaType;
                    }
                    if(angular.isDefined(scope.filterItem.value)){
                        delete scope.filterItem.value;
                    }

                    scope.selectedFilterProperty.showCriteriaValue = false;
                    scope.selectedFilterProperty = selectedFilterProperty;
                };

                scope.addFilterItem = function(){
                    collectionService.newFilterItem(filterGroupsController.getFilterGroupItem(),filterGroupsController.setItemInUse);
                };

                scope.cancelFilterItem = function(){
                    $log.debug('cancelFilterItem');
                    $log.debug(scope.filterItemIndex);
                    //scope.deselectItems(scope.filterGroupItem[filterItemIndex]);
                    scope.filterItem.setItemInUse(false);
                    scope.filterItem.$$isClosed = true;
                    for(var siblingIndex in scope.filterItem.$$siblingItems){
                        scope.filterItem.$$siblingItems[siblingIndex].$$disabled = false;
                    }
                    if(scope.filterItem.$$isNew === true){
                        observerService.notify('filterItemAction', {action: 'remove',filterItemIndex:scope.filterItemIndex});
                        scope.removeFilterItem({filterItemIndex:scope.filterItemIndex});
                    }else{
                        observerService.notify('filterItemAction', {action: 'close',filterItemIndex:scope.filterItemIndex});
                    }
                };

                scope.saveFilter = function(selectedFilterProperty,filterItem,callback){
                    $log.debug('saveFilter begin');
                    if(angular.isDefined(selectedFilterProperty.selectedCriteriaType) && angular.equals({}, selectedFilterProperty.selectedCriteriaType)){
                        return;
                    }

                    if((selectedFilterProperty.propertyIdentifier.match(/_/g) || []).length > 1 ){
                        var propertyIdentifierStart = (selectedFilterProperty.propertyIdentifier.charAt(0)  == '_') ? 1 : 0;
                        var propertyIdentifierEnd = (selectedFilterProperty.propertyIdentifier.indexOf('.') == -1) ? selectedFilterProperty.propertyIdentifier.length : selectedFilterProperty.propertyIdentifier.indexOf('.');
                        var propertyIdentifierJoins = selectedFilterProperty.propertyIdentifier.substring(propertyIdentifierStart, propertyIdentifierEnd);
                        var propertyIdentifierParts = propertyIdentifierJoins.split('_');
                        var  current_collection = $hibachi.getEntityExample(scope.collectionConfig.baseEntityName);
                        var _propertyIdentifier = '';
                        var joins = [];

                        if(angular.isDefined(scope.collectionConfig.joins)){
                            joins = scope.collectionConfig.joins;
                        }

                        for(var i = 1; i < propertyIdentifierParts.length; i++){
                            if (angular.isDefined(current_collection.metaData[propertyIdentifierParts[i]]) && ('cfc' in current_collection.metaData[propertyIdentifierParts[i]])) {
                                current_collection = $hibachi.getEntityExample(current_collection.metaData[propertyIdentifierParts[i]].cfc);
                                _propertyIdentifier += '_' + propertyIdentifierParts[i];
                                var newJoin = {
                                    associationName: _propertyIdentifier.replace(/_([^_]+)$/,'.$1').substring(1),
                                    alias: '_'+propertyIdentifierParts[0]+ _propertyIdentifier
                                };
                                var joinFound = false;
                                for (var j = 0; j < joins.length; j++) {
                                    if (joins[j].alias === newJoin.alias) {
                                        joinFound = true;
                                        break;
                                    }
                                }
                                if(!joinFound){
                                    joins.push(newJoin);
                                }
                            }
                        }
                        scope.collectionConfig.joins = joins;

                        if (angular.isDefined(scope.collectionConfig.columns) && (angular.isUndefined(scope.collectionConfig.groupBys) || scope.collectionConfig.groupBys.split(',').length != scope.collectionConfig.columns.length)) {
                            var groupbyArray = angular.isUndefined(scope.collectionConfig.groupBys) ? [] : scope.collectionConfig.groupBys.split(',');
                            for (var column = 0; column < scope.collectionConfig.columns.length; column++) {
                                if (groupbyArray.indexOf(scope.collectionConfig.columns[column].propertyIdentifier) == -1) {
                                    groupbyArray.push(scope.collectionConfig.columns[column].propertyIdentifier);
                                }
                            }
                            scope.collectionConfig.groupBys = groupbyArray.join(',');
                        }


                    }

                    if(angular.isDefined(selectedFilterProperty) && angular.isDefined(selectedFilterProperty.selectedCriteriaType)){
                        //populate filterItem with selectedFilterProperty values
                        filterItem.$$isNew = false;
                        filterItem.propertyIdentifier = selectedFilterProperty.propertyIdentifier;
                        filterItem.displayPropertyIdentifier = selectedFilterProperty.displayPropertyIdentifier;

                        switch(selectedFilterProperty.ormtype){
                            case 'boolean':
                                filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
                                filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
                                filterItem.displayValue = filterItem.value;
                            break;
                            case 'string':

                                if(angular.isDefined(selectedFilterProperty.attributeID)){
                                    filterItem.attributeID = selectedFilterProperty.attributeID;
                                    filterItem.attributeSetObject = selectedFilterProperty.attributeSetObject;
                                }

                                filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;

                                //retrieving implied value or user input | ex. implied:prop is null, user input:prop = "Name"
                                if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)){
                                    filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
                                //if has a pattern then we need to evaluate where to add % for like statement
							    }else if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.pattern)){
                                    filterItem.pattern = selectedFilterProperty.selectedCriteriaType.pattern;
                                }
                                filterItem.displayValue = filterItem.value;

                                break;
                                //TODO:simplify timestamp and big decimal to leverage reusable function for null, range, and value
                            case 'timestamp':
								//retrieving implied value or user input | ex. implied:prop is null, user input:prop = "Name"
								filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
								//is it null or a range

								if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)){
									filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
									filterItem.displayValue = filterItem.value;
								}else{
									if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.dateInfo.type) && selectedFilterProperty.selectedCriteriaType.dateInfo.type === 'calculation'){
										var _daysBetween = daysBetween(new Date(selectedFilterProperty.criteriaRangeStart),new Date(selectedFilterProperty.criteriaRangeEnd));

										filterItem.value = _daysBetween;
										filterItem.displayValue = selectedFilterProperty.selectedCriteriaType.display;
										if(angular.isDefined(selectedFilterProperty.criteriaNumberOf)){
											filterItem.criteriaNumberOf = selectedFilterProperty.criteriaNumberOf;
										}

									}else if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.dateInfo.type) && selectedFilterProperty.selectedCriteriaType.dateInfo.type === 'exactDate'){
										if(angular.isUndefined(selectedFilterProperty.selectedCriteriaType.dateInfo.measureType)){
											filterItem.value = selectedFilterProperty.criteriaRangeStart + '-' + selectedFilterProperty.criteriaRangeEnd;
											filterItem.displayValue = $filter('date')(angular.copy(selectedFilterProperty.criteriaRangeStart),'MM/dd/yyyy @ h:mma') + '-' + $filter('date')(angular.copy(selectedFilterProperty.criteriaRangeEnd),'MM/dd/yyyy @ h:mma');
										}else{
											filterItem.measureType = selectedFilterProperty.selectedCriteriaType.dateInfo.measureType;
											filterItem.measureCriteria = selectedFilterProperty.selectedCriteriaType.dateInfo.type;
											filterItem.criteriaNumberOf = "0";


											if(angular.isDefined(selectedFilterProperty.criteriaNumberOf)){
												filterItem.criteriaNumberOf = selectedFilterProperty.criteriaNumberOf;
											}
											filterItem.value = filterItem.criteriaNumberOf;
											filterItem.displayValue = filterItem.criteriaNumberOf;

											switch(filterItem.measureType){
												case 'd':
													filterItem.displayValue +=' Day';
													break;
												case 'm':
													filterItem.displayValue +=' Month';
													break;
												case 'y':
													filterItem.displayValue +=' Year';
													break;
											}
											filterItem.displayValue += ((filterItem.criteriaNumberOf > 1)?'s':'')+' Ago';
										}
									}else{
										var dateValueString = selectedFilterProperty.criteriaRangeStart + '-' + selectedFilterProperty.criteriaRangeEnd;
										filterItem.value = dateValueString;
										var formattedDateValueString = $filter('date')(angular.copy(selectedFilterProperty.criteriaRangeStart),'MM/dd/yyyy @ h:mma') + '-' + $filter('date')(angular.copy(selectedFilterProperty.criteriaRangeEnd),'MM/dd/yyyy @ h:mma');
										filterItem.displayValue = formattedDateValueString;
										if(angular.isDefined(selectedFilterProperty.criteriaNumberOf)){
											filterItem.criteriaNumberOf = selectedFilterProperty.criteriaNumberOf;
										}
									}


								}

								break;
                            case 'big_decimal':
                            case 'integer':
                            case 'float':
                                filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
                                //is null, is not null
                                if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)){
                                    filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
                                }else{
                                    if(angular.isUndefined(selectedFilterProperty.selectedCriteriaType.type)){
                                        filterItem.value = selectedFilterProperty.criteriaValue;
                                    }else{
                                        var decimalValueString = selectedFilterProperty.criteriaRangeStart + '-' + selectedFilterProperty.criteriaRangeEnd;
                                        filterItem.value = decimalValueString;
                                    }
                                }
                                if(angular.isDefined(selectedFilterProperty.aggregate)){
                                    filterItem.aggregate = selectedFilterProperty.aggregate;
                                }
                                filterItem.displayValue = filterItem.value;
                                break;

                        }

                        switch(selectedFilterProperty.fieldtype){
                            case 'one-to-many':
                            case 'many-to-many':
                            case 'many-to-one':
                                filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
                                //is null, is not null
                                if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)){
                                    filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
                                }
                                filterItem.displayValue = filterItem.value;
                                break;
                            //case 'one-to-many':
                            //
                            //case 'many-to-many':
                            //    filterItem.collectionID = selectedFilterProperty.selectedCollection.collectionID;
                            //    filterItem.displayValue = selectedFilterProperty.selectedCollection.collectionName;
                            //    filterItem.criteria = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
                            //
                            //    break;
                        }

                        if(angular.isUndefined(filterItem.displayValue)){
                            filterItem.displayValue = filterItem.value;
                        }

                        if(angular.isDefined(selectedFilterProperty.ormtype)){
                            filterItem.ormtype = selectedFilterProperty.ormtype;
                        }
                        if(angular.isDefined(selectedFilterProperty.fieldtype)){
                            filterItem.fieldtype = selectedFilterProperty.fieldtype;
                        }
                        for(var siblingIndex in filterItem.$$siblingItems){
                            filterItem.$$siblingItems[siblingIndex].$$disabled = false;
                        }

                        filterItem.conditionDisplay = selectedFilterProperty.selectedCriteriaType.display;

                        //if the add to New group checkbox has been checked then we need to transplant the filter item into a filter group
                        if(filterItem.$$prepareForFilterGroup === true){
                            collectionService.transplantFilterItemIntoFilterGroup(filterGroupsController.getFilterGroupItem(),filterItem);
                        }
                        //persist Config and 
                        scope.saveCollection();

                        $log.debug(selectedFilterProperty);
                        $log.debug(filterItem);
                        observerService.notify('filterItemAction', {action: 'add',filterItemIndex:scope.filterItemIndex});
                        $timeout(function(){
                            callback();
                        });

                        $log.debug('saveFilter end');
                    }
                };
            }
		};
	}
}
export{
	SWEditFilterItem
}