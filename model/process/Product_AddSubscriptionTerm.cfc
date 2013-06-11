component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="product";

	// Data Properties
	property name="subscriptionTermID";
	property name="price" hb_rbKey="entity.sku.price";
	property name="listPrice" hb_rbKey="entity.sku.listPrice";
	property name="renewalPrice" hb_rbKey="entity.sku.renewalPrice";
	
	public any function getPrice() {
		if(!structKeyExists(variables, "price")) {
			variables.price = getProduct().getPrice();
		}
		return variables.price;
	}
	
	public any function getListPrice() {
		if(!structKeyExists(variables, "listPrice")) {
			variables.listPrice = getProduct().getListPrice();
		}
		return variables.listPrice;
	}
	
	public any function getRenewalPrice() {
		if(!structKeyExists(variables, "renewalPrice")) {
			variables.renewalPrice = getProduct().getRenewalPrice();
		}
		return variables.renewalPrice;
	}
	
}