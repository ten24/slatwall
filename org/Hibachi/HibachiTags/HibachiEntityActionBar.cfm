<cfif thisTag.executionMode is "start">
	<!--- Auto-Injected --->
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	
	<!--- Core settings --->
	<cfparam name="attributes.type" type="string" default="" />
	<cfparam name="attributes.object" type="any" default="" />
	<cfparam name="attributes.pageTitle" type="string" default="" />
	<cfparam name="attributes.edit" type="boolean" default="#request.context.edit#" />
	
	<!--- Action Callers (top buttons) --->
	<cfparam name="attributes.showcancel" type="boolean" default="true" />
	<cfparam name="attributes.showcreate" type="boolean" default="true" />
	<cfparam name="attributes.showedit" type="boolean" default="true" />
	<cfparam name="attributes.showdelete" type="boolean" default="true" />
	
	<!--- Basic Action Caller Overrides --->
	<cfparam name="attributes.createModal" type="boolean" default="false" />
	<cfparam name="attributes.createAction" type="string" default="#request.context.entityActionDetails.createAction#" />
	<cfparam name="attributes.createQueryString" type="string" default="" />
	
	<cfparam name="attributes.backAction" type="string" default="#request.context.entityActionDetails.backAction#" />
	<cfparam name="attributes.backQueryString" type="string" default="" />
	
	<cfparam name="attributes.cancelAction" type="string" default="#request.context.entityActionDetails.cancelAction#" />
	<cfparam name="attributes.cancelQueryString" type="string" default="" />
	
	<cfparam name="attributes.deleteAction" type="string" default="#request.context.entityActionDetails.deleteAction#" />
	<cfparam name="attributes.deleteQueryString" type="string" default="" />
	
	<!--- Process Specific Values --->
	<cfparam name="attributes.processAction" type="string" default="">
	<cfparam name="attributes.processContext" type="string" default="">
	
