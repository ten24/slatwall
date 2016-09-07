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
	
	variables.integrationCFCs = {};
	variables.paymentIntegrationCFCs = {};
	variables.shippingIntegrationCFCs = {};
	variables.authenticationIntegrationCFCs = {};
	variables.taxIntegrationCFCs = {};
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
		var dirList = directoryList( expandPath("/Slatwall/integrationServices") );
		
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
	
	public any function getIntegrationCFC(required any integration) {
		if(!structKeyExists(variables.integrationCFCs, arguments.integration.getIntegrationPackage())) {
			var integrationCFC = createObject("component", "Slatwall.integrationServices.#arguments.integration.getIntegrationPackage()#.Integration").init();
			//populateIntegrationCFCFromIntegration(integrationCFC, arguments.integration);
			variables.integrationCFCs[ arguments.integration.getIntegrationPackage() ] = integrationCFC;
		}
		return variables.integrationCFCs[ arguments.integration.getIntegrationPackage() ];
	}

	public any function getAuthenticationIntegrationCFC(required any integration) {
		if(!structKeyExists(variables.authenticationIntegrationCFCs, arguments.integration.getIntegrationPackage())) {
			var integrationCFC = createObject("component", "Slatwall.integrationServices.#arguments.integration.getIntegrationPackage()#.Authentication").init();
			variables.authenticationIntegrationCFCs[ arguments.integration.getIntegrationPackage() ] = integrationCFC;
		}
		return variables.authenticationIntegrationCFCs[ arguments.integration.getIntegrationPackage() ];
	}

	public any function getPaymentIntegrationCFC(required any integration) {
		if(!structKeyExists(variables.paymentIntegrationCFCs, arguments.integration.getIntegrationPackage())) {
			var integrationCFC = createObject("component", "Slatwall.integrationServices.#arguments.integration.getIntegrationPackage()#.Payment").init();
			variables.paymentIntegrationCFCs[ arguments.integration.getIntegrationPackage() ] = integrationCFC;
		}
		return variables.paymentIntegrationCFCs[ arguments.integration.getIntegrationPackage() ];
	}
	
	public any function getShippingIntegrationCFC(required any integration) {
		if(!structKeyExists(variables.shippingIntegrationCFCs, arguments.integration.getIntegrationPackage())) {
			var integrationCFC = createObject("component", "Slatwall.integrationServices.#arguments.integration.getIntegrationPackage()#.Shipping").init();
			variables.shippingIntegrationCFCs[ arguments.integration.getIntegrationPackage() ] = integrationCFC;
		}
		return variables.shippingIntegrationCFCs[ arguments.integration.getIntegrationPackage() ];
	}

	public any function getTaxIntegrationCFC(required any integration) {
		if(!structKeyExists(variables.taxIntegrationCFCs, arguments.integration.getIntegrationPackage())) {
			var integrationCFC = createObject("component", "Slatwall.integrationServices.#arguments.integration.getIntegrationPackage()#.Tax").init();
			variables.taxIntegrationCFCs[ arguments.integration.getIntegrationPackage() ] = integrationCFC;
		}
		return variables.taxIntegrationCFCs[ arguments.integration.getIntegrationPackage() ];
	}
	
	public any function updateIntegrationsFromDirectory( required any beanFactory ) {
		var dirList = directoryList( expandPath("/Slatwall/integrationServices") );
		var integrationList = this.listIntegration();
		var installedIntegrationList = "";
		
		// Loop over each integration in the integration directory
		for(var i=1; i<= arrayLen(dirList); i++) {
			
			var fileInfo = getFileInfo(dirList[i]);
			
			if(fileInfo.type == "directory" && fileExists("#fileInfo.path#/Integration.cfc") ) {
				
				var integrationPackage = listLast(dirList[i],"\/");
				var integrationCFC = createObject("component", "Slatwall.integrationServices.#integrationPackage#.Integration").init();
				var integrationMeta = getMetaData(integrationCFC);
				
				if(structKeyExists(integrationMeta, "Implements") && structKeyExists(integrationMeta.implements, "Slatwall.integrationServices.IntegrationInterface")) {
					
					installedIntegrationList = listAppend(installedIntegrationList, integrationPackage);
					
					var integration = this.getIntegrationByIntegrationPackage(integrationPackage, true);
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
					
					// If this integration is active lets register all of its event handlers, and decorate the beanFactory with it
					if( integration.getEnabledFlag() ) {
						
						for(var e=1; e<=arrayLen(integrationCFC.getEventHandlers()); e++) {
							getHibachiEventService().registerEventHandler( integrationCFC.getEventHandlers()[e] );
						}
						
						if(arrayLen(integrationCFC.getEventHandlers())) {
							logHibachi("The Integration: #integrationPackage# has had #arrayLen(integrationCFC.getEventHandlers())# eventHandler(s) registered");	
						}
						
						if(directoryExists("#getApplicationValue("applicationRootMappingPath")#/integrationServices/#integrationPackage#/model")) {
							var integrationBF = new Slatwall.org.Hibachi.DI1.ioc("/Slatwall/integrationServices/#integrationPackage#/model", {
								transients=["process", "transient", "report"],
								exclude=["entity"]
							});
							
							var integrationBFBeans = integrationBF.getBeanInfo();
							for(var beanName in integrationBFBeans.beanInfo) {
								if(isStruct(integrationBFBeans.beanInfo[beanName]) && structKeyExists(integrationBFBeans.beanInfo[beanName], "cfc") && structKeyExists(integrationBFBeans.beanInfo[beanName], "isSingleton")) {
									if(len(beanName) > len(integrationPackage) && left(beanName, len(integrationPackage)) eq integrationPackage) {
										arguments.beanFactory.declareBean( beanName, integrationBFBeans.beanInfo[ beanName ].cfc, integrationBFBeans.beanInfo[ beanName ].isSingleton );
									} else {
										arguments.beanFactory.declareBean( "#integrationPackage##beanName#", integrationBFBeans.beanInfo[ beanName ].cfc, integrationBFBeans.beanInfo[ beanName ].isSingleton );	
									}
								}
							}
						}
					}
				}
			}
		}
		
		// Turn off the installed and ready flags on any previously setup integration entities
		for(var integrationEntity in integrationList) {
			
			if(!listFindNoCase(installedIntegrationList, integrationEntity.getIntegrationPackage())) {
				integrationEntity.setInstalledFlag(0);
				integrationEntity.setActiveFlag(0);
				
				getHibachiDAO().flushORMSession();
			}
			
			
		}
		
		return arguments.beanFactory;
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
				if(integration.getEnabledFlag()) {
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
	
	public any function saveIntegration() {
		if( structKeyExists(variables, "activeFW1Subsystems") ) {
			structDelete(variables, "activeFW1Subsystems");
		}
		getHibachiAuthenticationService().clearActionPermissionDetails();
		return super.save(argumentCollection=arguments);
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
}
