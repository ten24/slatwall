<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />
<cfparam name="rc.integration" type="any">
<cfparam name="rc.fileslist" type="any">

<cfoutput>
   <hb:HibachiEntityActionBar type="detail" object="#rc.integration#" showcancel="false" showbackAction="false" showcreate="false" showedit="false" showdelete="false">
      <hb:HibachiProcessCaller entity="#rc.integration#" action="slatwallimporter:main.preprocessintegratoin" processContext="importcsv" type="list" modal="true" />
   </hb:HibachiEntityActionBar>
   <hb:HibachiPropertyRow>
   	<hb:HibachiPropertyList>
		    <cfloop array="#rc.fileslist#" item="filename">
		    <a href="#request.slatwallScope.getBaseUrl()#/integrationServices/#rc.integration.getIntegrationPackage()#/assets/downloadsample/#filename#">Download the #filename# Sample CSV</a></br>
		   </cfloop> 
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>