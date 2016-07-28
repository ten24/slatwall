/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class MetaDataService {
	private _propertiesList;
	private _orderBy;
	public static $inject = [
		'$filter',
		'$log'
	];
	//@ngInject
	constructor(
		private $filter:ng.IFilterService,
		private $log:ng.ILogService
	){

		this.$filter = $filter;
		this.$log = $log;
		this._propertiesList = {};
		this._orderBy = $filter('orderBy');
	}

	getPropertiesList = () =>{
		return this._propertiesList;
	}
	getPropertiesListByBaseEntityAlias = (baseEntityAlias:string) =>{
		return this._propertiesList[baseEntityAlias];
	}
	setPropertiesList = (value,key) =>{
		this._propertiesList[key] = value;
	}
	formatPropertiesList = (propertiesList,propertyIdentifier) =>{
		var simpleGroup = {
				$$group:'simple',
				//displayPropertyIdentifier:'-----------------'
		};

		propertiesList.data.push(simpleGroup);
		var drillDownGroup = {
				$$group:'drilldown',
				//displayPropertyIdentifier:'-----------------'
		};

		propertiesList.data.push(drillDownGroup);

		var compareCollections = {
				$$group:'compareCollections',
				//displayPropertyIdentifier:'-----------------'
		};

		propertiesList.data.push(compareCollections);

		var attributeCollections = {
				$$group:'attribute',
				//displayPropertyIdentifier:'-----------------'
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
            var divider = '_';
            if(propertiesList.data[i].$$group == 'simple' || propertiesList.data[i].$$group == 'attribute'){
                divider = '.';
            }

			propertiesList.data[i].propertyIdentifier = propertyIdentifier + divider +propertiesList.data[i].name;
		}
		//propertiesList.data = _orderBy(propertiesList.data,['displayPropertyIdentifier'],false);

		//--------------------------------Removes empty lines from dropdown.
		var temp = [];
		for (let i = 0; i <=propertiesList.data.length -1; i++){
			if (propertiesList.data[i].propertyIdentifier.indexOf(".undefined") != -1 || propertiesList.data[i].propertyIdentifier.indexOf("_undefined") != -1){
				this.$log.debug("removing: " + propertiesList.data[i].displayPropertyIdentifier);
				propertiesList.data[i].displayPropertyIdentifier = "hide";

			}else{
				temp.push(propertiesList.data[i]);
				this.$log.debug(propertiesList.data[i]);
			}
		}
		temp.sort;
		propertiesList.data = temp;
		this.$log.debug("----------------------PropertyList\n\n\n\n\n");
		propertiesList.data = this._orderBy(propertiesList.data,['propertyIdentifier'],false);


		//--------------------------------End remove empty lines.
	}

	orderBy = (propertiesList,predicate,reverse) =>{
		return this._orderBy(propertiesList,predicate,reverse);
	}
}

export{
	MetaDataService
}