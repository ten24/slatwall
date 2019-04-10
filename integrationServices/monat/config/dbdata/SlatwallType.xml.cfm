<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwType">
    <Columns>
        <column name="typeID" fieldtype="id" />
        <column name="typeIDPath" />
        <column name="parentTypeID" />
        <column name="typeName"  update="false" />
        <column name="typeDescription"  update="false" />
        <column name="systemCode" update="false" />
        <column name="sortOrder" update="false" />
        <column name="childRequiresSystemCodeFlag" datatype="bit" />
    </Columns>
    <Records>

		<Record typeID="2c9280846a023949016a0299578c000d" typeIDPath="2c9280846a023949016a028c33ff000b,2c9280846a023949016a0299578c000d" parentTypeID="2c9280846a023949016a028c33ff000b" typeName="Too Much Flexship" typeDescription="I have too much product from my last Flexship" systemCode="otsdcrtTooMuchFlexship" sortOrder="1" />
		<Record typeID="2c9280846a023949016a02a03eb5000e" typeIDPath="2c9280846a023949016a028c33ff000b,2c9280846a023949016a02a03eb5000e" parentTypeID="2c9280846a023949016a028c33ff000b" typeName="Too Expensive" typeDescription="I don't have the budget right now" systemCode="otsdcrtTooExpensive"  sortOrder="2" />
		<Record typeID="2c9280846a023949016a02a18939000f" typeIDPath="2c9280846a023949016a028c33ff000b,2c9280846a023949016a02a18939000f" parentTypeID="2c9280846a023949016a028c33ff000b" typeName="Not Needed" typeDescription="I do not intend to purchase right now" systemCode="otsdcrtNotNeeded"  sortOrder="3" />
		<Record typeID="2c9280846a023949016a02a2571b0010" typeIDPath="2c9280846a023949016a028c33ff000b,2c9280846a023949016a02a2571b0010" parentTypeID="2c9280846a023949016a028c33ff000b" typeName="Only For You Product Not Wanted" typeDescription="I don't want this month's Only For You product" systemCode="otsdcrtOnlyForYouNotWanted" sortOrder="4" />
		<Record typeID="2c9280846a023949016a02a3ab690011" typeIDPath="2c9280846a023949016a028c33ff000b,2c9280846a023949016a02a3ab690011" parentTypeID="2c9280846a023949016a028c33ff000b" typeName="Already Purchased Flexship Item" typeDescription="I recently purchased product through a Flash Sale or order that wasn't my Flexship" systemCode="otsdcrtAlreadyPurchased"  sortOrder="5" />

	</Records>
</Table>
