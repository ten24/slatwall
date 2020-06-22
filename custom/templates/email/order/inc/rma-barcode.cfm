<cfimport prefix="barbecue" taglib="../../../../cfbarbecue/com/adampresley/barbecue" />
<cfoutput>
     <barbecue:barcode root="custom/cfbarbecue/com/adampresley/barbecue">
        #order.getOrderNumber()#
     </barbecue:barcode>
</cfoutput>