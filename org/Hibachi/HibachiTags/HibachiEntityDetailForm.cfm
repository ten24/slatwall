<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.object" type="any" />
	<cfparam name="attributes.saveAction" type="string" default="#request.context.entityActionDetails.saveaction#" />
	<cfparam name="attributes.saveActionQueryString" type="string" default="" />
	<cfparam name="attributes.saveActionHash" type="string" default="" />
	<cfparam name="attributes.edit" type="boolean" default="false" />
	<cfparam name="attributes.enctype" type="string" default="multipart/form-data">
	<cfparam name="attributes.sRedirectURL" type="string" default="#request.context.entityActionDetails.sRedirectURL#">
	<cfparam name="attributes.sRedirectAction" type="string" default="#request.context.entityActionDetails.sRedirectAction#">
	<cfparam name="attributes.sRenderItem" type="string" default="#request.context.entityActionDetails.sRenderItem#">
	<cfparam name="attributes.fRedirectURL" type="string" default="#request.context.entityActionDetails.fRedirectURL#">
	<cfparam name="attributes.fRedirectAction" type="string" default="#request.context.entityActionDetails.fRedirectAction#">
	<cfparam name="attributes.fRenderItem" type="string" default="#request.context.entityActionDetails.fRenderItem#">
	<cfparam name="attributes.sRedirectQS" type="string" default="#request.context.entityActionDetails.sRedirectQS#">
	<cfparam name="attributes.fRedirectQS" type="string" default="#request.context.entityActionDetails.fRedirectQS#">
	<cfparam name="attributes.forceSSLFlag" type="boolean" default="false" />
	
	<cfset formAction ="" />
	
	<cfif attributes.forceSSLFlag AND (findNoCase("off", CGI.HTTPS) OR NOT CGI.SERVER_PORT_SECURE)>
		<cfset formAction &= "https://#cgi.SERVER_NAME##attributes.hibachiScope.getApplicationValue('baseURL')#/" >
	</cfif>
	
	<cfset formAction &= "?s=1" />
	
	<cfif len(attributes.saveActionQueryString)>
		<cfset formAction &= "&#attributes.saveActionQueryString#" />
	</cfif>
	
	<cfif len(attributes.saveActionHash)>
		<cfset formAction &= "###attributes.saveActionHash#" />
	</cfif>
	
	<cfoutput>
		<cfif attributes.edit>			
			<form method="post" action="#formAction#" class="" enctype="#attributes.enctype#" id="#replaceNoCase(replaceNoCase(lcase(attributes.saveaction),':','','all'),'.','','all')#">
			<input type="hidden" name="#request.context.fw.getAction()#" value="#attributes.saveaction#" />
			<input type="hidden" name="#attributes.object.getPrimaryIDPropertyName()#" value="#attributes.object.getPrimaryIDValue()#" />
			<cfif len(attributes.sRedirectURL)><input type="hidden" name="sRedirectURL" value="#attributes.sRedirectURL#" /></cfif>
			<cfif len(attributes.sRedirectAction)><input type="hidden" name="sRedirectAction" value="#attributes.sRedirectAction#" /></cfif>
			<cfif len(attributes.sRenderItem)><input type="hidden" name="sRenderItem" value="#attributes.sRenderItem#" /></cfif>
			<cfif len(attributes.sRedirectQS)><input type="hidden" name="sRedirectQS" value="#attributes.sRedirectQS#" /></cfif>
			<cfif len(attributes.fRedirectURL)><input type="hidden" name="fRedirectURL" value="#attributes.fRedirectURL#" /></cfif>
			<cfif len(attributes.fRedirectAction)><input type="hidden" name="fRedirectAction" value="#attributes.fRedirectAction#" /></cfif>
			<cfif len(attributes.fRenderItem)><input type="hidden" name="fRenderItem" value="#attributes.fRenderItem#" /></cfif>
			<cfif len(attributes.fRedirectQS)><input type="hidden" name="fRedirectQS" value="#attributes.fRedirectQS#" /></cfif>
		</cfif>
		<cfif structKeyExists(request.context, "modal") and request.context.modal>
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<a class="close" data-dismiss="modal">&times;</a>
						<h3>#request.context.pageTitle#</h3>
					</div>
					<div class="modal-body">
		</cfif>
	</cfoutput>
<cfelse>
	<cfoutput>
		<cfif structKeyExists(request.context, "modal") and request.context.modal>
					</div>
					<div class="modal-footer">
						<cfif attributes.edit>
							<div class="btn-group">
								<button href="##" class="btn btn-default" data-dismiss="modal"><i class="icon-remove icon-white"></i> #attributes.hibachiScope.rbKey('define.cancel')#</button>
								<button type="submit" class="btn btn-success"><i class="icon-ok icon-white"></i> #attributes.hibachiScope.rbKey('define.save')#</button>
							</div>
						</cfif>
					</div>
				</div>
			</div>
		</cfif>
		<cfif attributes.edit>
			</form>
		</cfif>
	</cfoutput>
</cfif>
