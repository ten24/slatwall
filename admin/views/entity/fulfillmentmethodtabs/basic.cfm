<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.fulfillmentMethod" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.fulfillmentMethod#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.fulfillmentMethod#" property="autoFulfillFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.fulfillmentMethod#" property="fulfillmentMethodName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.fulfillmentMethod#" property="fulfillmentMethodType" edit="#rc.fulfillmentMethod.isNew()#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>