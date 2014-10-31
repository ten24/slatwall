<cfparam name="rc.attributeOption" type="any">
<cfparam name="rc.attribute" type="any" default="#rc.attributeOption.getAttribute()#">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<!--- Hidden field to attach this to the attribute --->
		<input type="hidden" name="attribute.attributeID" value="#rc.attribute.getAttributeID()#" />

		<cf_HibachiPropertyDisplay object="#rc.attributeOption#" property="attributeOptionLabel" edit="#rc.edit#">
		<cf_HibachiPropertyDisplay object="#rc.attributeOption#" property="attributeOptionValue" edit="#rc.edit#">
</cfoutput>