<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.batch" type="any" />
<cfparam name="rc.edit" type="boolean" default="false" />
<cfoutput>
    
    <hb:HibachiTabGroup tabLocation="top" activeTab="entityQueue">
        <!--- Tabs for Adding Sale Order Items Sku and Stock --->
        <hb:HibachiTab tabid="entityQueue" lazyLoad="false" view="admin:entity/batchtabs/batchItems_queue" text="#$.slatwall.rbKey('entity.entityqueue')#" />
        <hb:HibachiTab tabid="soiaddpromotionsku" lazyLoad="true" view="admin:entity/batchtabs/batchItems_failure" text="#$.slatwall.rbKey('define.failure')#" />
    </hb:HibachiTabGroup>
   
</cfoutput>
