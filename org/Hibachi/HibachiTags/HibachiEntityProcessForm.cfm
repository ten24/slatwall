<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.entity" type="any" />
	<cfparam name="attributes.disableProcess" type="boolean" default="false" />
	<cfparam name="attributes.disableProcessText" type="string" default="" />
	<cfparam name="attributes.processAction" type="string" default="#request.context.entityActionDetails.processaction#" />
	<cfparam name="attributes.processActionQueryString" type="string" default="" />
	<cfparam name="attributes.processActionHash" type="string" default="" />
	<cfparam name="attributes.processContext" type="string" default="#request.context.processcontext#" />
	<cfparam name="attributes.enctype" type="string" default="application/x-www-form-urlencoded">
	<cfparam name="attributes.sRedirectURL" type="string" default="#request.context.entityActionDetails.sRedirectURL#">
	<cfparam name="attributes.sRedirectAction" type="string" default="#request.context.entityActionDetails.sRedirectAction#">
	<cfparam name="attributes.sRenderItem" type="string" default="#request.context.entityActionDetails.sRenderItem#">
	<cfparam name="attributes.fRedirectURL" type="string" default="#request.context.entityActionDetails.fRedirectURL#">
	<cfparam name="attributes.fRedirectAction" type="string" default="#request.context.entityActionDetails.fRedirectAction#">
	<cfparam name="attributes.fRenderItem" type="string" default="#request.context.entityActionDetails.fRenderItem#">
	<cfparam name="attributes.sRedirectQS" type="string" default="#request.context.entityActionDetails.sRedirectQS#">
	<cfparam name="attributes.fRedirectQS" type="string" default="#request.context.entityActionDetails.fRedirectQS#">
	<cfparam name="attributes.forceSSLFlag" type="boolean" default="false" />
	
	<cfset formAction ="">
	
	<cfif attributes.forceSSLFlag AND (findNoCase("off", CGI.HTTPS) OR NOT CGI.SERVER_PORT_SECURE)>
		<cfset formAction &= "https://#cgi.SERVER_NAME##attributes.hibachiScope.getApplicationValue('baseURL')#/" >
	</cfif>
	
	<cfset formAction &= "?s=1" />
	
	<cfif len(attributes.processActionQueryString)>
		<cfset formAction &= "&#attributes.processActionQueryString#" />
	</cfif>

	<cfif len(attributes.processActionHash)>
		<cfset formAction &= "###attributes.processActionHash#" />
	</cfif>

	<cfoutput>
		<form method="post" action="#formAction#" class="form-horizontal" enctype="#attributes.enctype#" id="#replaceNoCase(replaceNoCase(lcase(attributes.processAction),':','','all'),'.','','all')#_#lcase(attributes.processContext)#">
			<input type="hidden" name="#request.context.fw.getAction()#" value="#attributes.processAction#" />
			<input type="hidden" name="processContext" value="#attributes.processContext#" />
			<input type="hidden" name="#attributes.entity.getPrimaryIDPropertyName()#" value="#attributes.entity.getPrimaryIDValue()#" />
			<input type="hidden" name="preProcessDisplayedFlag" value="1" />
			<cfif len(attributes.sRedirectURL)><input type="hidden" name="sRedirectURL" value="#attributes.sRedirectURL#" /></cfif>
			<cfif len(attributes.sRedirectAction)><input type="hidden" name="sRedirectAction" value="#attributes.sRedirectAction#" /></cfif>
			<cfif len(attributes.sRenderItem)><input type="hidden" name="sRenderItem" value="#attributes.sRenderItem#" /></cfif>
			<cfif len(attributes.sRedirectQS)><input type="hidden" name="sRedirectQS" value="#attributes.sRedirectQS#" /></cfif>
			<cfif len(attributes.fRedirectURL)><input type="hidden" name="fRedirectURL" value="#attributes.fRedirectURL#" /></cfif>
			<cfif len(attributes.fRedirectAction)><input type="hidden" name="fRedirectAction" value="#attributes.fRedirectAction#" /></cfif>
			<cfif len(attributes.fRenderItem)><input type="hidden" name="fRenderItem" value="#attributes.fRenderItem#" /></cfif>
			<cfif len(attributes.fRedirectQS)><input type="hidden" name="fRedirectQS" value="#attributes.fRedirectQS#" /></cfif>

			<!--- Additional Model Header --->
			<cfif structKeyExists(request.context, "modal") and request.context.modal>
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<a class="close" data-dismiss="modal">&times;</a>
							<h3>#request.context.pageTitle#</h3>
						</div>
						<div class="modal-body">
			</cfif>
			<!--- END: Additional Model Header --->

	</cfoutput>
<cfelse>
	<cfoutput>

			<!--- Additional Model Footer --->
			<cfif structKeyExists(request.context, "modal") and request.context.modal>
					</div>
					<div class="modal-footer">
						<cfif attributes.edit>
							<a href="##" class="btn btn-default s-remove" data-dismiss="modal"><span class="glyphicon glyphicon-remove icon-white"></span> #attributes.hibachiScope.rbKey('define.cancel')#</a>
							<hb:HibachiActionCaller type="button" action="##" class="btn btn-success" icon="ok icon-white" text="#attributes.hibachiScope.rbKey( 'entity.#attributes.entity.getClassName()#.process.#attributes.processContext#' )#" disabled="#attributes.disableProcess#" disabledText="#attributes.disableProcessText#">
						</cfif>
					</div>
				</div>
			</div>
			</cfif>
			<!--- END: Additional Model Footer --->

		</form>
	</cfoutput>
</cfif>
