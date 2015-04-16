component extends="Slatwall.meta.tests.unit.entity.SlatwallEntityTestBase" {

	// @hint put things in here that you want to run befor EACH test
	public void function setUp() {
		
		super.setup();
		variables.b = request.slatwallScope.getService("productService").newProductBundleBuild();
		variables.i = request.slatwallScope.getService("productService").newProductBundleBuildItem();
		
		variables.order = request.slatwallScope.newEntity( 'Order' );
		variables.pbBuildItem = request.slatwallScope.newEntity( 'ProductBundleBuildItem' );
		variables.pbBuildItem.setProductBundleBuildItemID("1q2wq3we34e3re4tr5t6yt6y7uy8ui89");
		variables.pbBuildItem2 = request.slatwallScope.newEntity( 'ProductBundleBuildItem' );
		variables.pbBuildItem.setProductBundleBuildItemID("1wq2we3we4reR5tr6Ty7uy7u8iu6yt5r");
		variables.pbBuild = request.slatwallScope.newEntity( 'ProductBundleBuild' );
		variables.pbBuild.setProductBundleBuildID("1wq2we3we4reR5tr6Ty7uy7u8iu4re3w");
		variables.pbGroup = request.slatwallScope.newEntity( 'ProductBundleGroup' );
		variables.sku = request.slatwallScope.newEntity( 'Sku' );
		variables.entity = pbBuild;
	}
	
	public void function create_productBundleBuildItem() {
		var data = {
			orderItemID = "1wq2w3ew3e4re4r5tr5t6yt6yt7uy7u8",
			price = 22.50,
			skuPrice = 22.50,
			currentyCode = "USD",
				sku = {
					skuID = "12w2qw3ew2w3e4re4rfdreftgrthyghu",
					QATS = 1000,
					activeFlag = true,
					product = {
						productID = "2w3ew3e4re5rt5yt6y7uy8uijuhygthg",
						activeFlag = true
					}
				}
		};
		//------------------>
		variables.b.setProductBundleBuildID("1wq2we3we4reR5tr6Ty7uy7u8iu4re3x");
		assertEquals(b.getProductBundleBuildID(), "1wq2we3we4reR5tr6Ty7uy7u8iu4re3x");
		//variables.b.setProductBundleSku("1wq2we3we4reR5tr6Ty7uy7u8iu4re3z");
		variables.b.setProductBundleBuildName("Charm Necklace");
		variables.b.addProductBundleBuildItem(variables.pbBuildItem);
		variables.b.addProductBundleBuildItem(variables.pbBuildItem2);
		request.slatwallScope.getService("productService").saveProductBundleBuild(variables.b);
		//------------------>
		variables.pbBuild.addProductBundleBuildItem(variables.pbBuildItem);
		assert(variables.pbBuild.hasProductBundleBuildItem(), true);
		//has two build items
		variables.pbBuild.addProductBundleBuildItem(variables.pbBuildItem2);
		var items = variables.pbBuild.getProductBundleBuildItems();
		assert(ArrayLen(items) == 2);
		/*
		//test creating an orderitem from the build and build items.
		var order = variables.pbBuild.generateOrderItemsFromProductBundleBuild(variables.order);
		assert(!isNull(order.getOrderItems()));
		var count = 0;
		for (lines in order.getOrderItems()){
			count++;
			//assertEquals(lines.getOrderItemID(), "1wq2w");
		}
		assertEquals(count, 3);//parent + 2 children.
		
		variables.pbBuild.removeProductBundleBuildItem(variables.pbBuildItem2);
		assert(ArrayLen(variables.pbBuild.getProductBundleBuildItems()) == 1);
		//variables.pbBuild.removeProductBundleBuildItem(variables.pbBuildItem); 
		//Should have no items left.
		//assert(!variables.pbBuild.hasProductBundleBuildItem());
		assertEquals(variables.pbBuild.getProductBundleBuildID(), "1wq2we3we4reR5tr6Ty7uy7u8iu4re3w");
		*/
	}
		
}