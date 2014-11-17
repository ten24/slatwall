<?xml version="1.0"?><cfsilent>
<!---
	
	This template was built based on the specifications found here:
	http://support.google.com/merchants/bin/answer.py?hl=en&answer=188494&topic=2473824&ctx=topic#US
	
--->
<cfparam name="rc.skuSmartList" type="any" />
<cfsetting requesttimeout="360" />
</cfsilent><cfoutput>
<rss version="2.0" xmlns:g="http://base.google.com/ns/1.0">
	<channel>
		<title>Slatwall Product Feed</title>
		<link>http://#CGI.HTTP_HOST#</link>
		<description>Google Product Feed for http://#CGI.HTTP_HOST#</description>
		<cfloop array="#rc.skuSmartList.getRecords()#" index="local.sku"><item>
			<g:id>#htmlEditFormat(local.sku.getSkuCode())#</g:id>
			<title>#htmlEditFormat(local.sku.getProduct().getCalculatedTitle())#</title>
			<description><cfif len(local.sku.getProduct().getProductDescription())>#htmlEditFormat(local.sku.getProduct().getProductDescription())#<cfelseif len(local.sku.getProduct().getProductType().getProductTypeDescription())>#htmlEditFormat(local.sku.getProduct().getProductType().getProductTypeDescription())#</cfif></description>
			<g:google_product_category></g:google_product_category>
			<g:product_type>#htmlEditFormat(local.sku.getProduct().getProductType().getSimpleRepresentation())#</g:product_type>
			<link>http://#CGI.HTTP_HOST##local.sku.getProduct().getProductURL()#</link>
			<g:image_link>http://#CGI.HTTP_HOST##local.sku.getResizedImagePath()#</g:image_link>
			<cfloop array="#local.sku.getProduct().getProductImages()#" index="local.image"><g:additional_image_link>http://#CGI.HTTP_HOST##local.image.getResizedImagePath()#</g:additional_image_link></cfloop>
			<g:condition>new</g:condition>
			<g:availability>in stock</g:availability>
			<g:price>#local.sku.getProduct().getPrice()#</g:price>
			<cfif local.sku.getPrice() gt local.sku.getSalePrice()>
			<g:sale_price>#local.sku.getSalePrice()#</g:sale_price>
			<g:sale_price_effective_date>#dateFormat(now(), "YYYY-MM-DD")#T#timeFormat(now(), "HH:mm:ss")#-#getTimeZoneInfo().utcHourOffset#/#dateFormat(local.sku.getSalePriceExpirationDateTime(), "YYYY-MM-DD")#T#timeFormat(local.sku.getSalePriceExpirationDateTime(), "HH:mm:ss")#-#getTimeZoneInfo().utcHourOffset#</g:sale_price_effective_date>	
			</cfif>
			<cfif not isNull(local.sku.getProduct().getBrand())><g:brand>#htmlEditFormat(local.sku.getProduct().getBrand().getBrandName())#</g:brand></cfif>
			<!---
			<g:gtin></g:gtin>
			<g:mpn></g:mpn>
			<g:gender></g:gender>
			<g:age_group></g:age_group>
			--->
			<g:item_group_id>#htmlEditFormat(local.sku.getProduct().getProductCode())#</g:item_group_id>
			<!---
			<g:color></g:color>
			<g:size></g:size>
			<g:material></g:material>
			<g:pattern></g:pattern>
			<g:tax>
			   <g:country></g:country>
			   <g:region></g:region>
			   <g:rate></g:rate>
			   <g:tax_ship></g:tax_ship>
			</g:tax>
			<g:shipping>
			   <g:country></g:country>
			   <g:region></g:region>
			   <g:service></g:service>
			   <g:price></g:price>
			</g:shipping>
			--->
			<g:shipping_weight>#local.sku.setting('skuShippingWeight')# #local.sku.setting('skuShippingWeightUnitCode')#</g:shipping_weight>
			<!---
			<g:online_only></g:online_only>
			--->
		</item>
		</cfloop>
	</channel>
</rss>
</cfoutput>