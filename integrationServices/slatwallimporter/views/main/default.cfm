<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />
<cfparam name="rc.integration" type="any">
<cfparam name="rc.sampleCsvFilesOptions" type="any">

<cfoutput>
   
    <hb:HibachiEntityActionBar pageTitle="Slatwall Importer" type="detail" object="#rc.integration#" showcancel="false" showbackAction="false" showcreate="false" showedit="false" showdelete="false">
        <hb:HibachiProcessCaller entity="#rc.integration#" action="slatwallimporter:main.preprocessintegration" processContext="importcsv" type="list" icon="upload icon-white" modal="true" />
    </hb:HibachiEntityActionBar>
   
    <hb:HibachiPropertyRow>
   	    <hb:HibachiPropertyList>
		    <cfloop array="#rc.sampleCsvFilesOptions#" item="local.option">
		        <a href="#local.option.value#"> Download Sample #local.option.name# </a>
		        </br>
		   </cfloop> 
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
	
</cfoutput>