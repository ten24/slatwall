<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwType">
	<Columns>
		<column name="typeID" fieldtype="id" />
		<column name="typeIDPath" />
		<column name="parentTypeID" />
		<column name="typeName" update="false" />
		<column name="typeDescription" update="false" />
		<column name="systemCode" update="false" />
		<column name="sortOrder" update="false" />
		<column name="childRequiresSystemCodeFlag" datatype="bit" />
	</Columns>
	<Records>
		<Record typeID="443df29db643e69a26c071dabe619e8a" typeIDPath="443df29db643e69a26c071dabe619e8a" parentTypeID="NULL" typeName="Account Government Identification" systemCode="accountGovernmentIdType" />
		<Record typeID="443df29eaef3cfd1af021d4d31205328" typeIDPath="443df29db643e69a26c071dabe619e8a,443df29eaef3cfd1af021d4d31205328" parentTypeID="443df29db643e69a26c071dabe619e8a" typeName="Social Security" systemCode="agitSSN" sortOrder="1" />
		<Record typeID="443df29ff763bac292f9aba2d3debafb" typeIDPath="443df29db643e69a26c071dabe619e8a,443df29ff763bac292f9aba2d3debafb" parentTypeID="443df29db643e69a26c071dabe619e8a" typeName="Drivers License" systemCode="agitDriversLicense" sortOrder="2" />
		<Record typeID="443df29ff763bac292f9aba2d3debafc" typeIDPath="443df29db643e69a26c071dabe619e8a,443df29ff763bac292f9aba2d3debafc" parentTypeID="443df29db643e69a26c071dabe619e8a" typeName="VAT" systemCode="agitVat" sortOrder="3" />

		<Record typeID="444df32cee42886828d43a685445e6a0" typeIDPath="444df32cee42886828d43a685445e6a0" parentTypeID="NULL" typeName="Account Payment Types" systemCode="accountPaymentType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df32dd2b0583d59a19f1b77869025" typeIDPath="444df32cee42886828d43a685445e6a0,444df32dd2b0583d59a19f1b77869025" parentTypeID="444df32cee42886828d43a685445e6a0" typeName="Charge" systemCode="aptCharge" sortOrder="1" />
		<Record typeID="444df32e9b448ea196c18c66e1454c46" typeIDPath="444df32cee42886828d43a685445e6a0,444df32e9b448ea196c18c66e1454c46" parentTypeID="444df32cee42886828d43a685445e6a0" typeName="Credit" systemCode="aptCredit" sortOrder="2" />
		<Record typeID="68e3fb57d8102b47acc0003906d16ddd" typeIDPath="444df32cee42886828d43a685445e6a0,68e3fb57d8102b47acc0003906d16ddd" parentTypeID="444df32cee42886828d43a685445e6a0" typeName="Adjustment" systemCode="aptAdjustment" sortOrder="3" />

		<Record typeID="444df29db643e69a26c071dabe619e8a" typeIDPath="444df29db643e69a26c071dabe619e8a" parentTypeID="NULL" typeName="Account Phone Types" systemCode="accountPhoneType" />
		<Record typeID="444df29eaef3cfd1af021d4d31205328" typeIDPath="444df29db643e69a26c071dabe619e8a,444df29eaef3cfd1af021d4d31205328" parentTypeID="444df29db643e69a26c071dabe619e8a" typeName="Home Phone" systemCode="aptHome" sortOrder="1" />
		<Record typeID="444df29ff763bac292f9aba2d3debafb" typeIDPath="444df29db643e69a26c071dabe619e8a,444df29ff763bac292f9aba2d3debafb" parentTypeID="444df29db643e69a26c071dabe619e8a" typeName="Mobile Phone" systemCode="aptMobile" sortOrder="2" />
		<Record typeID="444df2a0d49e6a3a5951a3cc1c5eefbe" typeIDPath="444df29db643e69a26c071dabe619e8a,444df2a0d49e6a3a5951a3cc1c5eefbe" parentTypeID="444df29db643e69a26c071dabe619e8a" typeName="Fax" systemCode="aptFax" sortOrder="3" />
		<Record typeID="444df2a1c6cdd58d027199dcbb5b28c9" typeIDPath="444df29db643e69a26c071dabe619e8a,444df2a1c6cdd58d027199dcbb5b28c9" parentTypeID="444df29db643e69a26c071dabe619e8a" typeName="Office Phone" systemCode="aptOffice" sortOrder="4" />

		<Record typeID="5accbf4ead7121d3672d165655626650" typeIDPath="5accbf4ead7121d3672d165655626650" parentTypeID="NULL" typeName="Account Email Types" systemCode="accountEmailType" />
		<Record typeID="5accbf4fda79a07e9f0cef97c0bde9ca" typeIDPath="5accbf4ead7121d3672d165655626650,5accbf4fda79a07e9f0cef97c0bde9ca" parentTypeID="5accbf4ead7121d3672d165655626650" typeName="Personal" systemCode="aptPersonal" sortOrder="1" />
		<Record typeID="5accbf50f8601236fca67b863193f984" typeIDPath="5accbf4ead7121d3672d165655626650,5accbf50f8601236fca67b863193f984" parentTypeID="5accbf4ead7121d3672d165655626650" typeName="Work" systemCode="aptWork" sortOrder="2" />

		<Record typeID="444df28ec3c4a84bf918671dfc179780" typeIDPath="444df28ec3c4a84bf918671dfc179780" parentTypeID="NULL" typeName="Account Relationship Types" systemCode="accountRelationshipType" />
		<Record typeID="444df28fbf77bf464b36ba66d6ab487e" typeIDPath="444df28ec3c4a84bf918671dfc179780,444df28fbf77bf464b36ba66d6ab487e" parentTypeID="444df28ec3c4a84bf918671dfc179780" typeName="Employee" systemCode="artEmployee" sortOrder="1" />
		<Record typeID="444df290c7d6c54f046eec90e2353096" typeIDPath="444df28ec3c4a84bf918671dfc179780,444df290c7d6c54f046eec90e2353096" parentTypeID="444df28ec3c4a84bf918671dfc179780" typeName="Child" systemCode="artChild" sortOrder="2" />

		<Record typeID="444df2c9cddaf8cafd6660ff320aac19" typeIDPath="444df2c9cddaf8cafd6660ff320aac19" parentTypeID="NULL" typeName="Alternate Sku Code Types" systemCode="alternateSkuCodeType" />
		<Record typeID="444df2cad53c6edae52df82f27efe892" typeIDPath="444df2c9cddaf8cafd6660ff320aac19,444df2cad53c6edae52df82f27efe892" parentTypeID="444df2c9cddaf8cafd6660ff320aac19" typeName="Vendor Sku" systemCode="asctVendor" sortOrder="1" />
		<Record typeID="444df2cb9a2a105fca15316b17287887" typeIDPath="444df2c9cddaf8cafd6660ff320aac19,444df2cb9a2a105fca15316b17287887" parentTypeID="444df2c9cddaf8cafd6660ff320aac19" typeName="Manufacture Sku" systemCode="asctManufacture" sortOrder="2" />
		<Record typeID="444df2ccfcee48604ee3e315b722dea2" typeIDPath="444df2c9cddaf8cafd6660ff320aac19,444df2ccfcee48604ee3e315b722dea2" parentTypeID="444df2c9cddaf8cafd6660ff320aac19" typeName="UPC" systemCode="asctUPC" sortOrder="3" />
		<Record typeID="444df2cd0aae29785269084d31e5922e" typeIDPath="444df2c9cddaf8cafd6660ff320aac19,444df2cd0aae29785269084d31e5922e" parentTypeID="444df2c9cddaf8cafd6660ff320aac19" typeName="EAN" systemCode="asctEAN" sortOrder="4" />

		<Record typeID="444df32f9fb5d68f03f1af307b3d0644" typeIDPath="444df32f9fb5d68f03f1af307b3d0644" parentTypeID="NULL" typeName="Content Template Types" systemCode="contentTemplateType" childRequiresSystemCodeFlag="1" />
		<Record typeID="5accbf4aaecf23ab7e2dc384d04c3943" typeIDPath="444df32f9fb5d68f03f1af307b3d0644,5accbf4aaecf23ab7e2dc384d04c3943" parentTypeID="444df32f9fb5d68f03f1af307b3d0644" typeName="Barrier Page" systemCode="cttBarrierPage" sortOrder="1" />
		<Record typeID="444df332f3988ad0c802b83361f99a01" typeIDPath="444df32f9fb5d68f03f1af307b3d0644,444df332f3988ad0c802b83361f99a01" parentTypeID="444df32f9fb5d68f03f1af307b3d0644" typeName="Brand" systemCode="cttBrand" sortOrder="2" />
		<Record typeID="444df330fc19e5beb17ff974ac03db18" typeIDPath="444df32f9fb5d68f03f1af307b3d0644,444df330fc19e5beb17ff974ac03db18" parentTypeID="444df32f9fb5d68f03f1af307b3d0644" typeName="Product" systemCode="cttProduct" sortOrder="3" />
		<Record typeID="444df331c2c2c3b093212519e8c1ae8b" typeIDPath="444df32f9fb5d68f03f1af307b3d0644,444df331c2c2c3b093212519e8c1ae8b" parentTypeID="444df32f9fb5d68f03f1af307b3d0644" typeName="Product Type" systemCode="cttProductType" sortOrder="4" />
		<Record typeID="444df331c2c2c3b093212519e8c1ae8d" typeIDPath="444df32f9fb5d68f03f1af307b3d0644,444df331c2c2c3b093212519e8c1ae8d" parentTypeID="444df32f9fb5d68f03f1af307b3d0644" typeName="Address" systemCode="cttAddress" sortOrder="5" />
		<Record typeID="444df331c2c2c3b093212519e8c1ae8f" typeIDPath="444df32f9fb5d68f03f1af307b3d0644,444df331c2c2c3b093212519e8c1ae8f" parentTypeID="444df32f9fb5d68f03f1af307b3d0644" typeName="Account" systemCode="cttAccount" sortOrder="6" />
		<Record typeID="447df331c2c2c3b093212519e8c1ae8g" typeIDPath="444df32f9fb5d68f03f1af307b3d0644,447df331c2c2c3b093212519e8c1ae8g" parentTypeID="444df32f9fb5d68f03f1af307b3d0644" typeName="Category" systemCode="cttCategory" sortOrder="7" />
		<Record typeID="447df331c2c2c3b033312519e8c1ae8h" typeIDPath="444df32f9fb5d68f03f1af307b3d0644,447df331c2c2c3b033312519e8c1ae8h" parentTypeID="444df32f9fb5d68f03f1af307b3d0644" typeName="Attribute" systemCode="cttAttribute" sortOrder="8" />

		<Record typeID="bb6fd9cff5afa5112ad66560b6a887dd" typeIDPath="bb6fd9cff5afa5112ad66560b6a887dd" parentTypeID="NULL" typeName="Event Registration Status Types" systemCode="eventRegistrationStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="b89ae134f66e795e53c858b92360ded7" typeIDPath="bb6fd9cff5afa5112ad66560b6a887dd,b89ae134f66e795e53c858b92360ded7" parentTypeID="bb6fd9cff5afa5112ad66560b6a887dd" typeName="Attended" systemCode="erstAttended" sortOrder="1" />
		<Record typeID="bba2b415099a7b84b6c7c5992ddabbbb" typeIDPath="bb6fd9cff5afa5112ad66560b6a887dd,bba2b415099a7b84b6c7c5992ddabbbb" parentTypeID="bb6fd9cff5afa5112ad66560b6a887dd" typeName="Cancelled" systemCode="erstCancelled" sortOrder="2" />
		<Record typeID="d31c40b6fd5adfd1662a23becc0888fb" typeIDPath="bb6fd9cff5afa5112ad66560b6a887dd,d31c40b6fd5adfd1662a23becc0888fb" parentTypeID="bb6fd9cff5afa5112ad66560b6a887dd" typeName="Not Placed" systemCode="erstNotPlaced" sortOrder="3" />
		<Record typeID="b8861696d93259be4d3d03a85b9bc520" typeIDPath="bb6fd9cff5afa5112ad66560b6a887dd,b8861696d93259be4d3d03a85b9bc520" parentTypeID="bb6fd9cff5afa5112ad66560b6a887dd" typeName="Pending Approval" systemCode="erstPendingApproval" sortOrder="4" />
		<Record typeID="4cd8b68f0d9f5064c28b089805835927" typeIDPath="bb6fd9cff5afa5112ad66560b6a887dd,4cd8b68f0d9f5064c28b089805835927" parentTypeID="bb6fd9cff5afa5112ad66560b6a887dd" typeName="Pending Confirmation" systemCode="erstPendingConfirmation" sortOrder="5" />
		<Record typeID="b8861693e7abb9a80d7ce2ae027fb824" typeIDPath="bb6fd9cff5afa5112ad66560b6a887dd,b8861693e7abb9a80d7ce2ae027fb824" parentTypeID="bb6fd9cff5afa5112ad66560b6a887dd" typeName="Registered" systemCode="erstRegistered" sortOrder="6" />
		<Record typeID="b88616959d221ab71e82321fdd8f1fc9" typeIDPath="bb6fd9cff5afa5112ad66560b6a887dd,b88616959d221ab71e82321fdd8f1fc9" parentTypeID="bb6fd9cff5afa5112ad66560b6a887dd" typeName="Waitlisted" systemCode="erstWaitlisted" sortOrder="7" />

		<Record typeID="444df2ce9c74fa886435c08706d343db" typeIDPath="444df2ce9c74fa886435c08706d343db" parentTypeID="NULL" typeName="Image Types" systemCode="imageType" />
		<Record typeID="4028289a51a7450a0151ab186c740189" typeIDPath="444df2ce9c74fa886435c08706d343db,4028289a51a7450a0151ab186c740189" parentTypeID="444df2ce9c74fa886435c08706d343db" typeName="Default Image Type" systemCode="defaultImageType" sortOrder="1" />

		<Record typeID="444df2deab6476cb2c429946d6538436" typeIDPath="444df2deab6476cb2c429946d6538436" parentTypeID="NULL" typeName="Order Types" systemCode="orderType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df2df9f923d6c6fd0942a466e84cc" typeIDPath="444df2deab6476cb2c429946d6538436,444df2df9f923d6c6fd0942a466e84cc" parentTypeID="444df2deab6476cb2c429946d6538436" typeName="Sales Order" systemCode="otSalesOrder" sortOrder="1" />
		<Record typeID="444df2dd05a67eab0777ba14bef0aab1" typeIDPath="444df2deab6476cb2c429946d6538436,444df2dd05a67eab0777ba14bef0aab1" parentTypeID="444df2deab6476cb2c429946d6538436" typeName="Return Order" systemCode="otReturnOrder" sortOrder="2" />
		<Record typeID="444df2e00b455a2bae38fb55f640c204" typeIDPath="444df2deab6476cb2c429946d6538436,444df2e00b455a2bae38fb55f640c204" parentTypeID="444df2deab6476cb2c429946d6538436" typeName="Exchange Order" systemCode="otExchangeOrder" sortOrder="3" />
		<Record typeID="b3bdf58418894bf08e6e3c0e1cd882fe" typeIDPath="444df2deab6476cb2c429946d6538436,b3bdf58418894bf08e6e3c0e1cd882fe" parentTypeID="444df2deab6476cb2c429946d6538436" typeName="Replacement Order" systemCode="otReplacementOrder" sortOrder="4" />
		<Record typeID="ce5f32ef5ead4abb81e68d76706b0aee" typeIDPath="444df2deab6476cb2c429946d6538436,ce5f32ef5ead4abb81e68d76706b0aee" parentTypeID="444df2deab6476cb2c429946d6538436" typeName="Refund Order" systemCode="otRefundOrder" sortOrder="5" />

		<Record typeID="444df2b3df09f67ddcb27918f02c2d83" typeIDPath="444df2b3df09f67ddcb27918f02c2d83" parentTypeID="NULL" typeName="Order Status Types" systemCode="orderStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df2b498de93b4b33001593e96f4be" typeIDPath="444df2b3df09f67ddcb27918f02c2d83,444df2b498de93b4b33001593e96f4be" parentTypeID="444df2b3df09f67ddcb27918f02c2d83" typeName="Not Placed" systemCode="ostNotPlaced" sortOrder="1" />
		<Record typeID="444df2b5c8f9b37338229d4f7dd84ad1" typeIDPath="444df2b3df09f67ddcb27918f02c2d83,444df2b5c8f9b37338229d4f7dd84ad1" parentTypeID="444df2b3df09f67ddcb27918f02c2d83" typeName="New" systemCode="ostNew" sortOrder="2" />
		<Record typeID="444df2b6b8b5d1ccfc14a4ab38aa0a4c" typeIDPath="444df2b3df09f67ddcb27918f02c2d83,444df2b6b8b5d1ccfc14a4ab38aa0a4c" parentTypeID="444df2b3df09f67ddcb27918f02c2d83" typeName="Processing" systemCode="ostProcessing" sortOrder="3" />
		<Record typeID="444df2b7d7dcce8a3aa485f80264ac3a" typeIDPath="444df2b3df09f67ddcb27918f02c2d83,444df2b7d7dcce8a3aa485f80264ac3a" parentTypeID="444df2b3df09f67ddcb27918f02c2d83" typeName="On Hold" systemCode="ostOnHold" sortOrder="4" />
		<Record typeID="444df2b8b98441f8e8fc6b5b4266548c" typeIDPath="444df2b3df09f67ddcb27918f02c2d83,444df2b8b98441f8e8fc6b5b4266548c" parentTypeID="444df2b3df09f67ddcb27918f02c2d83" typeName="Closed" systemCode="ostClosed" sortOrder="5" />
		<Record typeID="444df2b90f62f72711eb5b3c90848e7e" typeIDPath="444df2b3df09f67ddcb27918f02c2d83,444df2b90f62f72711eb5b3c90848e7e" parentTypeID="444df2b3df09f67ddcb27918f02c2d83" typeName="Canceled" systemCode="ostCanceled" sortOrder="6" />
		<Record typeID="2c9280846bd1f0d8016bd217dc1d002e" typeIDPath="444df2b3df09f67ddcb27918f02c2d83,2c9280846bd1f0d8016bd217dc1d002e" parentTypeID="444df2b3df09f67ddcb27918f02c2d83" typeName="Processing - Payment Declined" systemCode="ostProcessing" sortOrder="7" />

		<Record typeID="443df2c3df09e67dddb27918f02c2d83" typeIDPath="443df2c3df09e67dddb27918f02c2d83" parentTypeID="NULL" typeName="Order Import Batch Status Types" systemCode="orderImportBatchStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="442ef3dbdf29f67fdcb23911f03c1945" typeIDPath="443df2c3df09e67dddb27918f02c2d83,442ef3dbdf29f67fdcb23911f03c1945" parentTypeID="443df2c3df09e67dddb27918f02c2d83" typeName="New" systemCode="oibstNew" sortOrder="1" />
		<Record typeID="963c1f73115111ea9fa612bff9d404c8" typeIDPath="443df2c3df09e67dddb27918f02c2d83,963c1f73115111ea9fa612bff9d404c8" parentTypeID="443df2c3df09e67dddb27918f02c2d83" typeName="Partially Processed" systemCode="oibstPartial" sortOrder="2" />
		<Record typeID="b2183cf4115111ea9fa612bff9d404c8" typeIDPath="443df2c3df09e67dddb27918f02c2d83,b2183cf4115111ea9fa612bff9d404c8" parentTypeID="443df2c3df09e67dddb27918f02c2d83" typeName="Processed" systemCode="oibstProcessed" sortOrder="3" />
		
		<Record typeID="443df2c3df09e67dade2a918b12c2d95" typeIDPath="443df2c3df09e67dade2a918b12c2d95" parentTypeID="NULL" typeName="Template Item Batch Status Types" systemCode="templateItemBatchStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="4e1ec3dbaf29f11fdcb23311fa3c2aa2" typeIDPath="443df2c3df09e67dade2a918b12c2d95,4e1ec3dbaf29f11fdcb23311fa3c2aa2" parentTypeID="443df2c3df09e67dade2a918b12c2d95" typeName="New" systemCode="tibstNew" sortOrder="1" />
		<Record typeID="521e3ca4225131e79f4412aff9d334c9" typeIDPath="443df2c3df09e67dade2a918b12c2d95,521e3ca4225131e79f4412aff9d334c9" parentTypeID="443df2c3df09e67dade2a918b12c2d95" typeName="Processed" systemCode="tibstProcessed" sortOrder="2" />
		
		<Record typeID="e96fcde3115111ea9fa612bff9d404c8" typeIDPath="e96fcde3115111ea9fa612bff9d404c8" parentTypeID="NULL" typeName="Order Import Batch Item Status Types" systemCode="orderImportBatchItemStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="03c83b1d115211ea9fa612bff9d404c8" typeIDPath="e96fcde3115111ea9fa612bff9d404c8,03c83b1d115211ea9fa612bff9d404c8" parentTypeID="e96fcde3115111ea9fa612bff9d404c8" typeName="New" systemCode="oibistNew" sortOrder="1" />
		<Record typeID="1de04d7d115211ea9fa612bff9d404c8" typeIDPath="e96fcde3115111ea9fa612bff9d404c8,1de04d7d115211ea9fa612bff9d404c8" parentTypeID="e96fcde3115111ea9fa612bff9d404c8" typeName="Placed" systemCode="oibstPlaced" sortOrder="2" />
		<Record typeID="9e86d6dd43a411ea975c0a9c8645709b" typeIDPath="e96fcde3115111ea9fa612bff9d404c8,9e86d6dd43a411ea975c0a9c8645709b" parentTypeID="e96fcde3115111ea9fa612bff9d404c8" typeName="Error" systemCode="oibstError" sortOrder="3" />
		
		<Record typeID="2c948084697d51bd01697d5402d40005" typeIDPath="2c948084697d51bd01697d5402d40005" parentTypeID="NULL" typeName="Order Template Types" systemCode="orderTemplateType" childRequiresSystemCodeFlag="1" />
		<Record typeID="2c948084697d51bd01697d5725650006" typeIDPath="2c948084697d51bd01697d5402d40005,2c948084697d51bd01697d5725650006" parentTypeID="2c948084697d51bd01697d5402d40005" typeName="Schedule Order Template" systemCode="ottSchedule" sortOrder="1"/>
		<Record typeID="2c9280846b712d47016b75464e800014" typeIDPath="2c948084697d51bd01697d5402d40005,2c9280846b712d47016b75464e800014" parentTypeID="2c948084697d51bd01697d5402d40005" typeName="Wish List" systemCode="ottWishList" sortOrder="9"/>

		<Record typeID="2c948084697d51bd01697d5996d80007" typeIDPath="2c948084697d51bd01697d5996d80007" parentTypeID="NULL" typeName="Order Template Status Types" systemCode="orderTemplateStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="2c948084697d51bd01697d9a592d0009" typeIDPath="2c948084697d51bd01697d5996d80007,2c948084697d51bd01697d9a592d0009" parentTypeID="2c948084697d51bd01697d5996d80007" typeName="Draft" systemCode="otstDraft" />
		<Record typeID="2c948084697d51bd01697d9be217000a" typeIDPath="2c948084697d51bd01697d5996d80007,2c948084697d51bd01697d9be217000a" parentTypeID="2c948084697d51bd01697d5996d80007" typeName="Active" systemCode="otstActive" />
		<Record typeID="2c948084697d51bd01697d9d9492000b" typeIDPath="2c948084697d51bd01697d5996d80007,2c948084697d51bd01697d9d9492000b" parentTypeID="2c948084697d51bd01697d5996d80007" typeName="Inactive" systemCode="otstInactive" />
		<Record typeID="2c9580846ab29168016ab2adbb560013" typeIDPath="2c948084697d51bd01697d5996d80007,2c9580846ab29168016ab2adbb560013" parentTypeID="2c948084697d51bd01697d5996d80007" typeName="Cancelled" systemCode="otstCancelled" />
		
		<Record typeID="2c9280846a023949016a028c33ff000b" typeIDPath="2c9280846a023949016a028c33ff000b" parentTypeID="NULL" typeName="Order Template Schedule Date Change Reason Type" systemCode="orderTemplateScheduleDateChangeReasonType" childRequiresSystemCodeFlag="1" />
		<Record typeID="2c9280846a023949016a029455f0000c" typeIDPath="2c9280846a023949016a028c33ff000b,2c9280846a023949016a029455f0000c" parentTypeID="2c9280846a023949016a028c33ff000b" typeName="Other" typeDescription="Other" systemCode="otsdcrtOther" />

		<Record typeID="2c9480846a9e35d1016a9e5463c10006" typeIDPath="2c9480846a9e35d1016a9e5463c10006" parentTypeID="NULL" typeName="Order Template Cancellation Reason Type" systemCode="orderTemplateCancellationReasonType" childRequiresSystemCodeFlag="1" />
		<Record typeID="2c9680846ab15673016ab172b08c000c" typeIDPath="2c9480846a9e35d1016a9e5463c10006,2c9680846ab15673016ab172b08c000c" parentTypeID="2c9480846a9e35d1016a9e5463c10006" typeName="Other" typeDescription="Other" systemCode="otcrtOther" />

		<Record typeID="2c9280846e5ae975016e5b2286c7000a" typeIDPath="2c9280846e5ae975016e5b2286c7000a" parentTypeID="NULL" typeName="Order Template System Cancellation Reason Type" systemCode="orderTemplateSystemCancellationReasonType" childRequiresSystemCodeFlag="1" />
		<Record typeID="2c9280846e5ae975016e5b2505b7000b" typeIDPath="2c9280846e5ae975016e5b2286c7000a,2c9280846e5ae975016e5b2505b7000b" parentTypeID="2c9280846e5ae975016e5b2286c7000a" typeName="Batch Cancelled By Admin" typeDescription="Schedule Order Template was cancelled by admin as part of a workflow" systemCode="otscrtBatch" sortOrder="1" />

		<Record typeID="444df2e8db2712fe6cf790d12afc9661" typeIDPath="444df2e8db2712fe6cf790d12afc9661" parentTypeID="NULL" typeName="Order Item Types" systemCode="orderItemType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df2e9a6622ad1614ea75cd5b982ce" typeIDPath="444df2e8db2712fe6cf790d12afc9661,444df2e9a6622ad1614ea75cd5b982ce" parentTypeID="444df2e8db2712fe6cf790d12afc9661" typeName="Sale" systemCode="oitSale" sortOrder="1" />
		<Record typeID="444df2eac18fa589af0f054442e12733" typeIDPath="444df2e8db2712fe6cf790d12afc9661,444df2eac18fa589af0f054442e12733" parentTypeID="444df2e8db2712fe6cf790d12afc9661" typeName="Return" systemCode="oitReturn" sortOrder="2" />
		<Record typeID="d98bbd66f5dfafd0eb8c727cc4053b46" typeIDPath="444df2e8db2712fe6cf790d12afc9661,d98bbd66f5dfafd0eb8c727cc4053b46" parentTypeID="444df2e8db2712fe6cf790d12afc9661" typeName="Deposit" systemCode="oitDeposit" sortOrder="3" />
		<Record typeID="a363729e14364febb92f18db70c070e5" typeIDPath="444df2e8db2712fe6cf790d12afc9661,a363729e14364febb92f18db70c070e5" parentTypeID="444df2e8db2712fe6cf790d12afc9661" typeName="Replacement" systemCode="oitReplacement" sortOrder="4" />

		<Record typeID="444df2bac3f06e0645cf38f1d6a4e443" typeIDPath="444df2bac3f06e0645cf38f1d6a4e443" parentTypeID="NULL" typeName="Order Item Status Types" systemCode="orderItemStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df34998ed6b96c0240c34e3b63914" typeIDPath="444df2bac3f06e0645cf38f1d6a4e443,444df34998ed6b96c0240c34e3b63914" parentTypeID="444df2bac3f06e0645cf38f1d6a4e443" typeName="New" systemCode="oistNew" sortOrder="1" />
		<Record typeID="444df2bdd89b4fe8f128c3a7590c99b6" typeIDPath="444df2bac3f06e0645cf38f1d6a4e443,444df2bdd89b4fe8f128c3a7590c99b6" parentTypeID="444df2bac3f06e0645cf38f1d6a4e443" typeName="Backordered" systemCode="oistBackordered" sortOrder="2" />
		<Record typeID="444df2bedf079c901347d35abab7c032" typeIDPath="444df2bac3f06e0645cf38f1d6a4e443,444df2bedf079c901347d35abab7c032" parentTypeID="444df2bac3f06e0645cf38f1d6a4e443" typeName="Fulfilled" systemCode="oistFulfilled" sortOrder="3" />
		<Record typeID="444df31c09137938f779534850d0fca4" typeIDPath="444df2bac3f06e0645cf38f1d6a4e443,444df31c09137938f779534850d0fca4" parentTypeID="444df2bac3f06e0645cf38f1d6a4e443" typeName="Processing" systemCode="oistProcessing" sortOrder="4" />
		<Record typeID="444df31dc1b8d9c81825037127e8820e" typeIDPath="444df2bac3f06e0645cf38f1d6a4e443,444df31dc1b8d9c81825037127e8820e" parentTypeID="444df2bac3f06e0645cf38f1d6a4e443" typeName="On Hold" systemCode="oistOnHold" sortOrder="5" />

		<Record typeID="444df2ef9cb25116d6396b34d89c9312" typeIDPath="444df2ef9cb25116d6396b34d89c9312" parentTypeID="NULL" typeName="Order Payment Types" systemCode="orderPaymentType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df2f0fed139ff94191de8fcd1f61b" typeIDPath="444df2ef9cb25116d6396b34d89c9312,444df2f0fed139ff94191de8fcd1f61b" parentTypeID="444df2ef9cb25116d6396b34d89c9312" typeName="Charge" systemCode="optCharge" sortOrder="1" />
		<Record typeID="444df2f1cc40d0ea8a2de6f542ab4f1d" typeIDPath="444df2ef9cb25116d6396b34d89c9312,444df2f1cc40d0ea8a2de6f542ab4f1d" parentTypeID="444df2ef9cb25116d6396b34d89c9312" typeName="Credit" systemCode="optCredit" sortOrder="2" />

		<Record typeID="5accbf56c330c01b3be2b8fef26094cc" typeIDPath="5accbf56c330c01b3be2b8fef26094cc" parentTypeID="NULL" typeName="Order Payment Status Types" systemCode="orderPaymentStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="5accbf57dcf5bb3eb71614febe83a31d" typeIDPath="5accbf56c330c01b3be2b8fef26094cc,5accbf57dcf5bb3eb71614febe83a31d" parentTypeID="5accbf56c330c01b3be2b8fef26094cc" typeName="Active" systemCode="opstActive" sortOrder="1" />
		<Record typeID="5accbf58a94b61fe031f854ffb220f4b" typeIDPath="5accbf56c330c01b3be2b8fef26094cc,5accbf58a94b61fe031f854ffb220f4b" parentTypeID="5accbf56c330c01b3be2b8fef26094cc" typeName="Invalid" systemCode="opstInvalid" sortOrder="2" />
		<Record typeID="5accbf59ac1b1e30f86b1ab01812e932" typeIDPath="5accbf56c330c01b3be2b8fef26094cc,5accbf59ac1b1e30f86b1ab01812e932" parentTypeID="5accbf56c330c01b3be2b8fef26094cc" typeName="Removed" systemCode="opstRemoved" sortOrder="3" />

		<Record typeID="af48db70f32b49328d9549d7fcf63589" typeIDPath="af48db70f32b49328d9549d7fcf63589" parentTypeID="NULL" typeName="Order Fulfillment Status Types" systemCode="orderFulfillmentStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="b718b6fadf084bdaa01e47f5cc1a8265" typeIDPath="af48db70f32b49328d9549d7fcf63589,b718b6fadf084bdaa01e47f5cc1a8265" parentTypeID="af48db70f32b49328d9549d7fcf63589" typeName="Unfulfilled" systemCode="ofstUnfulfilled" sortOrder="1" />
		<Record typeID="159118d67de3418d9951fc629688e194" typeIDPath="af48db70f32b49328d9549d7fcf63589,159118d67de3418d9951fc629688e194" parentTypeID="af48db70f32b49328d9549d7fcf63589" typeName="Fulfilled" systemCode="ofstFulfilled" sortOrder="2" />
		<Record typeID="fefc92c1d8184017aa65cdc882bdf636" typeIDPath="af48db70f32b49328d9549d7fcf63589,fefc92c1d8184017aa65cdc882bdf636" parentTypeID="af48db70f32b49328d9549d7fcf63589" typeName="Partially Fulfilled" systemCode="ofstPartiallyFulfilled" sortOrder="3" />
		
		<Record typeID="af48db70f32b49328d9549d7fcf63590" typeIDPath="af48db70f32b49328d9549d7fcf63590" parentTypeID="NULL" typeName="Order Fulfillment Inventory Status Types" systemCode="orderFulfillmentInvStatType" childRequiresSystemCodeFlag="1" />
		<Record typeID="b718b6fadf084bdaa01e47f5cc1a8266" typeIDPath="af48db70f32b49328d9549d7fcf63590,b718b6fadf084bdaa01e47f5cc1a8266" parentTypeID="af48db70f32b49328d9549d7fcf63590" typeName="Available" systemCode="ofisAvailable" sortOrder="1" />
		<Record typeID="159118d67de3418d9951fc629688e195" typeIDPath="af48db70f32b49328d9549d7fcf63590,159118d67de3418d9951fc629688e195" parentTypeID="af48db70f32b49328d9549d7fcf63590" typeName="Unavailable" systemCode="ofisUnAvailable" sortOrder="2" />
		<Record typeID="fefc92c1d8184017aa65cdc882bdf637" typeIDPath="af48db70f32b49328d9549d7fcf63590,fefc92c1d8184017aa65cdc882bdf637" parentTypeID="af48db70f32b49328d9549d7fcf63590" typeName="Partial" systemCode="ofisPartial" sortOrder="3" />

		<Record typeID="5accbf4bc2f3ffcf702d75529a6692b6" typeIDPath="5accbf4bc2f3ffcf702d75529a6692b6" parentTypeID="NULL" typeName="Physical Status Types" systemCode="physicalStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="5accbf4cb81693960a8cf9c6ada9d220" typeIDPath="5accbf4bc2f3ffcf702d75529a6692b6,5accbf4cb81693960a8cf9c6ada9d220" parentTypeID="5accbf4bc2f3ffcf702d75529a6692b6" typeName="Open" systemCode="pstOpen" sortOrder="1" />
		<Record typeID="5accbf4db8ff07fa9b37d3285919ecc3" typeIDPath="5accbf4bc2f3ffcf702d75529a6692b6,5accbf4db8ff07fa9b37d3285919ecc3" parentTypeID="5accbf4bc2f3ffcf702d75529a6692b6" typeName="Closed" systemCode="pstClosed" sortOrder="2" />

		<Record typeID="154dcdd2f3fd4b5ab5498e93470957b8" typeIDPath="154dcdd2f3fd4b5ab5498e93470957b8" parentTypeID="NULL" typeName="Product Bundle Group Types" systemCode="productBundleGroupType" sortOrder="1" />

		<Record typeID="444df2ef9cb25116d6396b34da32aab3" typeIDPath="444df2ef9cb25116d6396b34da32aab3" parentTypeID="NULL" typeName="Qualifier Logical Operator Types" systemCode="qualifierLogicalOperatorType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df2f0671939ff94191de8f5f0134d" typeIDPath="444df2ef9cb25116d6396b34da32aab3,444df2f0671939ff94191de8f5f0134d" parentTypeID="444df2ef9cb25116d6396b34da32aab3" typeName="OR" systemCode="qlotOr" sortOrder="1" />
		<Record typeID="43cb12f1cc40d0ea8a2de6f54175bcdf" typeIDPath="444df2ef9cb25116d6396b34da32aab3,43cb12f1cc40d0ea8a2de6f54175bcdf" parentTypeID="444df2ef9cb25116d6396b34da32aab3" typeName="AND" systemCode="qlotAnd" sortOrder="2" />

		<Record typeID="444df2e4e0ec725f718318de5bd3b973" typeIDPath="444df2e4e0ec725f718318de5bd3b973" parentTypeID="NULL" typeName="Stock Adjustment Types" systemCode="stockAdjustmentType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df2e5cb27169f418279f3f859a4f7" typeIDPath="444df2e4e0ec725f718318de5bd3b973,444df2e5cb27169f418279f3f859a4f7" parentTypeID="444df2e4e0ec725f718318de5bd3b973" typeName="Location Transfer" systemCode="satLocationTransfer" sortOrder="2" />
		<Record typeID="444df2e60db81c12589c9b39346009f2" typeIDPath="444df2e4e0ec725f718318de5bd3b973,444df2e60db81c12589c9b39346009f2" parentTypeID="444df2e4e0ec725f718318de5bd3b973" typeName="Manual In" systemCode="satManualIn" sortOrder="3" />
		<Record typeID="444df2e7dba550b7a24a03acbb37e717" typeIDPath="444df2e4e0ec725f718318de5bd3b973,444df2e7dba550b7a24a03acbb37e717" parentTypeID="444df2e4e0ec725f718318de5bd3b973" typeName="Manual Out" systemCode="satManualOut" sortOrder="4" />
		<Record typeID="5accbf51d91d4c3badc6f22b1caace97" typeIDPath="444df2e4e0ec725f718318de5bd3b973,5accbf51d91d4c3badc6f22b1caace97" parentTypeID="444df2e4e0ec725f718318de5bd3b973" typeName="Physical Count" systemCode="satPhysicalCount" sortOrder="5" />
		<Record typeID="3749e30bcf8179d5531d6713db673565" typeIDPath="444df2e4e0ec725f718318de5bd3b973,3749e30bcf8179d5531d6713db673565" parentTypeID="444df2e4e0ec725f718318de5bd3b973" typeName="Makeup Bundled Skus" systemCode="satMakeupBundledSkus" sortOrder="6" />
		<Record typeID="37a1ceb6969fd35927b67733d849532a" typeIDPath="444df2e4e0ec725f718318de5bd3b973,37a1ceb6969fd35927b67733d849532a" parentTypeID="444df2e4e0ec725f718318de5bd3b973" typeName="Breakup Bundled Skus" systemCode="satBreakupBundledSkus" sortOrder="7" />

		<Record typeID="444df2e1afee04d4971094d467a2c619" typeIDPath="444df2e1afee04d4971094d467a2c619" parentTypeID="NULL" typeName="Stock Adjustment Status Types" systemCode="stockAdjustmentStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df2e2f66ddfaf9c60caf5c76349a6" typeIDPath="444df2e1afee04d4971094d467a2c619,444df2e2f66ddfaf9c60caf5c76349a6" parentTypeID="444df2e1afee04d4971094d467a2c619" typeName="New" systemCode="sastNew" sortOrder="1" />
		<Record typeID="444df2e3cd41522453f5582a5950342e" typeIDPath="444df2e1afee04d4971094d467a2c619,444df2e3cd41522453f5582a5950342e" parentTypeID="444df2e1afee04d4971094d467a2c619" typeName="Closed" systemCode="sastClosed" sortOrder="2" />

		<Record typeID="5accbf53ad1b00392c1053e025e84f5e" typeIDPath="5accbf53ad1b00392c1053e025e84f5e" parentTypeID="NULL" typeName="Vendor Order Item Types" systemCode="vendorOrderItemType" childRequiresSystemCodeFlag="1" />
		<Record typeID="5accbf5409572526d413fd7dc447b937" typeIDPath="5accbf53ad1b00392c1053e025e84f5e,5accbf5409572526d413fd7dc447b937" parentTypeID="5accbf53ad1b00392c1053e025e84f5e" typeName="Purchase" systemCode="voitPurchase" sortOrder="1" />
		<Record typeID="5accbf55c4fbb1d5609bb03344974050" typeIDPath="5accbf53ad1b00392c1053e025e84f5e,5accbf55c4fbb1d5609bb03344974050" parentTypeID="5accbf53ad1b00392c1053e025e84f5e" typeName="Return" systemCode="voitReturn" sortOrder="2" />

		<Record typeID="444df2dafc8a46af86aedf6aa15bb35a" typeIDPath="444df2dafc8a46af86aedf6aa15bb35a" parentTypeID="NULL" typeName="Vendor Order Types" systemCode="vendorOrderType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df2dbfde8c38ab64bb21c724d46e0" typeIDPath="444df2dafc8a46af86aedf6aa15bb35a,444df2dbfde8c38ab64bb21c724d46e0" parentTypeID="444df2dafc8a46af86aedf6aa15bb35a" typeName="Purchase Order" systemCode="votPurchaseOrder" sortOrder="1" />
		<Record typeID="444df2dc91afb63f25074c7d9512248b" typeIDPath="444df2dafc8a46af86aedf6aa15bb35a,444df2dc91afb63f25074c7d9512248b" parentTypeID="444df2dafc8a46af86aedf6aa15bb35a" typeName="Return Order" systemCode="votReturnOrder" sortOrder="2" />
		
		<Record typeID="723ada44efad4ce090a46479ba9c57ae" typeIDPath="723ada44efad4ce090a46479ba9c57ae" parentTypeID="NULL" typeName="Vendor Order Status Types" systemCode="vendorOrderStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="ee9669f448c949a98a8b1d4d988afe1a" typeIDPath="723ada44efad4ce090a46479ba9c57ae,ee9669f448c949a98a8b1d4d988afe1a" parentTypeID="723ada44efad4ce090a46479ba9c57ae" typeName="New" systemCode="vostNew" sortOrder="1" />
		<Record typeID="6b0f53eb598e42dcb995ed333cc8464a" typeIDPath="723ada44efad4ce090a46479ba9c57ae,6b0f53eb598e42dcb995ed333cc8464a" parentTypeID="723ada44efad4ce090a46479ba9c57ae" typeName="Partially Received" systemCode="vostPartiallyReceived" sortOrder="2" />
		<Record typeID="6b0f53eb598e42dcb995ed333cc94642" typeIDPath="723ada44efad4ce090a46479ba9c57ae,6b0f53eb598e42dcb995ed333cc94642" parentTypeID="723ada44efad4ce090a46479ba9c57ae" typeName="Partially Delivered" systemCode="vostPartiallyDelivered" sortOrder="2" />
		<Record typeID="9b038283edff412a8c4e3d10a6a7b738" typeIDPath="723ada44efad4ce090a46479ba9c57ae,9b038283edff412a8c4e3d10a6a7b738" parentTypeID="723ada44efad4ce090a46479ba9c57ae" typeName="Closed" systemCode="vostClosed" sortOrder="3" />

		<Record typeID="444df2ac94eaa8a4881d4cbb3c2e0b98" typeIDPath="444df2ac94eaa8a4881d4cbb3c2e0b98" parentTypeID="NULL" typeName="Validation Types" systemCode="validationType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df2adb8774aa68279f91db58b8711" typeIDPath="444df2ac94eaa8a4881d4cbb3c2e0b98,444df2adb8774aa68279f91db58b8711" parentTypeID="444df2ac94eaa8a4881d4cbb3c2e0b98" typeName="Date" systemCode="vtDate" sortOrder="1" />
		<Record typeID="444df2aef6c81f77a9b35e0060c0b141" typeIDPath="444df2ac94eaa8a4881d4cbb3c2e0b98,444df2aef6c81f77a9b35e0060c0b141" parentTypeID="444df2ac94eaa8a4881d4cbb3c2e0b98" typeName="Numeric" systemCode="vtNumeric" sortOrder="2" />
		<Record typeID="444df2afcc7332933829e449ff70e360" typeIDPath="444df2ac94eaa8a4881d4cbb3c2e0b98,444df2afcc7332933829e449ff70e360" parentTypeID="444df2ac94eaa8a4881d4cbb3c2e0b98" typeName="Email" systemCode="vtEmail" sortOrder="3" />
		<Record typeID="444df2b0e1867f38402ff0aced5ca60f" typeIDPath="444df2ac94eaa8a4881d4cbb3c2e0b98,444df2b0e1867f38402ff0aced5ca60f" parentTypeID="444df2ac94eaa8a4881d4cbb3c2e0b98" typeName="URL" systemCode="vtURL" sortOrder="4" />
		<Record typeID="444df2b201a098f5b277febb17a7cb0a" typeIDPath="444df2ac94eaa8a4881d4cbb3c2e0b98,444df2b201a098f5b277febb17a7cb0a" parentTypeID="444df2ac94eaa8a4881d4cbb3c2e0b98" typeName="Zip Code" systemCode="vtZipCode" sortOrder="5" />
		<Record typeID="444df2b193d8c854256c8cde9d4921b3" typeIDPath="444df2ac94eaa8a4881d4cbb3c2e0b98,444df2b193d8c854256c8cde9d4921b3" parentTypeID="444df2ac94eaa8a4881d4cbb3c2e0b98" typeName="Regex" systemCode="vtRegex" sortOrder="6" />

		<Record typeID="444df2f201be608fee51e3de7bbf3960" typeIDPath="444df2f201be608fee51e3de7bbf3960" parentTypeID="NULL" typeName="Subscription Access Types" systemCode="subscriptionAccessType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df2f39c75e88f55a9b993e786aaf2" typeIDPath="444df2f201be608fee51e3de7bbf3960,444df2f39c75e88f55a9b993e786aaf2" parentTypeID="444df2f201be608fee51e3de7bbf3960" typeName="Per Subscription" systemCode="satPerSubscription" sortOrder="1" />
		<Record typeID="444df2f4d19ac22bba4bc12cc38b3ee0" typeIDPath="444df2f201be608fee51e3de7bbf3960,444df2f4d19ac22bba4bc12cc38b3ee0" parentTypeID="444df2f201be608fee51e3de7bbf3960" typeName="Per Benefit" systemCode="satPerBenefit" sortOrder="2" />
		<Record typeID="444df2f5ad81d2a9039a050b8dda814d" typeIDPath="444df2f201be608fee51e3de7bbf3960,444df2f5ad81d2a9039a050b8dda814d" parentTypeID="444df2f201be608fee51e3de7bbf3960" typeName="Per Account" systemCode="satPerAccount" sortOrder="3" />

		<Record typeID="444df3100babdbe1086cf951809a60ca" typeIDPath="444df3100babdbe1086cf951809a60ca" parentTypeID="NULL" typeName="Subscription Order Item Types" systemCode="subscriptionOrderItemType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df311d7615e7cf56b836f515aebd4" typeIDPath="444df3100babdbe1086cf951809a60ca,444df311d7615e7cf56b836f515aebd4" parentTypeID="444df3100babdbe1086cf951809a60ca" typeName="Initial" systemCode="soitInitial" sortOrder="1" />
		<Record typeID="444df312935fa6b9866a813b3f4793a2" typeIDPath="444df3100babdbe1086cf951809a60ca,444df312935fa6b9866a813b3f4793a2" parentTypeID="444df3100babdbe1086cf951809a60ca" typeName="Renewal" systemCode="soitRenewal" sortOrder="2" />
		
		<Record typeID="f22a04abb2586c3cfe783173c4724db5" typeIDPath="f22a04abb2586c3cfe783173c4724db5" parentTypeID="NULL" typeName="Subscription Order Delivery Item Types" systemCode="subscriptionOrderDeliveryItemType" childRequiresSystemCodeFlag="1" />
		<Record typeID="f22e6a41d678334700a550bddec925d2" typeIDPath="f22a04abb2586c3cfe783173c4724db5,f22e6a41d678334700a550bddec925d2" parentTypeID="f22a04abb2586c3cfe783173c4724db5" typeName="Delivered" systemCode="soditDelivered" sortOrder="1" />
		<Record typeID="f2303148d2c876dde58d2bb6e3fe8e90" typeIDPath="f22a04abb2586c3cfe783173c4724db5,f2303148d2c876dde58d2bb6e3fe8e90" parentTypeID="f22a04abb2586c3cfe783173c4724db5" typeName="Refunded" systemCode="soditRefunded" sortOrder="2" />
		
		<Record typeID="444df31eb4026852a7adabb6413778e4" typeIDPath="444df31eb4026852a7adabb6413778e4" parentTypeID="NULL" typeName="Subscription Status Types" systemCode="subscriptionStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df31fa8adde8d71c5ca279e42a00d" typeIDPath="444df31eb4026852a7adabb6413778e4,444df31fa8adde8d71c5ca279e42a00d" parentTypeID="444df31eb4026852a7adabb6413778e4" typeName="Active" systemCode="sstActive" sortOrder="1" />
		<Record typeID="444df320e882d5db8c461f3d840c31a7" typeIDPath="444df31eb4026852a7adabb6413778e4,444df320e882d5db8c461f3d840c31a7" parentTypeID="444df31eb4026852a7adabb6413778e4" typeName="Cancelled" systemCode="sstCancelled" sortOrder="2" />
		<Record typeID="444df321eb57a31846c4fdda918f55ec" typeIDPath="444df31eb4026852a7adabb6413778e4,444df321eb57a31846c4fdda918f55ec" parentTypeID="444df31eb4026852a7adabb6413778e4" typeName="Suspended" systemCode="sstSuspended" sortOrder="3" />

		<Record typeID="444df32200452ec23641f213a07c1dda" typeIDPath="444df32200452ec23641f213a07c1dda" parentTypeID="NULL" typeName="Subscription Status Change Reason Type" systemCode="subscriptionStatusChangeReasonType" childRequiresSystemCodeFlag="1" />
		<Record typeID="444df323c807edf43d3105d43f9f4eef" typeIDPath="444df32200452ec23641f213a07c1dda,444df323c807edf43d3105d43f9f4eef" parentTypeID="444df32200452ec23641f213a07c1dda" typeName="Payment Failed" systemCode="sscrtPaymentFailed" sortOrder="1" />
		<Record typeID="444df324fc56d5fbf8908ba071bc52ca" typeIDPath="444df32200452ec23641f213a07c1dda,444df324fc56d5fbf8908ba071bc52ca" parentTypeID="444df32200452ec23641f213a07c1dda" typeName="User Initiated" systemCode="sscrtUserInitiated" sortOrder="2" />
		
		<Record typeID="a5380924cb4a3d53eb096ed36bf5b825" typeIDPath="a5380924cb4a3d53eb096ed36bf5b825" parentTypeID="NULL" typeName="Ledger Account Type" systemCode="ledgerAccountType" childRequiresSystemCodeFlag="1" />
		<Record typeID="a54668fcc2ff2c8413c7b85b6927a850" typeIDPath="a5380924cb4a3d53eb096ed36bf5b825,a54668fcc2ff2c8413c7b85b6927a850" parentTypeID="a5380924cb4a3d53eb096ed36bf5b825" typeName="Asset" systemCode="latAsset" sortOrder="1" />
		<Record typeID="a54668fdc129db6427f2d597da3163d7" typeIDPath="a5380924cb4a3d53eb096ed36bf5b825,a54668fdc129db6427f2d597da3163d7" parentTypeID="a5380924cb4a3d53eb096ed36bf5b825" typeName="Cost Of Goods" systemCode="latCogs" sortOrder="1" />
		<Record typeID="a54668fef238c6cd354e1d9b371700ea" typeIDPath="a5380924cb4a3d53eb096ed36bf5b825,a54668fef238c6cd354e1d9b371700ea" parentTypeID="a5380924cb4a3d53eb096ed36bf5b825" typeName="Expense" systemCode="latExpense" sortOrder="1" />
		<Record typeID="a54668fbcafa5275c59482d98a1497bd" typeIDPath="a5380924cb4a3d53eb096ed36bf5b825,a54668fbcafa5275c59482d98a1497bd" parentTypeID="a5380924cb4a3d53eb096ed36bf5b825" typeName="Revenue" systemCode="latRevenue" sortOrder="1" />
		<Record typeID="a54668fbcafa5275c59482d98a1497bc" typeIDPath="a5380924cb4a3d53eb096ed36bf5b825,a54668fbcafa5275c59482d98a1497bc" parentTypeID="a5380924cb4a3d53eb096ed36bf5b825" typeName="Liability" systemCode="latLiability" sortOrder="1" />
		
		<Record typeID="7e8942b36f4b11e895c20242ac120002" typeIDPath="7e8942b36f4b11e895c20242ac120002" parentTypeID="NULL" typeName="Cycle Count Batch Status Type" systemCode="cycleCountBatchStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="b453ca526f4b11e895c20242ac120002" typeIDPath="7e8942b36f4b11e895c20242ac120002,b453ca526f4b11e895c20242ac120002" parentTypeID="7e8942b36f4b11e895c20242ac120002" typeName="Open" systemCode="ccbstOpen" sortOrder="1" />
		<Record typeID="b9f3b9626f4b11e895c20242ac120002" typeIDPath="7e8942b36f4b11e895c20242ac120002,b9f3b9626f4b11e895c20242ac120002" parentTypeID="7e8942b36f4b11e895c20242ac120002" typeName="Closed" systemCode="ccbstClosed" sortOrder="2" />
		
		<Record typeID="708cd88615ec4ae2b9b0bf6d34aba5fc" typeIDPath="708cd88615ec4ae2b9b0bf6d34aba5fc" parentTypeID="NULL" typeName="Product Review Status Type" systemCode="productReviewStatusType" childRequiresSystemCodeFlag="1" />
		<Record typeID="f0558da55e9f48f7bbd0eb4c95d6b378" typeIDPath="708cd88615ec4ae2b9b0bf6d34aba5fc,f0558da55e9f48f7bbd0eb4c95d6b378" parentTypeID="708cd88615ec4ae2b9b0bf6d34aba5fc" typeName="Unapproved" systemCode="prstUnapproved" sortOrder="1" />
		<Record typeID="9c60366a4091434582f5085f90d81bad" typeIDPath="708cd88615ec4ae2b9b0bf6d34aba5fc,9c60366a4091434582f5085f90d81bad" parentTypeID="708cd88615ec4ae2b9b0bf6d34aba5fc" typeName="Approved" systemCode="prstApproved" sortOrder="2" />
		<Record typeID="8bab6083921f4df4bff254e3a06d35a7" typeIDPath="708cd88615ec4ae2b9b0bf6d34aba5fc,8bab6083921f4df4bff254e3a06d35a7" parentTypeID="708cd88615ec4ae2b9b0bf6d34aba5fc" typeName="Disapprove" systemCode="prstDisapprove" sortOrder="3" />
		
	</Records>
</Table>

