component accessors="true" output="false" {

	property name="fw" type="any";

	property name="orderService" type="any";
	property name="paymentService" type="any";
	
	public void function init( required any fw ) {
		setFW( arguments.fw );
	}
	
	public void function before() {
		getFW().setView("paypalexpress:main.blank");
	}
	
	public void function initiatePayment( required struct rc ) {
		param name="arguments.rc.paymentMethodID" default=""; 
		
		var paymentMethod = getPaymentService().getPaymentMethod(rc.paymentMethodID);
		
		if(!isNull(paymentMethod) && paymentMethod.getIntegration().getIntegrationPackage() eq "paypalexpress") {
			var paymentCFC = paymentMethod.getIntegration().getIntegrationCFC( 'payment' );
			
			var responseData = paymentCFC.getInitiatePaymentData( paymentMethod=paymentMethod, order=request.slatwallScope.getCart() );
			
			if(structKeyExists(responseData, "ack") && responseData.ack == "Success" && structKeyExists(responseData, "token")) {
				location("https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=#responseData.token#", false);																										// Dynamic
			}
		}
	}
	
	public void function processResponse( required struct rc ) {
		param name="rc.paymentMethodID" default="";
		param name="rc.token" default="";
		
		var paymentMethod = getPaymentService().getPaymentMethod( rc.paymentMethodID );
		
		if(!isNull(paymentMethod) && paymentMethod.getIntegration().getIntegrationPackage() eq "paypalexpress") {
			
			var paymentCFC = paymentMethod.getIntegration().getIntegrationCFC( 'payment' );
			
			var responseData = paymentCFC.getPaymentResponseData( paymentMethod=paymentMethod, token=rc.token );
			
			if(structKeyExists(responseData, "ack") && responseData.ack == "Success") {
				
				// Setup newOrderPayment
				var paymentData = {};
				paymentData.newOrderPayment = {};
				paymentData.newOrderPayment.accountPaymentMethodID = '';
				paymentData.newOrderPayment.orderPaymentID = '';
				paymentData.newOrderPayment.amount = responseData.PAYMENTREQUEST_0_AMT;
				paymentData.newOrderPayment.paymentMethod.paymentMethodID = paymentMethod.getPaymentMethodID();
				paymentData.newOrderPayment.order.orderID = rc.$.slatwall.cart().getOrderID();
				paymentData.newOrderPayment.orderPaymentType.typeID = '444df2f0fed139ff94191de8fcd1f61b';
				paymentData.newOrderPayment.providerToken = responseData.token & '~' & responseData.payerID;
				
				var order = getOrderService().processOrder( rc.$.slatwall.cart(), paymentData, 'addOrderPayment');
				
				arguments.rc.$.slatwall.addActionResult( "public:cart.addOrderPayment", order.hasErrors() );
			}
		}
		
	}
	
	
}