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
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

	public void function setUp() {
		super.setup();
		
		variables.service = request.slatwallScope.getBean("siteService");
		variables.integrationService = request.slatwallScope.getBean("integrationService");
	}
	
	public void function deploy_SiteTest(){
		
		var integration = request.slatwallScope.getService('integrationService').getIntegrationByIntegrationPackage('slatwallcms');
		
		var appData = {
			appID ='test',
			appName='#createUuid()#',
			appCode="#createUuid()#",
			integration={
				integrationID=integration.getIntegrationID()
			}
		};
		var app = createTestEntity(entityName="app",data=appData,saveWithService=true);
		request.slatwallScope.saveEntity( app, appData );
		var siteData = {
			siteid='',
			siteName="#createUuid()#",
			siteCode="#createUuid()#",
			domainNames="#createUUID()#",
			app={
				appID=app.getAppID()
			}
		};
		var site = createTestEntity(entityName="site",data=siteData);
		site = variables.service.saveSite(site,siteData);
		//here we should assert the default content was created as well as the directories
		assertTrue(arraylen(site.getContents()));
		//remove directories as the unit tests do not already do that. Delete outside of validation
		directoryDelete(site.getApp().getAppPath(),true);
		request.slatwallScope.getService("settingService").removeAllEntityRelatedSettings( entity=app );
		request.slatwallScope.getService("settingService").removeAllEntityRelatedSettings( entity=site );
		ormflush();
		// Remove any Many-to-Many relationships
		site.removeAllManyToManyRelationships();
		app.removeAllManyToManyRelationships();
		app.removeSite(site);
		//site.removeApp(javacast('null',''));
		// Call delete in the DAO
		request.slatwallScope.getBean('HibachiDAO').delete(target=app);
	}
}