<cfelse>
	<cfif not structKeyExists(request.context, "modal") or not request.context.modal>
		<cfoutput>
			<div class="actionnav well well-small">
				<div class="row-fluid">
					<div class="span4">
						<!--- Page Title --->
						<cfif !len(attributes.pageTitle) && structKeyExists(request.context, "pageTitle")>
							<cfset attributes.pageTitle = request.context.pageTitle />
						</cfif>
						<h1>#attributes.pageTitle#</h1>
					</div>
					<div class="span8">
						<div class="btn-toolbar">
							
							<!--- ================ Listing =================== --->
							<cfif attributes.type eq "listing" >
								<cfparam name="request.context.keywords" default="" />
								
								<!--- Listing: Search --->
								<form name="search" class="action-bar-search btn-group" action="/" method="get">
									<input type="hidden" name="slatAction" value="#request.context.entityActionDetails.thisAction#" />
									<input type="text" name="keywords" value="#request.context.keywords#" placeholder="#attributes.hibachiScope.rbKey('define.search')# #attributes.pageTitle#" data-tableid="LD#replace(attributes.object.getSavedStateID(),'-','','all')#">
								</form>
								
								<!--- Listing: Actions --->
								<div class="btn-group">
									<button class="btn dropdown-toggle" data-toggle="dropdown"><i class="icon-list-alt"></i> #attributes.hibachiScope.rbKey('define.actions')# <span class="caret"></span></button>
									<ul class="dropdown-menu">
										<cf_HibachiActionCaller action="#request.context.entityActionDetails.exportAction#" text="#attributes.hibachiScope.rbKey('define.exportlist')#" type="list">
									</ul>
								</div>
								
								<!--- Listing: Button Groups --->
								<cfif structKeyExists(thistag, "buttonGroups") && arrayLen(thistag.buttonGroups)>
									<cfloop array="#thisTag.buttonGroups#" index="buttonGroup">
										<cfif structKeyExists(buttonGroup, "generatedContent") && len(buttonGroup.generatedContent)>
											<div class="btn-group">
												#buttonGroup.generatedContent#
											</div>
										</cfif>
									</cfloop>
								</cfif>
								
								<!--- Listing: Create --->
								<cfif attributes.showCreate>
									<div class="btn-group">
										<cfif attributes.createModal>
											<cf_HibachiActionCaller action="#attributes.createAction#" queryString="#attributes.createQueryString#" class="btn btn-primary" icon="plus icon-white" modal="true">
										<cfelse>
											<cf_HibachiActionCaller action="#attributes.createAction#" queryString="#attributes.createQueryString#" class="btn btn-primary" icon="plus icon-white">
										</cfif>
									</div>
								</cfif>
								
							<!--- ================ Detail ===================== --->
							<cfelseif attributes.type eq "detail">
								
								<!--- Detail: Back Button --->
								<div class="btn-group">
									<cf_HibachiActionCaller action="#attributes.backAction#" queryString="#attributes.backQueryString#" class="btn" icon="arrow-left">
								</div>
								
								<!--- Detail: Actions --->
								<cfif !attributes.object.isNew() && len( trim( thistag.generatedcontent ) ) gt 1>
									<div class="btn-group">
										<button class="btn dropdown-toggle" data-toggle="dropdown"><i class="icon-list-alt"></i> #attributes.hibachiScope.rbKey('define.actions')# <span class="caret"></span></button>
										<ul class="dropdown-menu pull-right">
											<cf_HibachiDividerHider>
												#thistag.generatedcontent#
											</cf_HibachiDividerHider>
										</ul>
									</div>
								</cfif>
								
								<!--- Detail: Button Groups --->
								<cfif structKeyExists(thistag, "buttonGroups") && arrayLen(thistag.buttonGroups)>
									<cfloop array="#thisTag.buttonGroups#" index="buttonGroup">
										<cfif structKeyExists(buttonGroup, "generatedContent") && len(buttonGroup.generatedContent)>
											<div class="btn-group">
												#buttonGroup.generatedContent#
											</div>
										</cfif>
									</cfloop>
								</cfif>
								
								<!--- Detail: Email / Print --->
								<cfif arrayLen(attributes.object.getEmailTemplates()) || arrayLen(attributes.object.getPrintTemplates())>
									<!--- Email --->
									<cfif arrayLen(attributes.object.getEmailTemplates())>
										<div class="btn-group">
											<a class="btn dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-envelope"></i></a>
											<ul class="dropdown-menu pull-right">
												<cfloop array="#attributes.object.getEmailTemplates()#" index="template">
													<cf_HibachiProcessCaller action="admin:entity.preprocessemail" entity="Email" processContext="addToQueue" queryString="emailTemplateID=#template.getEmailTemplateID()#&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&redirectAction=#request.context.slatAction#" text="#template.getEmailTemplateName()#" modal="true" type="list" />
												</cfloop>
											</ul>
										</div>
									</cfif>
									<!--- Print --->
									<cfif arrayLen(attributes.object.getPrintTemplates())>
										<div class="btn-group">
											<a class="btn dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-print"></i></a>
											<ul class="dropdown-menu pull-right">
												<cfloop array="#attributes.object.getPrintTemplates()#" index="template">
													<cf_HibachiProcessCaller action="admin:entity.processprint" entity="Print" processContext="addToQueue" queryString="printTemplateID=#template.getPrintTemplateID()#&printID=&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&redirectAction=#request.context.slatAction#" text="#template.getPrintTemplateName()#" type="list" />
												</cfloop>
											</ul>
										</div>
									</cfif>
								</cfif>
									
								<!--- Detail: Print --->
								
								<!--- Detail: Additional Button Groups --->
								<cfif structKeyExists(thistag, "buttonGroups") && arrayLen(thistag.buttonGroups)>
									<cfloop array="#thisTag.buttonGroups#" index="buttonGroup">
										<cfif structKeyExists(buttonGroup, "generatedContent") && len(buttonGroup.generatedContent)>
											<div class="btn-group">
												#buttonGroup.generatedContent#
											</div>
										</cfif>
									</cfloop>
								</cfif>
								
								<!--- Detail: CRUD Buttons --->
								<div class="btn-group">
									
									<!--- Setup delete Details --->
									<cfset local.deleteErrors = attributes.hibachiScope.getService("hibachiValidationService").validate(object=attributes.object, context="delete", setErrors=false) />
									<cfset local.deleteDisabled = local.deleteErrors.hasErrors() />
									<cfset local.deleteDisabledText = local.deleteErrors.getAllErrorsHTML() />
									
									<cfif attributes.edit>
										<!--- Delete --->
										<cfif not attributes.object.isNew() and attributes.showdelete>
											<cfset attributes.deleteQueryString = listAppend(attributes.deleteQueryString, "#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#", "&") />
											<cf_HibachiActionCaller action="#attributes.deleteAction#" querystring="#attributes.deleteQueryString#" text="#attributes.hibachiScope.rbKey('define.delete')#" class="btn btn-inverse" icon="trash icon-white" confirm="true" disabled="#local.deleteDisabled#" disabledText="#local.deleteDisabledText#">
										</cfif>
										
										<!--- Cancel --->
										<cfif !len(attributes.cancelQueryString)>
											<!--- Setup default cancel query string --->
											<cfset attributes.cancelQueryString = "#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" />			
										</cfif>
										<cf_HibachiActionCaller action="#attributes.cancelAction#" querystring="#attributes.cancelQueryString#" text="#attributes.hibachiScope.rbKey('define.cancel')#" class="btn btn-inverse" icon="remove icon-white">
										
										<!--- Save --->
										<cf_HibachiActionCaller action="#request.context.entityActionDetails.saveAction#" text="#attributes.hibachiScope.rbKey('define.save')#" class="btn btn-success" type="button" submit="true" icon="ok icon-white">
									<cfelse>
										<!--- Delete --->
										<cfif attributes.showdelete>
											<cfset attributes.deleteQueryString = listAppend(attributes.deleteQueryString, "#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#", "&") />
											<cf_HibachiActionCaller action="#attributes.deleteAction#" querystring="#attributes.deleteQueryString#" text="#attributes.hibachiScope.rbKey('define.delete')#" class="btn btn-inverse" icon="trash icon-white" confirm="true" disabled="#local.deleteDisabled#" disabledText="#local.deleteDisabledText#">
										</cfif>
										
										<!--- Edit --->
										<cfif attributes.showedit>
											<cf_HibachiActionCaller action="#request.context.entityActionDetails.editAction#" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" text="#attributes.hibachiScope.rbKey('define.edit')#" class="btn btn-primary" icon="pencil icon-white" submit="true" disabled="#attributes.object.isNotEditable()#">
										</cfif>
									</cfif>
								</div>
								
							<!--- ================= Process =================== --->
							<cfelseif attributes.type eq "preprocess">
								
								<cfif !len(attributes.processContext) and structKeyExists(request.context, "processContext")>
									<cfset attributes.processContext = request.context.processContext />
								</cfif>
								<cfif !len(attributes.processAction) and structKeyExists(request.context.entityActionDetails, "processAction")>
									<cfset attributes.processAction = request.context.entityActionDetails.processAction />
								</cfif>
								
								<div class="btn-group">
									<button type="submit" class="btn btn-primary">#attributes.hibachiScope.rbKey( "entity.#attributes.object.getClassName()#.process.#attributes.processContext#" )#</button>
								</div>
							</cfif>
							
							<!--- Clear the generated content so that it isn't rendered --->
							<cfset thistag.generatedcontent = "" />
						</div>
					</div>
				</div>
			</div>
		</cfoutput>
		
		<!--- Message Display --->
		<cf_HibachiMessageDisplay />
		
	<cfelse>
		
		<!--- Message Display --->
		<cf_HibachiMessageDisplay />
		
		<!--- Clear the generated content so that it isn't rendered --->
		<cfset thistag.generatedcontent = "" />
	</cfif>
	
</cfif>