<!---

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

--->
<cfcomponent output="false">
	<cfscript>
	
	public function init(required any Hibachi){
		variables.hibachi = arguments.hibachi;
		return this;
	}
	
	public function getHibachi(){
		return variables.hibachi;
	}

	function onRequestStart() {
		runRequestActions(argumentCollection=arguments);
	}

	function runRequestActions() {
		if(structKeyExists(form, "slatAction")) {
			request.context['doNotRender'] = true;
			for(var action in listToArray(form.slatAction)) {
				arguments.actionResult = getHibachi().getHibachiScope().doAction( action, request.context);
				if(getHibachi().getHibachiScope().hasFailureAction(action)) {
					break;
				}
			}
		} else if (structKeyExists(url, "slatAction")) {
			request.context['doNotRender'] = true;
			for(var action in listToArray(url.slatAction)) {
				arguments.actionResult = getHibachi().getHibachiScope().doAction( action, request.context);
				if(getHibachi().getHibachiScope().hasFailureAction(action)) {
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
		
		var site = getHibachi().getHibachiScope().getSite();
		var appTemplatePath = site.getApp().getAppRootPath() & '/templates';
 		var siteTemplatePath = site.getApp().getAppRootPath() & '/' & site.getSiteCode() & '/templates';
		var contentPath = '';
		var templateBody = '';
		if(!isNull(site.getResetSettingCache()) && site.getResetSettingCache()){
			getHibachi().getHibachiScope().getService('HibachiCacheService').resetCachedKeyByPrefix('content');
			var cacheList = 
			   "globalURLKeyAttribute,
			    globalURLKeyBrand,
				globalURLKeyProduct,
				globalURLKeyProductType,
				globalURLKeyAccount,
				globalURLKeyAddress,
				gloablURLKeyCategory,
				productDisplayTemplate,
				productTypeDisplayTemplate,
				brandDisplayTemplate,
				accountDisplayTemplate,
				addressDisplayTemplate"
			;
			var cacheArray = listToArray(cacheList);
			for(var cacheItem in cacheArray){
				getHibachi().getHibachiScope().getService('HibachiCacheService').resetCachedKey(cacheItem);
			}
			site.setResetSettingCache(false);
		}
		if(!isNull(arguments.entityURL)){
			var entityName = getHibachiScope().getEntityURLKeyType(arguments.entityUrl);
			if(len(entityName)){
				if(entityName=='Attribute'){
					var entityService = getHibachiScope().getService( "hibachiService" ).getServiceByEntityName( entityName );
					var entity =entityService.invokeMethod('get#entityName#ByURLTitle',{1=listFirst(arguments.contentURLTitlePath,'/'),2=true});
					var attributeOption = entityService.invokeMethod('getAttributeOptionByURLTitle',{1=listLast(arguments.contentURLTitlePath,'/'),2=true});
					getHibachi().getHibachiScope().setAttributeOption(attributeOption);
					
				}else{
					var entityService = getHibachiScope().getService( "hibachiService" ).getServiceByEntityName( entityName );
					var entity =entityService.invokeMethod('get#entityName#ByURLTitle',{1=arguments.contentURLTitlePath,2=true});
				}
				
				if(isNull(entity) || entity.getNewFlag()){
					var content = render404(getHibachi().getHibachiScope(),site);
				}
				getHibachi().getHibachiScope().invokeMethod('set#entityName#',{1=entity});
				getHibachi().getHibachiScope().setRouteEntity(  entityName, entity );
			}
			var entityDisplayTemplateSetting = getHibachi().getHibachiScope().invokeMethod('get#entityName#').setting('#entityName#DisplayTemplate', [site]);
			var entityTemplateContent = getHibachi().getHibachiScope().getService("contentService").getContent( entityDisplayTemplateSetting );
			if(!isnull(entityTemplateContent)){
				getHibachi().getHibachiScope().setContent( entityTemplateContent );
				var contentTemplateFile = entityTemplateContent.setting('contentTemplateFile',[entityTemplateContent]);
				 
			}else{
				var content = render404(getHibachi().getHibachiScope(),site);
				var contentTemplateFile = content.Setting('contentTemplateFile');
				//throw('no content for entity');
			}
		}else{
			if(!isNull(arguments.contenturlTitlePath) && len(arguments.contenturlTitlePath)){

				//now that we have the site directory, we should see if we can retrieve the content via the urltitle and site
				var content = getHibachi().getHibachiScope().getService('contentService').getContentBySiteIDAndUrlTitlePath(site.getSiteID(),arguments.contenturlTitlePath);
			}else{
				var content = getHibachi().getHibachiScope().getService('contentService').getDefaultContentBySite(site);
			}

			if(isNull(content) || isNull(content.getActiveFlag()) || !content.getActiveFlag()){
				var content = render404(getHibachi().getHibachiScope(),site);
				//throw('content does not exists for #arguments.contenturlTitlePath#');
			}
			//now that we have the content, get the file name so that we can retrieve it form the site's template directory
			var contentTemplateFile = content.Setting('contentTemplateFile');
			getHibachi().getHibachiScope().setContent(content);
		}


		if(FileExists(ExpandPath(siteTemplatePath) & '/' & contentTemplateFile)){
			var contentPath = siteTemplatePath & '/' &  contentTemplateFile;
		} else if (FileExists(ExpandPath(appTemplatePath) & '/' &  contentTemplateFile)){
			var contentPath = appTemplatePath & '/' &  contentTemplateFile;
		} else { 
			render404(getHibachi().getHibachiScope(),site);
			//throw("Requested Template: " & contentTemplateFile & " Doesn't Exist in the Site Or The App");
		}	
		
		arguments.contentPath = contentPath;

		arguments.renderActionInTemplate = getHibachi().getHibachiScope().getContent().setting('contentRenderHibachiActionInTemplate');	
		
		var templateData = buildRenderedContent(argumentCollection=arguments);
		if(arguments.renderActionInTemplate && structKeyExists(arguments, "actionResult")){
 			var hibachiView = {}; 
 			hibachiView['contentBody'] = arguments.actionResult;
 			templateBody = getHibachi().getHibachiScope().getService('hibachiUtilityService').replaceStringTemplate(templateData,hibachiView);
 		} 
		templateBody = getHibachi().getHibachiScope().getService('hibachiUtilityService').replaceStringTemplate(templateData,getHibachi().getHibachiScope().getContent());
		templateBody = getHibachi().getHibachiScope().getService('hibachiUtilityService').replaceStringEvaluateTemplate(template=templateBody,object=this);
		
		writeOutput(templateBody);
		abort;
	}
	
	</cfscript>
	
	<cffunction name="buildRenderedContent">
		<cfset request.context.fw = getHibachi().getHibachiScope().getApplicationValue("application")/>
		<cfset var $ = getApplicationScope(argumentCollection=arguments)/>
		
		<cfsavecontent variable="local.templateData" >
			<cfoutput>
				<cfinclude template="templates/basetemplate.cfm"/>
			</cfoutput>
		</cfsavecontent>
		<cfreturn local.templateData/>
	</cffunction>
	
	<cfscript>
	   	
	   
	
	function getHibachiTagPathByContentPath(required string contentPath){
		var directoryDepth = listLen(arguments.contentPath,'/');
		var hibachiTagPath = "org/Hibachi/HibachiTags";
		var depthString = "";
		for(var i=1; i < directoryDepth;i++){
			depthString &= "../";
		}
		return depthString & hibachiTagPath;
	}

	function checkForRewrite(required any slatwallScope, required any site){
		//overrride is intended to handle IIS redirects
		var rewriteConfigPath = arguments.site.getSitePath() &'config/rewritemaps.json';
		if(fileExists(rewriteConfigPath)){
			
			if ( len( getContextRoot() ) ) {
				var cgiScriptName = replace( CGI.SCRIPT_NAME, getContextRoot(), '' );
				var cgiPathInfo = replace( CGI.PATH_INFO, getContextRoot(), '' );
			} else {
				var cgiScriptName = CGI.SCRIPT_NAME;
				var cgiPathInfo = CGI.PATH_INFO;
			}
			var pathInfo = cgiPathInfo;
			 if ( len( pathInfo ) > len( cgiScriptName ) && left( pathInfo, len( cgiScriptName ) ) == cgiScriptName ) {
	            // canonicalize for IIS:
	            pathInfo = right( pathInfo, len( pathInfo ) - len( cgiScriptName ) );
	        } else if ( len( pathInfo ) > 0 && pathInfo == left( cgiScriptName, len( pathInfo ) ) ) {
	            // pathInfo is bogus so ignore it:
	            pathInfo = '';
	        }
	        //take path and  parse it
	        var pathArray = listToArray(pathInfo,'/');
	        var pathArrayLen = arrayLen(pathArray);
	
	        var urlTitlePathStartPosition = 1;
    		
    		arguments.contenturlTitlePath = '';
    		for(var i = 1;i <= arraylen(pathArray);i++){
    			if(i == arrayLen(pathArray)){
    				arguments.contenturlTitlePath &= pathArray[i];
    			}else{
    				arguments.contenturlTitlePath &= pathArray[i] & '/';
    			}
    		}
			
			var rewriteFileContent = fileRead(rewriteConfigPath);
			var redirectableList = {};
			if(isJSON(rewriteFileContent)){
				redirectableList = deserializeJson(rewriteFileContent);	
			}else{
				throw('file must be json');
			}
			var key = '/'&arguments.contenturlTitlePath;
			if(structKeyExists(redirectableList,'/'&arguments.contenturlTitlePath)){
				
				location(redirectableList[key],false,302);
				
			}
			
		}
	}
	
	function render404(required any slatwallScope, required any site){
		
		checkForRewrite(argumentCollection=arguments);
		
		var context = getPageContext();
		context.getOut().clearBuffer();
		var response = context.getResponse();
		response.setstatus(404);
		getHibachi().getHibachiScope().getService("hibachiEventService").announceEvent(eventName="404");
		var content = getHibachi().getHibachiScope().getService('contentService').getContentBySiteIDAndUrlTitlePath(site.getSiteID(),'404');
		if(!isNull(content)){
			return content;
		}
		abort;
	}

	public any function getApplicationScope(){
		var applicationScope = this;
		applicationScope.slatwall = getHibachi().getHibachiScope();
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
	
	public any function getHibachiScope(){
		return getHibachi().getHibachiScope();
	}

	public string function getContentBodyByUrlTitlePath(required string urlTitlePath){
		var contentBody = "";
		var contentCollectionList = getHibachiScope().getService('contentService').getContentCollectionList();
		contentCollectionList.setDisplayProperties('contentBody');
		contentCollectionList.addFilter('urlTitlePath',arguments.urlTitlePath);
		var contentRecords = contentCollectionList.getPageRecords();
		if(arraylen(contentRecords)){
			contentBody = contentRecords[1]['contentBody'];
		}
		return contentBody;
	}
	
	/** Returns the content given a urlTitle or the default content if no urlTitle is given. */
    public any function getContentByUrlTitlePath(urlTitlePath){

        var currentSite = getHibachiScope().getCurrentRequestSite();

        if (!isNull(arguments.urlTitlePath) && !isNull(currentSite)){
            var contentEntity = getHibachiScope().getService("ContentService").getContentBySiteIDAndUrlTitlePath(currentSite.getSiteID(),arguments.urlTitlePath);
            
            if(isNull(contentEntity)){
            	
            	return getHibachiScope().getService("ContentService").getContentBySiteIDAndUrlTitlePath(currentSite.getSiteID(),"missing-partial");
           	}

            return contentEntity;
        }
    }

	public string function dspForm(
		required string formCode,
		string sRedirectUrl="/"
	){
		request.context.newFormResponse = getHibachiScope().getService('formService').newFormResponse();
		request.context.requestedForm = getHibachiScope().getService('formService').getFormByFormCode(arguments.formCode);
		var currentSite = getHibachiScope().getService('siteService').getCurrentRequestSite();
		var specificFormTemplateFileName = "form_"  & formCode & ".cfm";
		var defaultFormTemplateFileName = "slatwall-form.cfm";

		var specificFormTemplateFilePath =  currentSite.getTemplatesPath() & specificFormTemplateFileName;
		var siteTemplatePath = currentSite.getApp().getAppRootPath() & "/" & currentSite.getSiteCode() & "/templates/";
		var baseTemplatePath = currentSite.getApp().getAppRootPath() & "/templates/";

		if(fileExists(specificFormTemplateFilePath)){
			var templatePath = siteTemplatePath & specificFormTemplateFileName;
		} else if(fileExists(baseTemplatePath & specificFormTemplateFileName)){
			var templatePath = baseTemplatePath & specificFormTemplateFileName;
		} else if(fileExists(siteTemplatePath & defaultFormTemplateFileName)){
			var templatePath = siteTemplatePath & defaultFormTemplateFileName;
		} else {
			var templatePath = baseTemplatePath & defaultFormTemplateFileName;
		}

		savecontent variable="local.formHTML"{
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
			var currentSite = getHibachiScope().getCurrentRequestSite();
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
		savecontent variable="local.navHTML"{
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

		link='<a href="/#href#"#getHibachiScope().getService('hibachiUtilityService').hibachiTernary(len(arguments.target) and arguments.target neq '_self',' target="#arguments.target#"',"")##getHibachiScope().getService('hibachiUtilityService').hibachiTernary(len(theClass),' class="#theClass#"',"")##getHibachiScope().getService('hibachiUtilityService').hibachiTernary(len(arguments.navId),' id="#arguments.navId#"',"")##getHibachiScope().getService('hibachiUtilityService').hibachiTernary(arguments.showCurrent,' #replace(arguments.aActiveAttributes,"##","####","all")#',"")##getHibachiScope().getService('hibachiUtilityService').hibachiTernary(arguments.content.hasChildContent() and len(arguments.aKidsAttributes),' #replace(arguments.aKidsAttributes,"##","####","all")#',"")#>#HTMLEditFormat(arguments.title)#</a>';
		return link;
	}

	public string function createHref(required any content, string queryString=""){
		var href=arguments.content.getURLTitlePath();

		return href;
	}


</cfscript>
</cfcomponent>