<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderTemplate" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<sw-order-template-items data-order-template="#rc.orderTemplate.getEncodedJsonRepresentation()#" data-edit="#rc.edit#"></sw-order-template-items>
</cfoutput>	

