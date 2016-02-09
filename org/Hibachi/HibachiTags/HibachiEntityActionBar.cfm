<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
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

			<div class="row s-body-nav">
			    <nav class="navbar navbar-default" role="navigation">
			      <div class="col-md-6 s-header-info">
						<cfif !len(attributes.pageTitle) && structKeyExists(request.context, "pageTitle")>
							<cfset attributes.pageTitle = request.context.pageTitle />
						</cfif>
						<h1 class="actionbar-title">#attributes.pageTitle#</h1>
					</div>

					<div class="col-md-6">
						<div class="btn-toolbar">

							<!--- ================ Listing =================== --->
							
							<cfif attributes.type eq "listing" >
								
								<cfparam name="request.context.keywords" default="" />

								<!--- Listing: Button Groups --->
								<cfif structKeyExists(thistag, "buttonGroups") && arrayLen(thistag.buttonGroups)>
									<cfloop array="#thisTag.buttonGroups#" index="buttonGroup">
										<cfif structKeyExists(buttonGroup, "generatedContent") && len(buttonGroup.generatedContent)>
											#buttonGroup.generatedContent#
										</cfif>
									</cfloop>
								</cfif>
								<!--- Listing: Create --->
								<cfif attributes.showCreate>
									<cfif attributes.createModal>
										<hb:HibachiActionCaller action="#attributes.createAction#" queryString="#attributes.createQueryString#" class="btn btn-primary" icon="plus icon-white" modal="true">
									<cfelse>
										<hb:HibachiActionCaller action="#attributes.createAction#" queryString="#attributes.createQueryString#" class="btn btn-primary" icon="plus icon-white">
									</cfif>
								</cfif>
								
							<!--- ================ Detail ===================== --->
							<cfelseif attributes.type eq "detail">
							
								<div class="btn-group btn-group-sm">
									<!--- Detail: Back Button --->
									<hb:HibachiActionCaller action="#attributes.backAction#" queryString="#attributes.backQueryString#" class="btn btn-default" icon="arrow-left">
	
									<!--- Detail: Actions --->
									<cfif !attributes.object.isNew() && len( trim( thistag.generatedcontent ) ) gt 1>
										<button class="btn dropdown-toggle btn-default" data-toggle="dropdown"><i class="icon-list-alt"></i> #attributes.hibachiScope.rbKey('define.actions')# <span class="caret"></span></button>
										<ul class="dropdown-menu pull-right">
											<hb:HibachiDividerHider>
												#thistag.generatedcontent#
											</hb:HibachiDividerHider>
										</ul>
									</cfif>

									<!--- Detail: Button Groups --->
									<cfif structKeyExists(thistag, "buttonGroups") && arrayLen(thistag.buttonGroups)>
										<cfloop array="#thisTag.buttonGroups#" index="buttonGroup">
											<cfif structKeyExists(buttonGroup, "generatedContent") && len(buttonGroup.generatedContent)>											
												#buttonGroup.generatedContent#
											</cfif>
										</cfloop>
									</cfif>
								</div>

								<!--- Detail: Email / Print --->
								<div class="btn-group btn-group-sm">
									<cfif arrayLen(attributes.object.getEmailTemplates()) || arrayLen(attributes.object.getPrintTemplates())>
										<!--- Email --->
										<cfif arrayLen(attributes.object.getEmailTemplates())>
											<div class="btn-group btn-group-sm">
												<a class="btn dropdown-toggle btn-default" data-toggle="dropdown" href="##"><i class="fa fa-envelope"></i></a>
												<ul class="dropdown-menu pull-right">
													<cfloop array="#attributes.object.getEmailTemplates()#" index="template">
														<hb:HibachiProcessCaller action="admin:entity.preprocessemail" entity="Email" processContext="addToQueue" queryString="emailTemplateID=#template.getEmailTemplateID()#&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&redirectAction=#request.context.slatAction#" text="#template.getEmailTemplateName()#" modal="true" modalfullwidth="true" type="list" />
													</cfloop>
												</ul>
											</div>
										</cfif>
										<!--- Print --->
										<cfif arrayLen(attributes.object.getPrintTemplates())>
											<div class="btn-group btn-group-sm">
												<a class="btn dropdown-toggle btn-default" data-toggle="dropdown" href="##"><i class="fa fa-print"></i></a>
												<ul class="dropdown-menu pull-right">
													<cfloop array="#attributes.object.getPrintTemplates()#" index="template">
														<hb:HibachiProcessCaller action="admin:entity.processprint" entity="Print" processContext="addToQueue" queryString="printTemplateID=#template.getPrintTemplateID()#&printID=&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&redirectAction=#request.context.slatAction#" text="#template.getPrintTemplateName()#" type="list" />
													</cfloop>
												</ul>
											</div>
										</cfif>
									</cfif>
								</div>
								<!--- Detail: Print --->

								<!--- Detail: Additional Button Groups --->
								<cfif structKeyExists(thistag, "buttonGroups") && arrayLen(thistag.buttonGroups)>
									<cfloop array="#thisTag.buttonGroups#" index="buttonGroup">
										<cfif structKeyExists(buttonGroup, "generatedContent") && len(buttonGroup.generatedContent)>
											#buttonGroup.generatedContent#
										</cfif>
									</cfloop>
								</cfif>

								<!--- Detail: CRUD Buttons --->
								
								<div class="btn-group btn-group-sm">
									<!--- Setup delete Details --->
									<cfset local.deleteErrors = attributes.hibachiScope.getService("hibachiValidationService").validate(object=attributes.object, context="delete", setErrors=false) />
									<cfset local.deleteDisabled = local.deleteErrors.hasErrors() />
									<cfset local.deleteDisabledText = local.deleteErrors.getAllErrorsHTML() />

									<cfif attributes.edit>
										<!--- Delete --->
										<cfif not attributes.object.isNew() and attributes.showdelete>
											<cfset attributes.deleteQueryString = listAppend(attributes.deleteQueryString, "#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#", "&") />
											<hb:HibachiActionCaller action="#attributes.deleteAction#" querystring="#attributes.deleteQueryString#" text="#attributes.hibachiScope.rbKey('define.delete')#" class="btn btn-default s-remove" icon="trash icon-white" confirm="true" disabled="#local.deleteDisabled#" disabledText="#local.deleteDisabledText#">
										</cfif>

										<!--- Cancel --->
										<cfif !len(attributes.cancelQueryString)>
											<!--- Setup default cancel query string --->
											<cfset attributes.cancelQueryString = "#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" />
										</cfif>
										<hb:HibachiActionCaller action="#attributes.cancelAction#" querystring="#attributes.cancelQueryString#" text="#attributes.hibachiScope.rbKey('define.cancel')#" class="btn btn-default" icon="remove icon-white">

										<!--- Save --->
										<hb:HibachiActionCaller action="#request.context.entityActionDetails.saveAction#" text="#attributes.hibachiScope.rbKey('define.save')#" class="btn btn-success" type="button" submit="true" icon="ok icon-white">
									<cfelse>
										<!--- Delete --->
										<cfif attributes.showdelete>
											<cfset attributes.deleteQueryString = listAppend(attributes.deleteQueryString, "#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#", "&") />
											<hb:HibachiActionCaller action="#attributes.deleteAction#" querystring="#attributes.deleteQueryString#" text="#attributes.hibachiScope.rbKey('define.delete')#" class="btn btn-default s-remove" icon="trash icon-white" confirm="true" disabled="#local.deleteDisabled#" disabledText="#local.deleteDisabledText#">
										</cfif>

										<!--- Edit --->
										<cfif attributes.showedit>
											<hb:HibachiActionCaller action="#request.context.entityActionDetails.editAction#" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" text="#attributes.hibachiScope.rbKey('define.edit')#" class="btn btn-default" icon="pencil icon-white" submit="true" disabled="#attributes.object.isNotEditable()#">
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
									<div class="btn-group btn-group-sm">
										<hb:HibachiActionCaller action="#attributes.backAction#" queryString="#attributes.backQueryString#" class="btn btn-default" icon="arrow-left">
									</div>
									<div class="btn-group btn-group-sm">
										<button type="submit" class="btn btn-primary">#attributes.hibachiScope.rbKey( "entity.#attributes.object.getClassName()#.process.#attributes.processContext#" )#</button>
									</div>
								</cfif>
							

							<!--- Clear the generated content so that it isn't rendered --->
							<cfset thistag.generatedcontent = "" />
						</div>
					</div>
				</nav>
			</div>
		</cfoutput>

		<!--- Message Display --->
		<hb:HibachiMessageDisplay />

	<cfelse>

		<!--- Message Display --->
		<hb:HibachiMessageDisplay />

		<!--- Clear the generated content so that it isn't rendered --->
		<cfset thistag.generatedcontent = "" />
	</cfif>

</cfif>
