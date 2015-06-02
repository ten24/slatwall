'use strict';
angular.module('slatwalladmin').factory('metadataService', [
    '$filter',
    '$log',
    function ($filter, $log) {
        var _propertiesList = {};
        var _orderBy = $filter('orderBy');
        var metadataService = {
            getPropertiesList: function () {
                return _propertiesList;
            },
            getPropertiesListByBaseEntityAlias: function (baseEntityAlias) {
                return _propertiesList[baseEntityAlias];
            },
            setPropertiesList: function (value, key) {
                _propertiesList[key] = value;
            },
            formatPropertiesList: function (propertiesList, propertyIdentifier) {
                var simpleGroup = {
                    $$group: 'simple',
                };
                propertiesList.data.push(simpleGroup);
                var drillDownGroup = {
                    $$group: 'drilldown',
                };
                propertiesList.data.push(drillDownGroup);
                var compareCollections = {
                    $$group: 'compareCollections',
                };
                propertiesList.data.push(compareCollections);
                var attributeCollections = {
                    $$group: 'attribute',
                };
                propertiesList.data.push(attributeCollections);
                for (var i in propertiesList.data) {
                    if (angular.isDefined(propertiesList.data[i].ormtype)) {
                        if (angular.isDefined(propertiesList.data[i].attributeID)) {
                            propertiesList.data[i].$$group = 'attribute';
                        }
                        else {
                            propertiesList.data[i].$$group = 'simple';
                        }
                    }
                    if (angular.isDefined(propertiesList.data[i].fieldtype)) {
                        if (propertiesList.data[i].fieldtype === 'id') {
                            propertiesList.data[i].$$group = 'simple';
                        }
                        if (propertiesList.data[i].fieldtype === 'many-to-one') {
                            propertiesList.data[i].$$group = 'drilldown';
                        }
                        if (propertiesList.data[i].fieldtype === 'many-to-many' || propertiesList.data[i].fieldtype === 'one-to-many') {
                            propertiesList.data[i].$$group = 'compareCollections';
                        }
                    }
                    propertiesList.data[i].propertyIdentifier = propertyIdentifier + '.' + propertiesList.data[i].name;
                }
                //propertiesList.data = _orderBy(propertiesList.data,['displayPropertyIdentifier'],false);
                //--------------------------------Removes empty lines from dropdown.
                var temp = [];
                for (var i = 0; i <= propertiesList.data.length - 1; i++) {
                    if (propertiesList.data[i].propertyIdentifier.indexOf(".undefined") != -1) {
                        $log.debug("removing: " + propertiesList.data[i].displayPropertyIdentifier);
                        propertiesList.data[i].displayPropertyIdentifier = "hide";
                    }
                    else {
                        temp.push(propertiesList.data[i]);
                        $log.debug(propertiesList.data[i]);
                    }
                }
                temp.sort;
                propertiesList.data = temp;
                $log.debug("----------------------PropertyList\n\n\n\n\n");
                propertiesList.data = _orderBy(propertiesList.data, ['propertyIdentifier'], false);
                //--------------------------------End remove empty lines.
            },
            orderBy: function (propertiesList, predicate, reverse) {
                return _orderBy(propertiesList, predicate, reverse);
            }
        };
        return metadataService;
    }
]);

//# sourceMappingURL=../services/metadataservice.js.map