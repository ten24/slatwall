/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDisplayOptions{
    public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $log,
            $hibachi,
            hibachiPathBuilder,
            collectionPartialsPath,
            rbkeyService

        ) => new SWDisplayOptions(
            $log,
            $hibachi,
            hibachiPathBuilder,
            collectionPartialsPath,
            rbkeyService
        );
        directive.$inject = [
            '$log',
            '$hibachi',
            'hibachiPathBuilder',
            'collectionPartialsPath',
            'rbkeyService'
        ];
        return directive;
    }

    //@ngInject
    constructor(
        $log,
        $hibachi,
        hibachiPathBuilder,
        collectionPartialsPath,
        rbkeyService
    ){

        return{
            restrict: 'E',
            transclude:true,
            scope:{
                orderBy:"=",
                columns:'=',
                joins:"=",
                groupBys:"=",
                propertiesList:"=",
                saveCollection:"&",
                baseEntityAlias:"=?",
                baseEntityName:"=?"
            },
            templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+"displayoptions.html",
            controller: ['$scope','$element','$attrs',function($scope,$element,$attrs){
                $log.debug('display options initialize');

                $scope.breadCrumbs = [ {
                    entityAlias : $scope.baseEntityAlias,
                    cfc : $scope.baseEntityAlias,
                    propertyIdentifier : $scope.baseEntityAlias
                } ];

                this.removeColumn = function(columnIndex){
                    $log.debug('parent remove column');
                    $log.debug($scope.columns);
                    if($scope.columns.length){
                        $scope.columns.splice(columnIndex, 1);
                    }

                };

                this.getPropertiesList = function(){
                    return $scope.propertiesList;
                };

                $scope.addDisplayDialog = {
                    isOpen:false,
                    toggleDisplayDialog:function(){
                        $scope.addDisplayDialog.isOpen = !$scope.addDisplayDialog.isOpen;
                    }
                };


                var getTitleFromProperty = function(selectedProperty){
                    var baseEntityCfcName = $scope.baseEntityName.replace('Slatwall','').charAt(0).toLowerCase()+$scope.baseEntityName.replace('Slatwall','').slice(1);
                    var propertyIdentifier = selectedProperty.propertyIdentifier;
                    var title = '';
                    var propertyIdentifierArray = propertyIdentifier.replace(/^_/,'').split(/[._]+/);
                    var currentEntity;
                    var currentEntityInstance;
                    var prefix = 'entity.';

                    if(selectedProperty.$$group == "attribute"){
                        return selectedProperty.displayPropertyIdentifier;
                    }

                    angular.forEach(propertyIdentifierArray,function(propertyIdentifierItem,key:number){
                        //pass over the initial item
                        if(key !== 0 ){
                            if(key === 1){
                                currentEntityInstance = $hibachi['new'+$scope.baseEntityName.replace('Slatwall','')]();
                                currentEntity = currentEntityInstance.metaData[propertyIdentifierArray[key]];
                                title += rbkeyService.getRBKey(prefix+baseEntityCfcName+'.'+propertyIdentifierItem);
                            }else{
                                var currentEntityInstance = $hibachi['new'+currentEntity.cfc.charAt(0).toUpperCase()+currentEntity.cfc.slice(1)]();
                                currentEntity = currentEntityInstance.metaData[propertyIdentifierArray[key]];
                                title += rbkeyService.getRBKey(prefix+currentEntityInstance.metaData.className+'.'+currentEntity.name);
                            }
                            if(key < propertyIdentifierArray.length-1){
                                title += ' | ';
                            }
                        }
                    });


                    return title;
                };

                $scope.addColumn = function(closeDialog){
                    var selectedProperty = $scope.selectedProperty;
                    if(angular.isDefined($scope.selectedAggregate)){
                        selectedProperty = $scope.selectedAggregate;
                    }



                    if(selectedProperty.$$group === 'simple' || 'attribute' || 'compareCollections'){
                        $log.debug($scope.columns);
                        if(angular.isDefined(selectedProperty)){
                            var column:any = {
                                title : getTitleFromProperty(selectedProperty),
                                propertyIdentifier : selectedProperty.propertyIdentifier,
                                isVisible : true,
                                isDeletable : true,
                                isSearchable : true,
                                isExportable : true
                            };
                            //only add attributeid if the selectedProperty is attributeid
                            if(angular.isDefined(selectedProperty.attributeID)){
                                column['attributeID'] = selectedProperty.attributeID;
                                column['attributeSetObject'] = selectedProperty.attributeSetObject;
                            }
                            if(angular.isDefined(selectedProperty.ormtype)){
                                column['ormtype'] = selectedProperty.ormtype;
                            }
                            if(selectedProperty.hb_formattype){
                                column['type'] = selectedProperty.hb_formattype;
                            }else{
                                column['type'] = 'none';
                            }
                            if(angular.isDefined(selectedProperty.aggregate)){
                                column['ormtype'] = 'string';
                                column['aggregate']={
                                    aggregateFunction : selectedProperty.aggregate.toUpperCase(),
                                    aggregateAlias : selectedProperty.propertyIdentifier.split(/[._]+/).pop()+selectedProperty.aggregate.charAt(0).toUpperCase() + selectedProperty.aggregate.slice(1)
                                };
                                column['title'] +=  ' '+ rbkeyService.getRBKey('define.'+column['aggregate']['aggregateFunction']);
                            }
                            $scope.columns.push(column);

                            if ((selectedProperty.propertyIdentifier.match(/_/g) || []).length > 1) {
                                var PIlimit = selectedProperty.propertyIdentifier.length;
                                if (selectedProperty.propertyIdentifier.indexOf('.') != -1) {
                                    PIlimit = selectedProperty.propertyIdentifier.indexOf('.');
                                }
                                var propertyIdentifierJoins = selectedProperty.propertyIdentifier.substring(1, PIlimit);
                                var propertyIdentifierParts = propertyIdentifierJoins.split('_');


                                var  current_collection = $hibachi.getEntityExample($scope.baseEntityName);
                                var _propertyIdentifier = '';
                                var joins = [];

                                if (angular.isDefined($scope.joins)) {
                                    joins = $scope.joins;
                                }

                                for (var i = 1; i < propertyIdentifierParts.length; i++) {
                                    if (angular.isDefined(current_collection.metaData[propertyIdentifierParts[i]]) && ('cfc' in current_collection.metaData[propertyIdentifierParts[i]])) {
                                        current_collection = $hibachi.getEntityExample(current_collection.metaData[propertyIdentifierParts[i]].cfc);
                                        _propertyIdentifier += '_' + propertyIdentifierParts[i];
                                        var newJoin = {
                                            associationName: _propertyIdentifier.replace(/_([^_]+)$/, '.$1').substring(1),
                                            alias: '_' + propertyIdentifierParts[0] + _propertyIdentifier
                                        };
                                        var joinFound = false;
                                        for (var j = 0; j < joins.length; j++) {
                                            if (joins[j].alias === newJoin.alias) {
                                                joinFound = true;
                                                break;
                                            }
                                        }
                                        if (!joinFound) {
                                            joins.push(newJoin);
                                        }
                                    }
                                }
                                $scope.joins = joins;

                                if (angular.isUndefined($scope.groupBys) || $scope.groupBys.split(',').length != $scope.columns.length) {
                                    var groupbyArray = angular.isUndefined($scope.groupBys) ? [] : $scope.groupBys.split(',');
                                    for (var col = 0; col < $scope.columns.length; col++) {
                                        if('attributeID' in $scope.columns[col]) continue;
                                        if (groupbyArray.indexOf($scope.columns[col].propertyIdentifier) == -1) {
                                            groupbyArray.push($scope.columns[col].propertyIdentifier);
                                        }
                                    }
                                    $scope.groupBys = groupbyArray.join(',');
                                }

                            }



                            $scope.saveCollection();
                            if(angular.isDefined(closeDialog) && closeDialog === true){
                                $scope.addDisplayDialog.toggleDisplayDialog();
                                $scope.selectBreadCrumb(0);
                            }
                        }
                    }
                };

                $scope.selectBreadCrumb = function(breadCrumbIndex){
                    //splice out array items above index
                    var removeCount = $scope.breadCrumbs.length - 1 - breadCrumbIndex;
                    $scope.breadCrumbs.splice(breadCrumbIndex + 1,removeCount);
                    $scope.selectedPropertyChanged(null);

                };

                var unbindBaseEntityAlias = $scope.$watch('baseEntityAlias',function(newValue,oldValue){
                    if(newValue !== oldValue){
                        $scope.breadCrumbs = [ {
                            entityAlias : $scope.baseEntityAlias,
                            cfc : $scope.baseEntityAlias,
                            propertyIdentifier : $scope.baseEntityAlias
                        } ];
                        unbindBaseEntityAlias();
                    }
                });

                $scope.selectedPropertyChanged = function(selectedProperty, aggregate?){
                    // drill down or select field?


                    if(!aggregate){
                        $scope.selectedProperty = selectedProperty;
                        $scope.selectedAggregate = undefined;
                    }else{

                        $scope.selectedAggregate = selectedProperty;
                    }

                };


                jQuery(function($) {

                    var panelList:any = angular.element($element).children('ul');
                    panelList.sortable({
                        // Only make the .panel-heading child elements support dragging.
                        // Omit this to make then entire <li>...</li> draggable.
                        handle: '.s-pannel-name',
                        update: function(event,ui) {
                            var tempColumnsArray = [];
                            $('.s-pannel-name', panelList).each(function(index, elem) {
                                var newIndex = $(elem).attr('j-column-index');
                                var columnItem = $scope.columns[newIndex];
                                tempColumnsArray.push(columnItem);
                            });
                            $scope.$apply(function () {
                                $scope.columns = tempColumnsArray;
                            });
                            $scope.saveCollection();
                        }
                    });
                });

                /*var unbindBaseEntityAlaisWatchListener = scope.$watch('baseEntityAlias',function(){
                 $("select").selectBoxIt();
                 unbindBaseEntityAlaisWatchListener();
                 });*/
            }]
        }
    }
}
export{
    SWDisplayOptions
}




