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
component extends="Slatwall.org.Hibachi.Hibachi"{

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
		runRequestActions(argumentCollection=arguments);
	}

	function runRequestActions() {
		if(structKeyExists(form, "slatAction")) {
			request.context['doNotRender'] = true;
			for(var action in listToArray(form.slatAction)) {
				arguments.slatwallScope.doAction( action, request.context);
				if(arguments.slatwallScope.hasFailureAction(action)) {
					break;
				}
			}
		} else if (structKeyExists(url, "slatAction")) {
			request.context['doNotRender'] = true;
			for(var action in listToArray(url.slatAction)) {
				var actionResult = arguments.slatwallScope.doAction( action, request.context);
				if(arguments.slatwallScope.hasFailureAction(action)) {
					break;
				}
			}
		}
		if(structKeyExists(form, "slatProcess")) {
			for(var processAction in listToArray(form.slatProcess)) {
				var session = getSessionService().processSesion($.slatwall.getSession(), processAction, request);
				if(session.hasError()) {
					break;
				}
			}
		}
		generateRenderedContent(argumentCollection=arguments);
		onRequestEnd();
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
				if(isNull(brand)){
					content = render404(arguments.slatwallScope,site);
				}
				arguments.slatwallScope.setBrand( brand );
				entityName = 'brand';
			}

			// Look for the Product URL Key
			if(isProductURLKey) {
				var product = arguments.slatwallScope.getService("productService").getProductByURLTitle(arguments.contenturlTitlePath, true);
				if(isNull(product)){
					content = render404(arguments.slatwallScope,site);
				}
				arguments.slatwallScope.setProduct( product );
				entityName = 'product';
			}

			// Look for the Product Type URL Key
			if (isProductTypeURLKey) {
				var productType = arguments.slatwallScope.getService("productService").getProductTypeByURLTitle(arguments.contenturlTitle, true);
				if(isNull(productType)){
					content = render404(arguments.slatwallScope,site);
				}
				arguments.slatwallScope.setProductType( productType );
				entityName = 'productType';
			}
			var entityDisplayTemplateSetting = arguments.slatwallScope.invokeMethod('get#entityName#').setting('#entityName#DisplayTemplate', [site]);
			var entityTemplateContent = arguments.slatwallScope.getService("contentService").getContent( entityDisplayTemplateSetting );;
			if(!isnull(entityTemplateContent)){
				arguments.slatwallScope.setContent( entityTemplateContent );
				var contentTemplateFile = entityTemplateContent.setting('contentTemplateFile',[entityTemplateContent]);
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
			if(!isNull(arguments.contenturlTitlePath) && len(arguments.contenturlTitlePath)){

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
			var contentTemplateFile = content.Setting('contentTemplateFile');
			//templatePath relative to the slatwallCMS
			contentPath = templatePath & contentTemplateFile;
			arguments.slatwallScope.setContent(content);
		}
		var $ = getApplicationScope(argumentCollection=arguments);
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

	public any function getApplicationScope(){
		var applicationScope = this;
		applicationScope.slatwall = arguments.slatwallScope;
		return applicationScope;
	}

	// Implicit onMissingMethod() to handle standard CRUD
	public any function onMissingMethod(string missingMethodName, struct missingMethodArguments) {
		if(structKeyExists(arguments, "missingMethodName")) {
			if( left(arguments.missingMethodName, 6) == "render" ) {
				var entityName = arguments.missingMethodName.substring( 6 );
				var genericGetterName = replace(arguments.missingMethodName,'render','get');
				if(structCount(arguments.missingMethodArguments) == 2){
					var entity = getHibachiScope().getService('hibachiService').invokeMethod(genericGetterName,{1=arguments.missingMethodArguments[1]});
					return entity.getValueByPropertyIdentifier(arguments.missingMethodArguments[2]);
				}else if(structCount(arguments.missingMethodArguments) == 3){
					var entity = getHibachiScope().getService('hibachiService').invokeMethod(genericGetterName,{1=[arguments.missingMethodArguments[1], arguments.missingMethodArguments[2]]});
					return entity.getValueByPropertyIdentifier(arguments.missingMethodArguments[3]);
				}
			}
		}
	}

	public string function dspForm(
		required string formCode,
		string sRedirectUrl
	){
		var newFormResponse = getHibachiScope().getService('formService').newFormResponse();
		var requestedForm = getHibachiScope().getService('formService').getFormByFormCode(arguments.formCode);
		var currentSite = getHibachiScope().getService('siteService').getCurrentRequestSite();
		var specificFormTemplateFileName = "form_"  & formCode & ".cfm";
		var defaultFormTemplateFileName = "slatwall-form.cfm";

		if(!structKeyExists(arguments, "sRedirectUrl")){
			arguments.sRedirectUrl = "/";
		}

		var specificFormTemplateFilePath =  currentSite.getTemplatesPath() & specificFormTemplateFileName;
		var baseTemplatePath = currentSite.getApp().getAppRootPath() & "/" & currentSite.getSiteCode() & "/templates/";

		if(fileExists(specificFormTemplateFilePath)){
			var templatePath = baseTemplatePath & specificFormTemplateFileName;
		} else {
			var templatePath = baseTemplatePath & defaultFormTemplateFileName;
		}

		savecontent variable="formHTML"{
			include templatePath;
		};

		return formHtml;
	}

	public string function renderNav(
		string startContentId=""
		, numeric viewDepth=1
		, numeric currDepth=1
		, string siteCode=""
		, string navClass=""
		, string navID=""
		, string liKidsClass=""
		, string liKidsAttributes=""
		, string liActiveClass="active"
		, string liActiveAttributes=""
		, string liKidsNestedClass=""
		, string aKidsClass=""
		, string aKidsAttributes=""
		, string aActiveClass="active"
		, string aActiveAttributes=""
		, string ulNestedClass=""
		, string ulNestedAttributes=""
		, string target = ""
		, array contentCollection=[]
	){
		//if content id does not exist then get home
		if(!len(arguments.startContentID)){
			var currentSite = getHibachiScope().getService('siteService').getCurrentRequestSite();
			arguments.content = getHibachiScope().getService('contentService').getDefaultContentBySite(currentSite);
		}else{
			arguments.content = getHibachiScope().getService('contentService').getContent(arguments.startContentId);
		}

		if(!len(arguments.siteCode)){
			arguments.siteCode = arguments.content.getSite().getSiteCode();
		}

		if(!arraylen(arguments.contentCollection)){
			arguments.contentCollection = arguments.content.getChildContents(forNavigation=true);
		}


		//var firstLevelItems = arguments.content.getChildContents();
		savecontent variable="navHTML"{
			include 'templates/navtemplate.cfm';
		};
		return navHTML;

	}

	public string function addLink(
		required any content,
		string title,
		string navClass="",
		string target="",
		string navId="",
		boolean showCurrent=true
	){

		var link ="";
		var href ="";
		var theClass = arguments.navClass;

		if(arguments.showCurrent){
			arguments.showCurrent=listFind(getHibachiScope().content().getContentIDPath(),arguments.content.getContentID());
		}

		if(arguments.showCurrent){
			theClass=listAppend(theClass,arguments.aActiveClass," ");
		}

		if(arguments.content.hasChildContent()){
			theClass=listAppend(theClass,arguments.aKidsClass," ");
		}

		href=createHREF(
			arguments.content
		);

		link='<a href="/#href#"#iif(len(arguments.target) and arguments.target neq '_self',de(' target="#arguments.target#"'),de(""))##iif(len(theClass),de(' class="#theClass#"'),de(""))##iif(len(arguments.navId),de(' id="#arguments.navId#"'),de(""))##iif(arguments.showCurrent,de(' #replace(arguments.aActiveAttributes,"##","####","all")#'),de(""))##iif(arguments.content.hasChildContent() and len(arguments.aKidsAttributes),de(' #replace(arguments.aKidsAttributes,"##","####","all")#'),de(""))#>#HTMLEditFormat(arguments.title)#</a>';
		return link;
	}

	public string function createHref(required any content, string queryString=""){
		var href=arguments.content.getURLTitlePath();

		return href;
	}


}
