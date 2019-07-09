<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwType">
    <Columns>
        <column name="typeID" fieldtype="id" />
        <column name="typeIDPath" />
        <column name="parentTypeID" />
        <column name="typeCode" update="false" />
        <column name="typeName"  update="false" />
        <column name="typeDescription"  update="false" />
        <column name="systemCode" update="false" />
        <column name="sortOrder" update="false" />
        <column name="childRequiresSystemCodeFlag" datatype="bit" />
    </Columns>
    <Records>
        
        <Record typeID="2c9180866b4d105e016b4e23aee70027" typeIDPath="444df2b3df09f67ddcb27918f02c2d83,2c9180866b4d105e016b4e23aee70027" parentTypeID="444df2b3df09f67ddcb27918f02c2d83" typeName="Received" systemCode="ostProcessing" sortOrder="9" typeCode="rmaReceived" typeDescription="An order delivery/fulfillment has been created and entered but is unfulfilled" />
		<Record typeID="2c9180866b4d105e016b4e25bf350028" typeIDPath="444df2b3df09f67ddcb27918f02c2d83,2c9180866b4d105e016b4e25bf350028" parentTypeID="444df2b3df09f67ddcb27918f02c2d83" typeName="Approved" systemCode="ostProcessing" sortOrder="10" typeCode="rmaApproved" typeDescription="Order delivery items were approved, confirmed, and updated as fulfilled." />
		<Record typeID="2c9180866b4d105e016b4e2666760029" typeIDPath="444df2b3df09f67ddcb27918f02c2d83,2c9180866b4d105e016b4e2666760029" parentTypeID="444df2b3df09f67ddcb27918f02c2d83" typeName="Released" systemCode="ostClosed" sortOrder="11" typeCode="rmaReleased" typeDescription="RMA return order closed" />
		<Record typeID="2c9280846bd1f0d8016bd217dc1d002e" typeIDPath="444df2b3df09f67ddcb27918f02c2d83,2c9280846bd1f0d8016bd217dc1d002e" parentTypeID="444df2b3df09f67ddcb27918f02c2d83" typeName="Payment Declined" systemCode="ostPaymentDeclined" sortOrder="12" typeCode="" typeDescription="The order has been placed but payment was declined" />
        
		<Record typeID="2c9280846a023949016a0299578c000d" typeIDPath="2c9280846a023949016a028c33ff000b,2c9280846a023949016a0299578c000d" parentTypeID="2c9280846a023949016a028c33ff000b" typeName="Too Much Flexship" typeDescription="I have too much product from my last Flexship" systemCode="otsdcrtTooMuchFlexship" sortOrder="1" />
		<Record typeID="2c9280846a023949016a02a03eb5000e" typeIDPath="2c9280846a023949016a028c33ff000b,2c9280846a023949016a02a03eb5000e" parentTypeID="2c9280846a023949016a028c33ff000b" typeName="Too Expensive" typeDescription="I don't have the budget right now" systemCode="otsdcrtTooExpensive"  sortOrder="2" />
		<Record typeID="2c9280846a023949016a02a18939000f" typeIDPath="2c9280846a023949016a028c33ff000b,2c9280846a023949016a02a18939000f" parentTypeID="2c9280846a023949016a028c33ff000b" typeName="Not Needed" typeDescription="I do not intend to purchase right now" systemCode="otsdcrtNotNeeded"  sortOrder="3" />
		<Record typeID="2c9280846a023949016a02a2571b0010" typeIDPath="2c9280846a023949016a028c33ff000b,2c9280846a023949016a02a2571b0010" parentTypeID="2c9280846a023949016a028c33ff000b" typeName="Only For You Product Not Wanted" typeDescription="I don't want this month's Only For You product" systemCode="otsdcrtOnlyForYouNotWanted" sortOrder="4" />
		<Record typeID="2c9280846a023949016a02a3ab690011" typeIDPath="2c9280846a023949016a028c33ff000b,2c9280846a023949016a02a3ab690011" parentTypeID="2c9280846a023949016a028c33ff000b" typeName="Already Purchased Flexship Item" typeDescription="I recently purchased product through a Flash Sale or order that wasn't my Flexship" systemCode="otsdcrtAlreadyPurchased"  sortOrder="5" />

		<Record typeID="2c9680846ab15673016ab163db3a0006" typeIDPath="2c9480846a9e35d1016a9e5463c10006,2c9680846ab15673016ab163db3a0006" parentTypeID="2c9480846a9e35d1016a9e5463c10006" typeName="Too Much Product" typeDescription="I have too much product from my last Flexship" systemCode="otcrtTooMuchProduct" sortOrder="1" />
		<Record typeID="2c9680846ab15673016ab165e2740007" typeIDPath="2c9480846a9e35d1016a9e5463c10006,2c9680846ab15673016ab165e2740007" parentTypeID="2c9480846a9e35d1016a9e5463c10006" typeName="Too Expensive" typeDescription="I can't afford it right now, but plan to be back soon" systemCode="otcrtTooExpensive" sortOrder="2" />
		<Record typeID="2c9680846ab15673016ab1698cd20008" typeIDPath="2c9480846a9e35d1016a9e5463c10006,2c9680846ab15673016ab1698cd20008" parentTypeID="2c9480846a9e35d1016a9e5463c10006" typeName="Not Interested" typeDescription="Monat isn't for me and I intend to cancel" systemCode="otcrtNotInterested" sortOrder="3" />
		<Record typeID="2c9680846ab15673016ab16bf9d70009" typeIDPath="2c9480846a9e35d1016a9e5463c10006,2c9680846ab15673016ab16bf9d70009" parentTypeID="2c9480846a9e35d1016a9e5463c10006" typeName="Not Interested in Only For You" typeDescription="This month's Only For You product isn't for me" systemCode="otcrtNotInterestedOnlyForYou" sortOrder="4" />
		<Record typeID="2c9680846ab15673016ab16dcc2c000a" typeIDPath="2c9480846a9e35d1016a9e5463c10006,2c9680846ab15673016ab16dcc2c000a" parentTypeID="2c9480846a9e35d1016a9e5463c10006" typeName="Too Much Product Flash Sale" typeDescription="I stocked up during a recent Flash Sale" systemCode="otcrtTooMuchProductFlashSale" sortOrder="5" />
		<Record typeID="2c9680846ab15673016ab170cb9a000b" typeIDPath="2c9480846a9e35d1016a9e5463c10006,2c9680846ab15673016ab170cb9a000b" parentTypeID="2c9480846a9e35d1016a9e5463c10006" typeName="Unsure Of Next Order" typeDescription="I'm not sure what to order next" systemCode="otcrtUnsureOfNextOrder" sortOrder="6" />
		
	</Records>
</Table>
