/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

	// @hint put things in here that you want to run befor EACH test
	public void function setUp() {
		super.setup();

		variables.gcPaymentMethodID = "50d8cd61009931554764385482347f3a";
		variables.ccPaymentMethodID = "444df303dedc6dab69dd7ebcc9b8036a";

	}

	public void function isReturnWithGiftCardOrderPaymentTest_giftCardPaymentCase(){
		//ASSERT TRUE CASE GC PAYMENT WITH ORDER RETURN

		var order = request.slatwallScope.newEntity( 'order' );
		var processObject = order.getProcessObject("AddOrderPayment");
		var orderPayment = request.slatwallScope.newEntity( 'orderPayment' );
		var orderReturn = request.slatwallScope.newEntity('orderReturn');

		orderPayment.setPaymentMethod(request.slatwallScope.getService("PaymentService").getPaymentMethod(variables.gcPaymentMethodID));

		processObject.setNewOrderPayment(orderPayment);
		processObject.getOrder().addOrderReturn(orderReturn);

		assertTrue(processObject.isReturnWithGiftCardOrderPayment());

	}

	public void function isReturnWithGiftCardOrderPaymentTest_creditCardPaymentCase(){
		//ASSERT FALSE CC PAYMENT WITH ORDER RETURN

		var anotherOrder = request.slatwallScope.newEntity( 'order' );
		var anotherProcessObject = anotherOrder.getProcessObject("AddOrderPayment");
		var anotherOrderPayment = request.slatwallScope.newEntity( 'orderPayment' );
		var anotherOrderReturn = request.slatwallScope.newEntity('orderReturn');

		anotherOrderPayment.setPaymentMethod(request.slatwallScope.getService("PaymentService").getPaymentMethod(variables.ccPaymentMethodID));

		anotherProcessObject.setNewOrderPayment(anotherOrderPayment);
		anotherProcessObject.getOrder().addOrderReturn(anotherOrderReturn);

		assertFalse(anotherProcessObject.isReturnWithGiftCardOrderPayment());
	}

	public void function isReturnWithGiftCardOrderPaymentTest_noOrderReturnCase(){
		//ASSERT FALSE GC PAYMENT WITH NO ORDER RETURN

		var yetAnotherOrder = request.slatwallScope.newEntity( 'order' );
		var yetAnotherProcessObject = yetAnotherOrder.getProcessObject("AddOrderPayment");
		var yetAnotherOrderPayment = request.slatwallScope.newEntity( 'orderPayment' );
		var orderItem = request.slatwallScope.newEntity('orderItem');

		yetAnotherOrder.addOrderItem(orderItem);

		yetAnotherOrderPayment.setPaymentMethod(request.slatwallScope.getService("PaymentService").getPaymentMethod(variables.gcPaymentMethodID));

		yetAnotherProcessObject.setNewOrderPayment(yetAnotherOrderPayment);

		addToDebug(yetAnotherProcessObject.isReturnWithGiftCardOrderPayment());

		assertFalse(yetAnotherProcessObject.isReturnWithGiftCardOrderPayment());
	}

}
