<cfset $.slatwall = request.slatwallScope />

<!--- Setup the product --->
<cfparam name="url.productID" default="" />
<cfset $.slatwall.setProduct( $.slatwall.getEntity('Product', url.productID) ) />
 
<cfinclude template="../../public/views/templates/slatwall-product.cfm" >