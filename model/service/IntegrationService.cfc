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
component extends="HibachiService" persistent="false" accessors="true" output="false" {

	// Place holder properties that get populated lazily
	property name="settings" type="any";
	property name="applicationKey" type="string";
	property name="applicationRootMappingPath" type="string";
	
	variables.integrationCFCs = {};
	variables.paymentIntegrationCFCs = {};
	variables.shippingIntegrationCFCs = {};
	variables.authenticationIntegrationCFCs = {};
	variables.taxIntegrationCFCs = {};
	variables.dataIntegrationCFCs = {};
	variables.jsObjectAdditions = '';
	
	public void function clearActiveFW1Subsystems() {
		structDelete(variables, "activeFW1Subsystems");
	}

	public array function getActiveFW1Subsystems() {
		if( !structKeyExists(variables, "activeFW1Subsystems") ) {
			var integrationSmartlist = this.getIntegrationSmartList();
			integrationSmartlist.addFilter('activeFlag', '1');
			integrationSmartlist.addFilter('installedFlag', '1');
			integrationSmartlist.addLikeFilter('integrationTypeList', '%fw1%');
			integrationSmartlist.addSelect('integrationName', 'name');
			integrationSmartlist.addSelect('integrationPackage', 'subsystem');
			variables.activeFW1Subsystems = integrationSmartlist.getRecords();
		}
		return variables.activeFW1Subsystems;
	}	

	public any function getAllSettingMetaData() {
		var allSettingMetaData = {};
		var dirList = directoryList( expandPath("/Slatwall") & "/integrationServices" );
		
		// Loop over each integration in the integration directory
		for(var i=1; i<= arrayLen(dirList); i++) {
			
			var fileInfo = getFileInfo(dirList[i]);
			
			if(fileInfo.type == "directory" && fileExists("#fileInfo.path#/Integration.cfc") ) {
				var integrationPackage = listLast(dirList[i],"\/");
				var integrationCFC = createObject("component", "Slatwall.integrationServices.#integrationPackage#.Integration").init();
				var integrationMeta = getMetaData(integrationCFC);
				
				if(structKeyExists(integrationMeta, "Implements") && structKeyExists(integrationMeta.implements, "Slatwall.integrationServices.IntegrationInterface")) {
					
					for(var settingName in integrationCFC.getSettings()) {
						allSettingMetaData['integration#integrationPackage##settingName#'] = integrationCFC.getSettings()[ settingName ];
					}
					
				}
			}
		}
		return allSettingMetaData;
	}
	
	public any function getIntegrationCFC(required any integration ){
        return this.getBean("#arguments.integration.getIntegrationPackage()#IntegrationCFC");
	}
	
	/**
	 * Helper function to return ['IntegrationType'].cfc Object, e.g. Data.cfc, Adress.cfc
	 * 
	 * TODO: refactor other function to use this function, 
	 * or inplement onMissingMethod for pattern get['Address']IntegrationCFC(required integration);
	 * 
	*/ 
	public any function getIntegrationTypeCFC(required any integration, required string integrationTypeName ){
        return this.getBean("#arguments.integration.getIntegrationPackage()##arguments.integrationTypeName#CFC");
	}
	
	/**
	 * Function to return an *Importer-Integration* Object for the the given *Integration*.
	 *
	 * @integration the associated *Integration-Entity* for the "Integration-Package"; ==> getIntegrationByIntegrationPackage('SlatwallImporter');
	*/ 
	public any function getImporterIntegrationCFC(required any integration) {
		return this.getIntegrationTypeCFC(arguments.integration, "Importer");
	}

	public any function getAuthenticationIntegrationCFC(required any integration) {
		return this.getIntegrationTypeCFC(arguments.integration, "Authentication");
	}

	public any function getPaymentIntegrationCFC(required any integration) {
		return this.getIntegrationTypeCFC(arguments.integration, "Payment");
	}
	
	public any function getShippingIntegrationCFC(required any integration) {
		return this.getIntegrationTypeCFC(arguments.integration, "Shipping");
	}
	
	public any function getDataIntegrationCFC(required any integration) {
		return this.getIntegrationTypeCFC(arguments.integration, "Data");
	}

	public any function getTaxIntegrationCFC(required any integration) {
		return this.getIntegrationTypeCFC(arguments.integration, "Tax");
	}
	
	public any function updateIntegrationsFromDirectory() {
		var dirList = directoryList( expandPath("/Slatwall") & '/integrationServices' );
		var installedIntegrationList = "";
		
		// Loop over each integration in the integration directory
		for(var i=1; i<= arrayLen(dirList); i++) {
			
			var installedIntegration = updateIntegrationFromDirectory(dirList[i]);
			if(len(installedIntegration)){
				installedIntegrationList = listAppend(installedIntegrationList,installedIntegration);
			}
		}
		
		// Turn off the installed and ready flags on any previously setup integration entities
		ORMExecuteQuery("UPDATE #this.getApplicationKey()#Integration Set activeFlag=0, installedFlag=0 WHERE integrationPackage not in (#listQualify(installedIntegrationList,"'")#)");
		getHibachiDAO().flushORMSession();
		
		return getBeanFactory();
	}
	
	public void function loadDataFromIntegrations(){

		var integrationCollectionList = getService('hibachiService').getIntegrationCollectionList();
		integrationCollectionList.addFilter('activeFlag',1);
		integrationCollectionList.setDisplayProperties('integrationPackage');
		var integrations = integrationCollectionList.getRecords();
		for(var integrationData in integrations){
			var integrationPath = "#this.getApplicationRootMappingPath()#/integrationServices/#integrationData['integrationPackage']#";
			if(directoryExists(integrationPath)){
				var integrationDbDataPath = integrationPath & '/config/dbdata';
				if(directoryExists(integrationDbDataPath) && !getApplicationValue('skipDbData')){
					getService("hibachiDataService").loadDataFromXMLDirectory(xmlDirectory = integrationDbDataPath);
				}
			}
		}
		
	}
	
	public string function updateIntegrationFromDirectory(required string directoryList, any integrationEntity){
		var beanFactory = getBeanFactory();
		var fileInfo = getFileInfo(arguments.directoryList);

		if(fileInfo.type == "directory" && fileExists("#fileInfo.path#/Integration.cfc") ) {
			
			var integrationPackage = listLast(arguments.directoryList,"\/");
			var integrationCFC = createObject("component", "Slatwall.integrationServices.#integrationPackage#.Integration").init();
			var integrationMeta = getMetaData(integrationCFC);
			
			if(
			    structKeyExists(integrationMeta, "Implements") 
			    && structKeyExists(integrationMeta.implements, "Slatwall.integrationServices.IntegrationInterface")
			){
			    
			    beanFactory.declare("#integrationPackage#IntegrationCFC")
				    .instanceOf("Slatwall.integrationServices.#integrationPackage#.Integration").asSingleton();
				
				if(isNull(arguments.integrationEntity)){
					var integration = this.getIntegrationByIntegrationPackage(integrationPackage, true);	
				}
				else {
					var integration = arguments.integrationEntity;
				}
				
				if(integration.getNewFlag()) {
					integration.setActiveFlag(0);	
				}
				integration.setInstalledFlag(1);
				integration.setIntegrationPackage(integrationPackage);
				integration.setIntegrationName(integrationCFC.getDisplayName());
				integration.setIntegrationTypeList( integrationCFC.getIntegrationTypes() );

				
				// Call Entity Save so that any new integrations get persisted
				getHibachiDAO().save( integration );
				getHibachiDAO().flushORMSession();
				
				
				
				// If this integration is active lets register all of its event handlers, and decorate the getBeanFactory() with it
				if( integration.getEnabledFlag() ) {
				    
					
					// register event-handlers
					for(var e=1; e<=arrayLen(integrationCFC.getEventHandlers()); e++) {
					
						var beanComponentPath = integrationCFC.getEventHandlers()[e];
						var beanName = listLast(beanComponentPath,'.');
						
						if( len(beanName) < len(integrationPackage) || left( beanName, len(integrationPackage) ) != integrationPackage ){
							beanName = integrationPackage&beanName;
						}
						
						if(!beanFactory.containsBean(beanName) ){
							beanFactory.declareBean( beanName, beanComponentPath, true );
							
							if( len(beanName) < len('Handler')  ||  right( beanName, len('Handler') ) != 'Handler' ){
								beanFactory.addAlias(beanName&'Handler',beanName);
							}
						} 
						else {
						    throw("Error while loading integration `#integrationPackage#`, #beanName# already exist in the bean-factory");
						}
					}
					
					if(arrayLen(integrationCFC.getEventHandlers())) {
						logHibachi("The Integration: #integrationPackage# has had #arrayLen(integrationCFC.getEventHandlers())# eventHandler(s) registered");	
					}
					
					/**
	                 * Register the integrationType.cfcs with bean-factory, so the DI works and we won't have to manage it
	                 * the the se can be accessedFrom the beanFactory as, beanFactory.getBean('paypalIntegrationCFC'), getBean('paypalPaymentCFC')...
	                */
				    for(var integrationType in integrationCFC.getIntegrationTypes() ){
				        beanFactory.declare("#integrationPackage##integrationType#CFC")
    					    .instanceOf("Slatwall.integrationServices.#integrationPackage#.#integrationType#").asSingleton();
				    }
				    
					
					if(directoryExists("#this.getApplicationRootMappingPath()#/integrationServices/#integrationPackage#/model")) {
						
						//if we have entities then copy them into root model/entity
						if( directoryExists("#this.getApplicationRootMappingPath()#/integrationServices/#integrationPackage#/model/entity") ){
							
							var modelList = directoryList( expandPath("/Slatwall") & "/integrationServices/#integrationPackage#/model/entity" );
							
							for(var modelFilePath in modelList){
								
								var beanCFC = listLast(replace(modelFilePath,"\","/","all"),'/');
								var beanName = listFirst(beanCFC,'.');
								var modelDestinationPath = this.getApplicationRootMappingPath() & "/model/entity/" & beanCFC;
								
								FileCopy(modelFilePath,modelDestinationPath);
								
								if(!beanFactory.containsBean(beanName) ){
									beanFactory.declareBean(beanName, "#this.getApplicationKey()#.model.entity.#beanName#",false);
								}
							}
							
						}
						
						// Register remaining beans with the Bean-factory;
						var integrationBF = new framework.hibachiaop("#this.getApplicationRootMappingPath()#/integrationServices/#integrationPackage#/model", {
							transients=["process", "transient", "report"],
							exclude=["entity"],
							omitDirectoryAliases = getApplicationValue("hibachiConfig").beanFactoryOmitDirectoryAliases
						});
						
						var integrationBFBeans = integrationBF.getBeanInfo();
						for(var beanName in integrationBFBeans.beanInfo) {
						    var thisBeanInfo = integrationBFBeans.beanInfo[ beanName ];
						    
							if( isStruct(thisBeanInfo) && structKeyExists(thisBeanInfo, "cfc")  && structKeyExists(thisBeanInfo, "isSingleton") ){
								
							    /**
							     * We'll declare a new bean if it doesn't exist in the bean-fctory (to avoide bean-overrides from here), 
							     * and will register an aliaas for that as `package+beanName` if bean-name doesn't starts with integration-package-name;
							     * otherwise we'll try to declare it with `package+beanName` name;
							     * 
							     * for Integrations, as a *rule of thumb* declare your beans with package-name prepend to avoid bean-not-found issues;
							     * This doesn't go along with other conventions like `entity.getProcessObject('context');`
							     * but as long as the entity-names are uniqueue that shuldn't be a problem.
							    */
								if( !beanFactory.containsBean(beanName) ){
        							beanFactory.declareBean( beanName, thisBeanInfo.cfc, thisBeanInfo.isSingleton );
        						
        							if( len(beanName) < len(integrationPackage) || left( beanName, len(integrationPackage) ) != integrationPackage ){
                                        beanFactory.addAlias("#integrationPackage##beanName#", beanName);
    								} 
        						} 
        						else if( len(beanName) < len(integrationPackage) || left( beanName, len(integrationPackage) ) != integrationPackage ){
        						    beanFactory.declareBean( "#integrationPackage##beanName#", thisBeanInfo.cfc, thisBeanInfo.isSingleton );
        						}
        						else {
        						    throw("Error while loading integration beans from #integrationPackage#/model directory, #beanName# already exist in the bean-factory");
        						}
							}
							
						}
						
					}

				}
				
			}
			
			return integrationPackage;
		}
		return '';
	}
	
	
	public array function getAdminNavbarHTMLArray() {
		var returnArr = [];
		
		var isl = this.getIntegrationSmartList();
		isl.addFilter('activeFlag', 1);
		isl.addFilter('installedFlag', 1);
		isl.addLikeFilter('integrationTypeList', '%fw1%');
		
		var authInts = isl.getRecords();
		for(var i=1; i<=arrayLen(authInts); i++) {
			if(getHibachiScope().authenticateAction('#authInts[i].getIntegrationPackage()#:main.default')) {
				var intCFC = getIntegrationCFC(authInts[i]);
				var adminNavbarHTML = intCFC.getAdminNavbarHTML();
				if(len(trim(adminNavbarHTML))) {
					arrayAppend(returnArr, adminNavbarHTML);
				}	
			}
		}
		
		return returnArr;
	}
	
	public array function getAdminLoginHTMLArray() {
		var returnArr = [];
		
		var isl = this.getIntegrationSmartList();
		isl.addFilter('activeFlag', 1);
		isl.addFilter('installedFlag', 1);
		isl.addLikeFilter('integrationTypeList', '%authentication%');
		
		var authInts = isl.getRecords();
		
		for(var i=1; i<=arrayLen(authInts); i++) {
			var intCFC = getAuthenticationIntegrationCFC(authInts[i]);
			var adminLoginHTML = intCFC.getAdminLoginHTML();
			if(len(trim(adminLoginHTML))) {
				arrayAppend(returnArr, adminLoginHTML);
			}
		}
		
		return returnArr;
	}
	
	public string function getJSObjectAdditions() {
		if(!len(variables.jsObjectAdditions)) {
			
			var additions = ' ';
			var isl = this.getIntegrationSmartList();
			isl.addFilter('installedFlag', 1);
			
			for(var integration in isl.getRecords()) {
				var integrationPath = "#this.getApplicationRootMappingPath()#/integrationServices/#integration.getIntegrationPackage()#";
				if(integration.getEnabledFlag() && directoryExists(integrationPath)) {
					additions &= integration.getIntegrationCFC().getJSObjectAdditions();
				}
			}
			
			variables.jsObjectAdditions = additions;
			
		}
		return variables.jsObjectAdditions;
	}
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processIntegration_test(required any integration) {
		var integrationTypes = getIntegrationCFC(arguments.integration).getIntegrationTypes();
		for(var integrationType in integrationTypes) {
			var integrationCFC = arguments.integration.getIntegrationCFC(integrationType);
			if(structKeyExists(integrationCFC, "testIntegration")) {
				var result = integrationCFC.testIntegration();
				arguments.integration.addError(errorName="TestResult", errorMessage="#serializeJSON(result.getData())#");
			} else {
				arguments.integration.addError(errorName="TestResult", errorMessage="#rbKey('define.test_not_implemented')#");
			}
		}

		return arguments.integration;
	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveIntegration(required any entity, struct data) {
		arguments.entity = super.save(argumentCollection=arguments);
		
		if(!arguments.entity.hasErrors()){
			if( structKeyExists(variables, "activeFW1Subsystems") ) {
				structDelete(variables, "activeFW1Subsystems");
			}
			
			getHibachiCacheService().resetCachedKey('actionPermissionDetails');
			
			if(arguments.entity.getEnabledFlag()){
				getHibachiScope().setApplicationValue("initialized",false);
			}
			
		}
		
		return arguments.entity;
	}
	
	public any function processIntegration_pullData(required any integration, any processObject) {
		
		if(arguments.integration.getActiveFlag()){
			integration.getIntegrationCFC('data').pullData();	
		}
		
		return arguments.integration;
	}
	
	public any function processIntegration_pushData(required any integration, any processObject) {
		
		if(arguments.integration.getActiveFlag()){
			integration.getIntegrationCFC('data').pushData();	
		}
		
		return arguments.integration;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
}
