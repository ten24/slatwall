<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.integration" type="any">
<cfparam name="rc.sampleCsvFilesIndex" type="any">

<cfoutput>
   
    <hb:HibachiEntityActionBar pageTitle="ErpOne Importer" type="detail" object="#rc.integration#" showcancel="false" showbackAction="false" showcreate="false" showedit="false" showdelete="false">
        <hb:HibachiProcessCaller entity="#rc.integration#" action="erpone:main.preprocessintegration" processContext="importerponecsv" type="list" icon="upload icon-white" modal="true" />
        <hb:HibachiProcessCaller entity="#rc.integration#" action="erpone:main.preprocessintegration" processContext="debug" type="list"  />
    </hb:HibachiEntityActionBar>
   
    <hb:HibachiPropertyRow>
   	    <hb:HibachiPropertyList>
		    <cfloop struct="#rc.sampleCsvFilesIndex#" item="local.mappingCode">
		        <br/>
		        <hb:HibachiActionCaller 
		            action="admin:erpone:main.getSampleCSV" 
		            queryString="mappingCode=#local.mappingCode#" 
		            text="Download - #rc.sampleCsvFilesIndex[local.mappingCode]# - Import Template CSV" 
		            modal="false" 
		            type="link" 
		            target="_blank" 
		            icon="download" 
		            class="btn btn-primary btn-sm" 
		        />
		        <br/>
		   </cfloop> 
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
	
</cfoutput>