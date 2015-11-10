var slatwalladmin;
(function (slatwalladmin) {
    class MetaDataService extends slatwalladmin.BaseService {
        constructor($filter, $log) {
            super();
            this.$filter = $filter;
            this.$log = $log;
            this.getPropertiesList = () => {
                return this._propertiesList;
            };
            this.getPropertiesListByBaseEntityAlias = (baseEntityAlias) => {
                return this._propertiesList[baseEntityAlias];
            };
            this.setPropertiesList = (value, key) => {
                this._propertiesList[key] = value;
            };
            this.formatPropertiesList = (propertiesList, propertyIdentifier) => {
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
                        this.$log.debug("removing: " + propertiesList.data[i].displayPropertyIdentifier);
                        propertiesList.data[i].displayPropertyIdentifier = "hide";
                    }
                    else {
                        temp.push(propertiesList.data[i]);
                        this.$log.debug(propertiesList.data[i]);
                    }
                }
                temp.sort;
                propertiesList.data = temp;
                this.$log.debug("----------------------PropertyList\n\n\n\n\n");
                propertiesList.data = this._orderBy(propertiesList.data, ['propertyIdentifier'], false);
                //--------------------------------End remove empty lines.
            };
            this.orderBy = (propertiesList, predicate, reverse) => {
                return this._orderBy(propertiesList, predicate, reverse);
            };
            this.$filter = $filter;
            this.$log = $log;
            this._propertiesList = {};
            this._orderBy = $filter('orderBy');
        }
    }
    MetaDataService.$inject = [
        '$filter',
        '$log'
    ];
    slatwalladmin.MetaDataService = MetaDataService;
    angular.module('slatwalladmin').service('metadataService', MetaDataService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=metadataservice.js.map
