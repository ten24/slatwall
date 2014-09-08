<cfparam name="rc.fulfillmentMethod" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.fulfillmentMethod#" edit="#rc.edit#">		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.fulfillmentMethod#" property="activeFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.fulfillmentMethod#" property="fulfillmentMethodName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.fulfillmentMethod#" property="fulfillmentMethodType" edit="#rc.fulfillmentMethod.isNew()#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>