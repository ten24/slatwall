/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="Slatwall.model.service.HibachiService" persistent="false" accessors="true" output="false"{
	property name="integrationCFC" type="any";
	property name="integrationService" type="any";
	property name="settingService" type="any";
	property name="resources" type="any";
	property name="customMappings" type="any";
	
	public any function init() {
		var componentFullName = getMetaData(this).fullname;
		variables.packageName = listGetAt(componentFullName,3,'.');
		
		variables.mappingFilePath = expandPath('/Slatwall')&'/integrationServices/#variables.packageName#/config/mappings/';
		variables.mappingFileName = '#variables.packageName#Mappings.json';
		variables.customMappingFilePath = expandPath('/Slatwall')&'/custom/integrationServices/#variables.packageName#/config/mappings/';
		
		setIntegrationService(arguments.integrationService);
		setSettingService(arguments.settingService);
		variables.integration = getIntegrationService().getIntegrationByIntegrationPackage(variables.packageName);
		var integrationCFC = getService('integrationService').getIntegrationCFC(integration);
		setIntegrationCFC(integrationCFC);
		
		createDataResources();
		
	}
	
	public void function createDataResources(){
		for(var customMapping in getCustomMappings()){
			var dataResource = getService('HibachiService').getDataResourceByDataResourceIndex(customMapping['remoteIndex']);
			
			if(isNull(dataResource)){
				dataResource = getService('HibachiService').newDataResource();
				dataResource.setIntegration(variables.integration);
				dataResource.setDataResourceIndex(customMapping['remoteIndex']);
				dataResource.setDataResourceType('entity');	
				getService('HibachiService').saveDataResource(dataResource);	
			}
		}		
	}
	
	private any function getIntegration(){
		if(!structKeyExists(variables,'integration')){
			variables.integration = getService('integrationService').getIntegrationByIntegrationPackage(variables.packageName);
		}
		return variables.integration;
	}
	
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		return getIntegrationCFC().setting(argumentCollection=arguments);
	}
	
	public any function getCustomMappings(){
		if(!structKeyExists(variables,'customMappings')){
		
			//insert custom properties based on existing mappings
			if(!directoryExists(variables.customMappingFilePath)){
				directoryCreate(variables.customMappingFilePath);
			}
			if(!fileExists(variables.customMappingFilePath&variables.mappingFileName)){
				fileCopy(variables.mappingFilePath&variables.mappingFileName,variables.customMappingFilePath&variables.mappingFileName);
			}
			variables.customMappings = deserializeJson(fileRead(variables.customMappingFilePath&variables.mappingFileName));
		}
		return variables.customMappings;
	}
	
	public any function push(required any entity, any data ={}){
		getIntegration().getIntegrationCFC('data').pushDataFromQueue(argumentCollection=arguments);
	}
	
	public any function getDataResourceOptions(){
		var dataResourceCollectionList = getService('HibachiCollectionService').getDataResourceCollectionList();
		dataResourceCollectionList.setDisplayProperties('dataResourceID|value,dataResourceIndex|name');
		dataResourceCollectionList.addFilter('dataResourceType','entity');
		dataResourceCollectionList.addFilter('integration.integrationID',getIntegration().getIntegrationID());
		var dataResourceOptions = dataResourceCollectionList.getRecords();
		return dataResourceOptions;
	}
	
	
}
