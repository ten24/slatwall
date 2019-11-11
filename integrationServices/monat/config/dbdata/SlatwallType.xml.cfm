<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwType">
    <Columns>
        <column name="typeID" fieldtype="id" />
        <column name="typeIDPath" />
        <column name="parentTypeID" />
        <column name="typeCode" update="false" />
        <column name="typeName"  update="false" />
        <column name="typeDescription"  update="false" />
        <column name="systemCode" update="true" />
        <column name="sortOrder" update="false" />
        <column name="childRequiresSystemCodeFlag" datatype="bit" />
    </Columns>
    <Records>
        
        <Record typeID="2c9180866b4d105e016b4e23aee70027" typeIDPath="444df2b3df09f67ddcb27918f02c2d83,2c9180866b4d105e016b4e23aee70027" parentTypeID="444df2b3df09f67ddcb27918f02c2d83" typeName="Received" systemCode="ostProcessing" sortOrder="9" typeCode="rmaReceived" typeDescription="An order delivery/fulfillment has been created and entered but is unfulfilled" />
		<Record typeID="2c9180866b4d105e016b4e25bf350028" typeIDPath="444df2b3df09f67ddcb27918f02c2d83,2c9180866b4d105e016b4e25bf350028" parentTypeID="444df2b3df09f67ddcb27918f02c2d83" typeName="Approved" systemCode="ostProcessing" sortOrder="10" typeCode="rmaApproved" typeDescription="Order delivery items were approved, confirmed, and updated as fulfilled." />
		<Record typeID="2c9180866b4d105e016b4e2666760029" typeIDPath="444df2b3df09f67ddcb27918f02c2d83,2c9180866b4d105e016b4e2666760029" parentTypeID="444df2b3df09f67ddcb27918f02c2d83" typeName="Released" systemCode="ostClosed" sortOrder="11" typeCode="rmaReleased" typeDescription="RMA return order closed" />
        
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


		<Record typeID="2c9580846b042a78016b052d7d34000b" typeIDPath="2c9580846b042a78016b052d7d34000b" parentTypeID="NULL" typeName="Order Return Reason Types" systemCode="orderReturnReasonType" childRequiresSystemCodeFlag="1" /> 
		<Record typeID="30c16e7d545c406ca9f89b6f4f839938" typeIDPath="2c9580846b042a78016b052d7d34000b,30c16e7d545c406ca9f89b6f4f839938" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Address Correction" systemCode="orrtAddressCorrection" sortOrder="1" />
		<Record typeID="a86b0b6997a245c4945ed881ca12c7e8" typeIDPath="2c9580846b042a78016b052d7d34000b,a86b0b6997a245c4945ed881ca12c7e8" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Missing Item(s)" systemCode="orrtItemMissing" sortOrder="2" />
		<Record typeID="09bd4c63a7c540028a6a9b8b23cfca6d" typeIDPath="2c9580846b042a78016b052d7d34000b,09bd4c63a7c540028a6a9b8b23cfca6d" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Dissatisfied - Buyer's Remorse" systemCode="orrtDissatisfied" sortOrder="3" />
		<Record typeID="fb340d2ee9a14a928b2940a37acc9065" typeIDPath="2c9580846b042a78016b052d7d34000b,fb340d2ee9a14a928b2940a37acc9065" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Annual MP Renewal Fee Refund" systemCode="orrtRefundMPRenewal" sortOrder="4" />
		<Record typeID="e53f64802bb0487793ba7592a348af9e" typeIDPath="2c9580846b042a78016b052d7d34000b,e53f64802bb0487793ba7592a348af9e" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Non-Received - Delivered" systemCode="orrtNonReceivedDelivered" sortOrder="5" />
		<Record typeID="d73bb2817e5c4feabe294227f61fb6c5" typeIDPath="2c9580846b042a78016b052d7d34000b,d73bb2817e5c4feabe294227f61fb6c5" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Wrong/Incorrect Order Received" systemCode="orrtIncorrectOrderDelivered" sortOrder="6" />
		<Record typeID="facc996320294d16ab048f8bfd4bd86b" typeIDPath="2c9580846b042a78016b052d7d34000b,facc996320294d16ab048f8bfd4bd86b" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Account Cancellation" systemCode="orrtAccountCancellation" sortOrder="7" />
		<Record typeID="12dc69b7052642d3a215aa8a28ada0d1" typeIDPath="2c9580846b042a78016b052d7d34000b,12dc69b7052642d3a215aa8a28ada0d1" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Returned Without RMA" systemCode="orrtNoRMA" sortOrder="8" />
		<Record typeID="0a572d25abe943c78f0ede17259736ad" typeIDPath="2c9580846b042a78016b052d7d34000b,0a572d25abe943c78f0ede17259736ad" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Order Refused" systemCode="orrtOrderRefused" sortOrder="9" />
		<Record typeID="f6085b6e598d43dba8901f46ebeb5b03" typeIDPath="2c9580846b042a78016b052d7d34000b,f6085b6e598d43dba8901f46ebeb5b03" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="System Issues" systemCode="orrtSystemIssue" sortOrder="10" />
		<Record typeID="5cfbae08ad034c92a3efb50dd32a9ae6" typeIDPath="2c9580846b042a78016b052d7d34000b,5cfbae08ad034c92a3efb50dd32a9ae6" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Chargeback" systemCode="orrtChargeback" sortOrder="11" />
		<Record typeID="7550d2f3ad3a4c998ec2fe91f4111be1" typeIDPath="2c9580846b042a78016b052d7d34000b,7550d2f3ad3a4c998ec2fe91f4111be1" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Damaged Item(s)" systemCode="orrtItemDamaged" sortOrder="12" />
		<Record typeID="a889c92e6992461f8c85bba4cede8d41" typeIDPath="2c9580846b042a78016b052d7d34000b,a889c92e6992461f8c85bba4cede8d41" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Shipping SKU Refund" systemCode="orrtRefundShipping" sortOrder="13" />
		<Record typeID="9f7700e1b8ba4872bdb6c18bd075cd42" typeIDPath="2c9580846b042a78016b052d7d34000b,9f7700e1b8ba4872bdb6c18bd075cd42" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Defective Item(s)" systemCode="orrtItemDefective" sortOrder="14" />
		<Record typeID="73f1067e812646379caba580a57c57b6" typeIDPath="2c9580846b042a78016b052d7d34000b,73f1067e812646379caba580a57c57b6" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Early Termination Fee Refund" systemCode="orrtRefundEarlyTermination" sortOrder="15" />
		<Record typeID="1d0bfd28093a4435a73e3c9875b59bdd" typeIDPath="2c9580846b042a78016b052d7d34000b,1d0bfd28093a4435a73e3c9875b59bdd" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="MP Upgrade Credit (VIP Registration Refund)" systemCode="orrtRefundVIPRegistration" sortOrder="16" />
		<Record typeID="1fa6248bb8e64850967183ec723d4f23" typeIDPath="2c9580846b042a78016b052d7d34000b,1fa6248bb8e64850967183ec723d4f23" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Too expensive" systemCode="orrtTooExpensive" sortOrder="17" />
		<Record typeID="f1c37191b248410ea50665ff382e5a03" typeIDPath="2c9580846b042a78016b052d7d34000b,f1c37191b248410ea50665ff382e5a03" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="None" systemCode="orrtNone" sortOrder="18" />
		<Record typeID="44ee74c90e714964be0a01cb45265665" typeIDPath="2c9580846b042a78016b052d7d34000b,44ee74c90e714964be0a01cb45265665" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Warehouse Cancellation Request" systemCode="orrtWarehouse" sortOrder="19" />
		<Record typeID="4e57f372d2f74d6cb679b2938d9755e7" typeIDPath="2c9580846b042a78016b052d7d34000b,4e57f372d2f74d6cb679b2938d9755e7" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Fraudulent Order" systemCode="orrtFraudulent" sortOrder="20" />
		<Record typeID="a457de199b42497296860793176a8798" typeIDPath="2c9580846b042a78016b052d7d34000b,a457de199b42497296860793176a8798" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Wrong/Incorrect Item(s)" systemCode="orrtItemIncorrect" sortOrder="21" />
		<Record typeID="bc6aadd950ff48ee9f5d71f5dda47afd" typeIDPath="2c9580846b042a78016b052d7d34000b,bc6aadd950ff48ee9f5d71f5dda47afd" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Allergic Reaction" systemCode="orrtAllergy" sortOrder="22" />
		<Record typeID="4ec6e020dee148a4b018d30f6697ebf2" typeIDPath="2c9580846b042a78016b052d7d34000b,4ec6e020dee148a4b018d30f6697ebf2" parentTypeID="2c9580846b042a78016b052d7d34000b" typeName="Non-Received - Return to Sender" systemCode="orrtNonReceivedReturnToSender" sortOrder="23" />
	</Records>
</Table>
