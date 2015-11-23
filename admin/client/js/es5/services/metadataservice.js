var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var slatwalladmin;
(function (slatwalladmin) {
    var MetaDataService = (function (_super) {
        __extends(MetaDataService, _super);
        function MetaDataService($filter, $log) {
            var _this = this;
            _super.call(this);
            this.$filter = $filter;
            this.$log = $log;
            this.getPropertiesList = function () {
                return _this._propertiesList;
            };
            this.getPropertiesListByBaseEntityAlias = function (baseEntityAlias) {
                return _this._propertiesList[baseEntityAlias];
            };
            this.setPropertiesList = function (value, key) {
                _this._propertiesList[key] = value;
            };
            this.formatPropertiesList = function (propertiesList, propertyIdentifier) {
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
                        _this.$log.debug("removing: " + propertiesList.data[i].displayPropertyIdentifier);
                        propertiesList.data[i].displayPropertyIdentifier = "hide";
                    }
                    else {
                        temp.push(propertiesList.data[i]);
                        _this.$log.debug(propertiesList.data[i]);
                    }
                }
                temp.sort;
                propertiesList.data = temp;
                _this.$log.debug("----------------------PropertyList\n\n\n\n\n");
                propertiesList.data = _this._orderBy(propertiesList.data, ['propertyIdentifier'], false);
                //--------------------------------End remove empty lines.
            };
            this.orderBy = function (propertiesList, predicate, reverse) {
                return _this._orderBy(propertiesList, predicate, reverse);
            };
            this.$filter = $filter;
            this.$log = $log;
            this._propertiesList = {};
            this._orderBy = $filter('orderBy');
        }
        MetaDataService.$inject = [
            '$filter',
            '$log'
        ];
        return MetaDataService;
    })(slatwalladmin.BaseService);
    slatwalladmin.MetaDataService = MetaDataService;
    angular.module('slatwalladmin').service('metadataService', MetaDataService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/metadataservice.js.map