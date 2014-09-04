<cfparam name="rc.stockReceiver" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.stockReceiver#" edit="#rc.edit#">
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.stockReceiver#" property="packingSlipNumber" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.stockReceiver#" property="boxCount" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>