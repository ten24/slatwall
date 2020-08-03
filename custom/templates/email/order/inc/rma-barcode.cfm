<cfimport prefix="barbecue" taglib="../../../../cfbarbecue/com/adampresley/barbecue" />

<cfoutput>
     <barbecue:barcode root="https://#CGI['http_host']#/Slatwall/custom/cfbarbecue/com/adampresley/barbecue">
        #order.getOrderNumber()#
     </barbecue:barcode>
</cfoutput>