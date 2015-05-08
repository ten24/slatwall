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
//		var appData = {
//			appID ='',
//			appName='testAPP23w2',
//			appCode="testAPP23w2"
//		};
//		var app = createPersistedTestEntity(entityName='app',data=appData);
//		var integration = variables.integrationService.getIntegrationbyIntegrationID('402881864c42f280014c4c9851f9016b');
//		app.setIntegration(integration);
		var siteData = {
			siteid='',
			siteName="ddddeads",
			siteCode="ddddeads",
			app={
				appID ='test',
				appName='ddddeads',
				appCode="ddddeads",
				integration={
					integrationID='402881864c42f280014c4c9851f9016b'
				}
			}
		};
		var site = createTestEntity(entityName="site",data=siteData);
		//directoryDelete(site.getSitePath(),true);
		request.slatwallScope.saveEntity( site, {} );
		
		//var site = createPersistedTestEntity(entityName="site",data=siteData,saveWithService=true);
		//here we should assert the default content was created as well as the directories
		request.debug(arraylen(site.getContents()));
		request.debug(site.getContents()[8].gettitle());
		request.debug(site.getContents()[8].getContentTemplateType().getTypeID());
		request.debug(site.getContents()[8].setting('productTypeDisplayTemplate'));
		//request.debug(site);
//		for(var content in site.getContents()){
//			//if(!isnull(content.getcontentTemplateType())){
//				request.debug(content.setting('productDisplayTemplate'));
//			//}
//			
//		}

		//probably should also remove directories as the unit tests do not already do that
		//request.slatwallScope.getBean('siteService').deleteSite( site);
	}
}


