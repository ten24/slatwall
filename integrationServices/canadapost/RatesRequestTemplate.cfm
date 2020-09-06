<?xml version="1.0" ?>
<!DOCTYPE eparcel SYSTEM "eParcel.dtd">
<eparcel>
	<language>en</language>
	<ratesAndServicesRequest>
		<merchantCPCID>#setting('CPCID')#</merchantCPCID>
		<lineItems>
			<item>
				<quantity>1</quantity>
				<weight>#arguments.requestBean.getTotalWeight()#</weight>
				<length>2</length>
				<width>1</width>
				<height>1</height>
				<description>Cart Items</description>
			</item>
		</lineItems>
		<city>#arguments.requestBean.getShipToCity()#</city>
		<provOrState>#arguments.requestBean.getShipToStateCode()#</provOrState>
		<country>#arguments.requestBean.getShipToCountryCode()#</country>
		<postalCode>#arguments.requestBean.getShipToPostalCode()#</postalCode>
	</ratesAndServicesRequest>
</eparcel>