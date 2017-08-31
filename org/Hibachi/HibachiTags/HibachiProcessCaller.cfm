<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	
	<cfparam name="attributes.action" type="any" />
	<cfparam name="attributes.entity" type="any" />
	<cfparam name="attributes.processContext" type="string" />
	<cfparam name="attributes.hideDisabled" type="boolean" default="true" />
	
	<cfparam name="attributes.type" type="string" default="link">
	<cfparam name="attributes.querystring" type="string" default="" />
	<cfparam name="attributes.text" type="string" default="">
	<cfparam name="attributes.title" type="string" default="">
	<cfparam name="attributes.class" type="string" default="">
	<cfparam name="attributes.icon" type="string" default="">
	<cfparam name="attributes.iconOnly" type="boolean" default="false">
	<cfparam name="attributes.submit" type="boolean" default="false">
	<cfparam name="attributes.confirm" type="boolean" default="false" />
	<cfparam name="attributes.disabled" type="boolean" default="false" />
	<cfparam name="attributes.modal" type="boolean" default="false" />
	
	<cfset local.entityName = "" />
	
	<!--- Add the process context to the query string --->
	<cfset attributes.queryString = listAppend(attributes.queryString, "processContext=#attributes.processContext#", "&") />
	
	<!--- If just an entityName was passed in, then use that as the local.entityName --->
	<cfif isSimpleValue(attributes.entity) && len(attributes.entity)>
		<cfset local.entityName = attributes.entity />	
	
	<!--- If an object was passed in then append its primaryID stuff, and also set the entityName based on the class name --->
	<cfelseif isObject(attributes.entity)>
		<cfset local.entityName = attributes.entity.getClassName() />
		
		<cfset attributes.queryString = listAppend(attributes.queryString, "#attributes.entity.getPrimaryIDPropertyName()#=#attributes.entity.getPrimaryIDValue()#", "&") />
	</cfif>
	
	<!--- If the text wasn't defined, then add it --->
	<cfif !len(attributes.text) and !attributes.iconOnly>
		<cfset attributes.text = attributes.hibachiScope.rbKey('entity.#local.entityName#.process.#attributes.processContext#') />
	</cfif>
	
	<!--- Setup the disabled attributes if this is an object --->
	<cfif isObject(attributes.entity)>
		<cfset local.processErrors = attributes.hibachiScope.getService("hibachiValidationService").validate(object=attributes.entity, context=attributes.processContext, setErrors=false) />
		<cfset attributes.disabled = local.processErrors.hasErrors() />
		<cfset attributes.disabledText = local.processErrors.getAllErrorsHTML() />
	</cfif>
	
	<!--- If either no entity object was passed in, or if the entity object that was passed in is in fact processable, then deligate to the action caller for the actual info --->
	<cfif !isObject(attributes.entity) || (isObject(attributes.entity) && ( !attributes.disabled || !attributes.hideDisabled ) )>
		<hb:HibachiActionCaller attributecollection="#attributes#" />
	</cfif>
</cfif>