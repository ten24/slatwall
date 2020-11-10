<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.schedule" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.schedule#" property="scheduleName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.schedule#" property="recuringType" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.schedule#" property="frequencyStartTime" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.schedule#" property="frequencyEndTime" edit="#rc.edit#">
			
			<hb:HibachiDisplayToggle selector="input[name='frequencyEndTime']" showValues="*" loadVisable="#len(rc.schedule.getValueByPropertyIdentifier('frequencyEndTime'))#">
				<hb:HibachiPropertyDisplay object="#rc.schedule#" property="frequencyInterval" edit="#rc.edit#">
			</hb:HibachiDisplayToggle>
		</hb:HibachiPropertyList>
		
		<hb:HibachiPropertyList divClass="col-md-6">
			
			<hb:HibachiDisplayToggle selector="select[name='recuringType']" showValues="weekly" loadVisable="#rc.schedule.getValueByPropertyIdentifier('recuringType') eq 'weekly'#">
				<hb:HibachiPropertyDisplay object="#rc.schedule#" property="daysOfWeekToRun" edit="#rc.edit#">
			</hb:HibachiDisplayToggle>
			<hb:HibachiDisplayToggle selector="select[name='recuringType']" showValues="monthly" loadVisable="#rc.schedule.getValueByPropertyIdentifier('recuringType') eq 'monthly'#">
				<hb:HibachiPropertyDisplay object="#rc.schedule#" property="daysOfMonthToRun" edit="#rc.edit#">	
			</hb:HibachiDisplayToggle>
		</hb:HibachiPropertyList>
		
	</hb:HibachiPropertyRow>
</cfoutput>