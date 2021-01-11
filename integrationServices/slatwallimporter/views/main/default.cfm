<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.integration" type="any">
<cfparam name="rc.sampleCsvFilesIndex" type="any">

<cfoutput>
   
    <hb:HibachiEntityActionBar pageTitle="Slatwall Importer" type="detail" object="#rc.integration#" showcancel="false" showbackAction="false" showcreate="false" showedit="false" showdelete="false">
        <hb:HibachiProcessCaller entity="#rc.integration#" action="slatwallimporter:main.preprocessintegration" processContext="importcsv" type="list" icon="upload icon-white" modal="true" />
    </hb:HibachiEntityActionBar>
   
    <hb:HibachiPropertyRow>
   	    <hb:HibachiPropertyList>
		    <cfloop struct="#rc.sampleCsvFilesIndex#" item="local.entityName">
		        <br/>
		        <hb:HibachiActionCaller action="admin:slatwallImporter:main.getSampleCSV" queryString="entityName=#local.entityName#" text="Download - #local.entityName# Import Template" modal="false" type="link" target="_blank" class="btn btn-primary btn-sm" icon="download" />
		        <br/>
		   </cfloop> 
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
	
</cfoutput>