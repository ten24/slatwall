<cfparam name="rc.promotionperiod" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.promotionperiod#" edit="#rc.edit#">
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.promotionperiod#" property="startdatetime" edit="#rc.edit#" fieldclass="noautofocus">
				<cf_HibachiPropertyDisplay object="#rc.promotionperiod#" property="enddatetime" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.promotionperiod#" property="maximumusecount" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.promotionperiod#" property="maximumaccountusecount" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>