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
component {
	
	// Allow For Application Config
	try{include "../../config/configApplication.cfm";}catch(any e){}
	// Allow For Instance Config
	try{include "../../custom/config/configApplication.cfm";}catch(any e){}
	
	this.sessionManagement = true;
	
	this.mappings[ "/Slatwall" ] = replace(replace(getDirectoryFromPath(getCurrentTemplatePath()),"\","/","all"), "/meta/sample/", "");
	
	this.ormEnabled = true;
	this.ormSettings.cfclocation = ["/Slatwall/model/entity","/Slatwall/integrationServices"];
	this.ormSettings.dbcreate = "update";
	this.ormSettings.flushAtRequestEnd = false;
	this.ormsettings.eventhandling = true;
	this.ormSettings.automanageSession = false;
	
	function onRequestStart() {
		runRequestActions();
		
	}
	
	function runRequestActions() {
//		if (!structKeyExists(application, "slatwallFW1Application")) {
//			application.slatwallFW1Application = createObject("component", "Slatwall.Application");
//		}
//		application.slatwallFW1Application.bootstrap();
		
		if(structKeyExists(form, "slatAction")) {
			for(var action in listToArray(form.slatAction)) {
				request.slatwallScope.doAction( action );
				if(request.slatwallScope.hasFailureAction(action)) {
					break;
				}
			}
		} else if (structKeyExists(url, "slatAction")) {
			for(var action in listToArray(url.slatAction)) {
				var actionResult = request.slatwallScope.doAction( action );
				if(request.slatwallScope.hasFailureAction(action)) {
					break;
				}
			}
		}
	}
	
	function generateRenderedContent() {
		var site = arguments.slatwallScope.getSite();
		var templatePath = site.getApp().getAppRootPath() & '/' & site.getSiteCode() & '/templates/';
		var contentPath = '';
		var templateBody = '';
		
		if(!isNull(arguments.entityURL)){
			var isBrandURLKey = arguments.slatwallScope.setting('globalURLKeyBrand') == arguments.entityURL;
			var isProductURLKey = arguments.slatwallScope.setting('globalURLKeyProduct') == arguments.entityURL;
			var isProductTypeURLKey = arguments.slatwallScope.setting('globalURLKeyProductType') == arguments.entityURL;
			var entityName = '';
			
			// First look for the Brand URL Key
			if (isBrandURLKey) {
				var brand = arguments.slatwallScope.getService("brandService").getBrandByURLTitle(arguments.contenturlTitlePath, true);
				arguments.slatwallScope.setBrand( brand );
				entityName = 'brand';
			}
			
			// Look for the Product URL Key
			if(isProductURLKey) {
				var product = arguments.slatwallScope.getService("productService").getProductByURLTitle(arguments.contenturlTitlePath, true);
				arguments.slatwallScope.setProduct( product );	
				entityName = 'product';
			}
			
			// Look for the Product Type URL Key
			if (isProductTypeURLKey) {
				var productType = arguments.slatwallScope.getService("productService").getProductTypeByURLTitle(arguments.contenturlTitle, true);
				arguments.slatwallScope.setProductType( productType );
				entityName = 'productType';
			}
			var entityDisplayTemplateSetting = arguments.slatwallScope.invokeMethod('get#entityName#').setting('#entityName#DisplayTemplate', [site]); 
			var entityTemplateContent = arguments.slatwallScope.getService("contentService").getContent( entityDisplayTemplateSetting );;
			if(!isnull(entityTemplateContent)){
				arguments.slatwallScope.setContent( entityTemplateContent );
				var contentTemplateFile = entityTemplateContent.setting('contentTemplateFile',[content]);
				if(!isNull(contentTemplateFile)){
					
					contentPath = templatePath & contentTemplateFile;
											
					
					arguments.slatwallScope.setContent(entityTemplateContent);
				}else{
					render404(arguments.slatwallScope,site);
					//throw('no contentTemplateFile for the entity');
				}
			}else{
				render404(arguments.slatwallScope,site);
				//throw('no content for entity');
			}
		}else{
			if(!isNull(arguments.contenturlTitlePath)){
			
				//now that we have the site directory, we should see if we can retrieve the content via the urltitle and site
				var content = arguments.slatwallScope.getService('contentService').getContentBySiteIDAndUrlTitlePath(site.getSiteID(),arguments.contenturlTitlePath);
			}else{
				var content = arguments.slatwallScope.getService('contentService').getDefaultContentBySite(site);
			}
			
			if(isNull(content)){
				content = render404(arguments.slatwallScope,site);
				//throw('content does not exists for #arguments.contenturlTitlePath#');
			}
			//now that we have the content, get the file name so that we can retrieve it form the site's template directory
			var contentTemplateFile = content.Setting('contentTemplateFile',[content]);
			//templatePath relative to the slatwallCMS
			contentPath = templatePath & contentTemplateFile;
			arguments.slatwallScope.setContent(content);
		}
		var $ = {
			slatwall=arguments.slatwallScope
		};
		savecontent variable="templateData"{
			include "#contentPath#";
		}
		templateBody = arguments.slatwallScope.getService('hibachiUtilityService').replaceStringTemplate(arguments.slatwallScope.getService('hibachiUtilityService').replaceStringEvaluateTemplate(templateData),arguments.slatwallScope.getContent());
		
		writeOutput(templateBody);
		abort;
	}
	
	function render404(required any slatwallScope, required any site){
		var context = getPageContext();
		context.getOut().clearBuffer();
		var response = context.getResponse();
		response.setstatus(404);
		arguments.slatwallScope.getService("hibachiEventService").announceEvent(eventName="404");
		var content = arguments.slatwallScope.getService('contentService').getContentBySiteIDAndUrlTitlePath(site.getSiteID(),'404');
		if(!isNull(content)){
			return content;
		}
		abort;
	}
	
}