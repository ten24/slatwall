<cfoutput>
    <cfif not isNull(order.getNotes())>
        <div style="clear:both;">
            <h4 style="border-bottom:2px solid black;">Customer Comments</h4>
            <p>#getHibachiScope().getService('HibachiUtilityService').hibachiHTMLEditFormat(order.getNotes())#</p>
        </div>
        <div style="clear:both; height:30px;">&nbsp;</div>
    <cfelse>
        <br style="clear:both;" />
    </cfif>
</cfoutput>