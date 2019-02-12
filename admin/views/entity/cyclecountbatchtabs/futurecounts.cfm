<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.cyclecountbatch" type="any">
<cfparam name="rc.edit" type="boolean">

<cfset local.cycleCountGroups = rc.cyclecountbatch.getCycleCountGroups() />
<cfset local.daysCompleted = rc.cyclecountbatch.getPhysicalsCount() />
<cfoutput>
	<table class="table table-bordered s-detail-content-table">
		<thead>
			<tr>
				<th>Day</th>
				<cfloop array="#local.cycleCountGroups#" index="cycleCountGroup">
					<cfloop index="i" from="1" to="#cycleCountGroup.getItemCountPerDay()#">
						<th>#cycleCountGroup.getCycleCountGroupName()#</th>
					</cfloop>
				</cfloop>
				<th>Create Physical Count</th>
			</tr>
		</thead>
		<tbody>
			<cfloop index="local.day" from="1" to="#rc.cyclecountbatch.getRemainingDayCount()#">
				<cfset local.cycleCountBatchItems = rc.cyclecountbatch.getItemsToCountByDay(local.day,true) />
				<cfif arrayLen(local.cycleCountBatchItems)>
					<tr>
						<td class="primary">#local.day + local.daysCompleted#</td>
						<cfloop array="#local.cycleCountBatchItems#" index="local.cycleCountBatchItem">
							<td><cfif structKeyExists(local.cycleCountBatchItem,'skuCode')>#local.cycleCountBatchItem['skuCode']#</cfif></td>
						</cfloop>
						<td>
							<hb:HibachiProcessCaller entity="#rc.cyclecountbatch#" action="admin:entity.preprocesscyclecountbatch" processContext="physicalcount" querystring="day=#local.day#" type="link" modal="true" />
						</td>
					</tr>
				</cfif>
			</cfloop>
		</tbody>
	</table>
</cfoutput>
