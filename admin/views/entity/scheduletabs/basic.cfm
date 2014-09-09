<cfparam name="rc.schedule" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.schedule#" edit="#rc.edit#">		
		<cf_HibachiPropertyRow>
			
			<cf_HibachiPropertyList divClass="col-md-6">
				<cf_HibachiPropertyDisplay object="#rc.schedule#" property="scheduleName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.schedule#" property="recuringType" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.schedule#" property="frequencyStartTime" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.schedule#" property="frequencyEndTime" edit="#rc.edit#">
				
				<cf_HibachiDisplayToggle selector="input[name='frequencyEndTime']" showValues="*" loadVisable="#len(rc.schedule.getValueByPropertyIdentifier('frequencyEndTime'))#">
					<cf_HibachiPropertyDisplay object="#rc.schedule#" property="frequencyInterval" edit="#rc.edit#">
				</cf_HibachiDisplayToggle>
			</cf_HibachiPropertyList>
			
			<cf_HibachiPropertyList divClass="col-md-6">
				
				<cf_HibachiDisplayToggle selector="select[name='recuringType']" showValues="weekly" loadVisable="#rc.schedule.getValueByPropertyIdentifier('recuringType') eq 'weekly'#">
					<cf_HibachiPropertyDisplay object="#rc.schedule#" property="daysOfWeekToRun" edit="#rc.edit#">
				</cf_HibachiDisplayToggle>
				<cf_HibachiDisplayToggle selector="select[name='recuringType']" showValues="monthly" loadVisable="#rc.schedule.getValueByPropertyIdentifier('recuringType') eq 'monthly'#">
					<cf_HibachiPropertyDisplay object="#rc.schedule#" property="daysOfMonthToRun" edit="#rc.edit#">	
				</cf_HibachiDisplayToggle>
			</cf_HibachiPropertyList>
			
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>