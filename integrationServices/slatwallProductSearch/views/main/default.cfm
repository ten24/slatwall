<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.integration" type="any">

<cfoutput>
    
    <hb:HibachiEntityActionBar pageTitle="#rc.integration.getDisplayName()#" type="detail" object="#rc.integration#" showcancel="false" showback="false" showcreate="false" showedit="false" showdelete="false">
    	<cfif $.slatwall.getAccount().getSuperUserFlag() EQ true >
    	    <hb:HibachiActionCaller action="slatwallProductSearch:main.reBuildIndex">
    	</cfif>
    </hb:HibachiEntityActionBar>
    
    show some meaningful data here
    
</cfoutput>