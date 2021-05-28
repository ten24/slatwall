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
   	        
   	        <hb:HibachiActionCaller 
	            action="admin:erpone:main.importAccunts" 
	            text="Import Accounts" 
	            modal="false" 
	            type="link" 
	            icon="download" 
	            class="btn btn-primary btn-sm" 
	        />
	        
	        <hb:HibachiActionCaller 
	            action="admin:erpone:main.importInventoryItems" 
	            text="Import Inventory" 
	            modal="false" 
	            type="link" 
	            icon="download" 
	            class="btn btn-primary btn-sm" 
	        />
		    
	        <hb:HibachiActionCaller 
	            action="admin:erpone:main.importOrders" 
	            text="Import Orders" 
	            modal="false" 
	            type="link" 
	            icon="download" 
	            class="btn btn-primary btn-sm" 
	        />
	        
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
	
</cfoutput>