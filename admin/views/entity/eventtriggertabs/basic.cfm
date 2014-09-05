<cfparam name="rc.eventTrigger" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.eventTrigger#" edit="#rc.edit#">		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divClass="col-md-6">
				<cf_HibachiPropertyDisplay object="#rc.eventTrigger#" property="eventTriggerName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.eventTrigger#" property="eventName" edit="#rc.edit#">
				<cfif rc.eventTrigger.getEventTriggerType() eq "email">
					<cf_HibachiPropertyDisplay object="#rc.eventTrigger#" property="emailTemplate" edit="#rc.edit#">
				</cfif>
				<cfif rc.eventTrigger.getEventTriggerType() eq "print">
					<cf_HibachiPropertyDisplay object="#rc.eventTrigger#" property="printTemplate" edit="#rc.edit#">
				</cfif>
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divClass="col-md-6">
				<cf_HibachiPropertyDisplay object="#rc.eventTrigger#" property="eventTriggerType" edit="false">
				<cf_HibachiPropertyDisplay object="#rc.eventTrigger#" property="eventTriggerObject" edit="false">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>