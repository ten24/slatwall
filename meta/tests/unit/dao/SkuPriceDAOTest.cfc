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
component extends="Slatwall.meta.tests.unit.dao.SlatwallDAOTestBase" {


	public void function setUp() {
		super.setup();

		variables.dao = variables.mockService.getSkuPriceDAOMock();
	}

	/**
	* @test
	*/
	public void function getSkuPricesForSku_return_object_by_default() {
		var getSkuPriceRec = ormExecuteQuery("FROM SlatwallSkuPrice");
		assert(isArray(getSkuPriceRec));
		if(arrayLen(getSkuPriceRec)){
			var getSkuPricesForSku = variables.dao.getSkuPricesForSku(getSkuPriceRec[1].getskuID());
			if(!isnull(getSkuPricesForSku)){
				assert(isobject(getSkuPricesForSku));
			}else{
				assert(isNull(getSkuPricesForSku));
			}
		}else{
			var getSkuPricesForSku = variables.dao.getSkuPricesForSku('xxx');
			assert(isnull(getSkuPricesForSku));
		}
	}

	/**
	* @test
	*/
	public void function getSkuPricesForSkuByCurrencyCode_return_object_by_default() {
		var getSkuPriceRec = ormExecuteQuery("FROM SlatwallSkuPrice");
		assert(isArray(getSkuPriceRec));
		if(arrayLen(getSkuPriceRec)){
			var getSkuPricesForSkuByCurrencyCode = variables.dao.getSkuPricesForSkuByCurrencyCode(skuID = getSkuPriceRec[1].getskuID(),currencyCode = getSkuPriceRec[1].getcurrencyCode());
			if(!isnull(getSkuPricesForSkuByCurrencyCode)){
				assert(isobject(getSkuPricesForSkuByCurrencyCode));
			}else{
				assert(isNull(getSkuPricesForSkuByCurrencyCode));
			}
		}else{
			var getSkuPricesForSkuByCurrencyCode = variables.dao.getSkuPricesForSkuByCurrencyCode('xxx','yyy');
			assert(isnull(getSkuPricesForSkuByCurrencyCode));
		}
	}

	/**
	* @test
	*/
	public void function getBaseSkuPricesForSku_return_object_by_default() {
		var getSkuPriceRec = ormExecuteQuery("FROM SlatwallSkuPrice");
		assert(isArray(getSkuPriceRec));
		if(arrayLen(getSkuPriceRec)){
			var getBaseSkuPricesForSku = variables.dao.getBaseSkuPricesForSku(getSkuPriceRec[1].getskuID());
			if(!isnull(getBaseSkuPricesForSku)){
				assert(isobject(getBaseSkuPricesForSku));
			}else{
				assert(isNull(getBaseSkuPricesForSku));
			}
		}else{
			var getBaseSkuPricesForSku = variables.dao.getBaseSkuPricesForSku('xxx');
			assert(isnull(getBaseSkuPricesForSku));
		}
	}

	/**
	* @test
	*/
	public void function getBaseSkuPriceForSkuByCurrencyCode_return_object_by_default() {
		var getSkuPriceRec = ormExecuteQuery("FROM SlatwallSkuPrice");
		assert(isArray(getSkuPriceRec));
		if(arrayLen(getSkuPriceRec)){
			var getBaseSkuPriceForSkuByCurrencyCode = variables.dao.getBaseSkuPriceForSkuByCurrencyCode(skuID = getSkuPriceRec[1].getskuID(),currencyCode = getSkuPriceRec[1].getcurrencyCode());
			if(!isnull(getBaseSkuPriceForSkuByCurrencyCode)){
				assert(isobject(getBaseSkuPriceForSkuByCurrencyCode));
			}else{
				assert(isNull(getBaseSkuPriceForSkuByCurrencyCode));
			}
		}else{
			var getBaseSkuPriceForSkuByCurrencyCode = variables.dao.getBaseSkuPriceForSkuByCurrencyCode('xxx','yyy');
			assert(isnull(getBaseSkuPriceForSkuByCurrencyCode));
		}
	}

	/**
	* @test
	*/
	public void function getSkuPricesForSkuAndQuantity_return_object_by_default() {
		var getSkuPriceRec = ormExecuteQuery("FROM SlatwallSkuPrice");
		assert(isArray(getSkuPriceRec));
		if(arrayLen(getSkuPriceRec)){
			if(val(getSkuPriceRec[1].getminquantity())){
				var quantity = val(getSkuPriceRec[1].getminquantity());
			}else if(val(getSkuPriceRec[1].getmaxquantity())){
				var quantity = val(getSkuPriceRec[1].getmaxquantity());
			}else{
				var quantity = 0;
			}
			var getSkuPricesForSkuAndQuantity = variables.dao.getSkuPricesForSkuAndQuantity(skuID = getSkuPriceRec[1].getskuID(),quantity = quantity);
			if(!isnull(getSkuPricesForSkuAndQuantity)){
				assert(isobject(getSkuPricesForSkuAndQuantity));
			}else{
				assert(isNull(getSkuPricesForSkuAndQuantity));
			}
		}else{
			var getSkuPricesForSkuAndQuantity = variables.dao.getSkuPricesForSkuAndQuantity('xxx',10);
			assert(isnull(getSkuPricesForSkuAndQuantity));
		}
	}

	/**
	* @test
	*/
	public void function getSkuPricesForSkuCurrencyCodeAndQuantity_return_object_by_default() {
		var getSkuPriceRec = ormExecuteQuery("FROM SlatwallSkuPrice");
		assert(isArray(getSkuPriceRec));
		if(arrayLen(getSkuPriceRec)){
			if(val(getSkuPriceRec[1].getminquantity())){
				var quantity = val(getSkuPriceRec[1].getminquantity());
			}else if(val(getSkuPriceRec[1].getmaxquantity())){
				var quantity = val(getSkuPriceRec[1].getmaxquantity());
			}else{
				var quantity = 0;
			}
			var getSkuPricesForSkuCurrencyCodeAndQuantity = variables.dao.getSkuPricesForSkuCurrencyCodeAndQuantity(skuID = getSkuPriceRec[1].getskuID(),currencyCode = getSkuPriceRec[1].getcurrencyCode(),quantity = quantity);
			if(!isnull(getSkuPricesForSkuCurrencyCodeAndQuantity)){
				assert(isobject(getSkuPricesForSkuCurrencyCodeAndQuantity));
			}else{
				assert(isNull(getSkuPricesForSkuCurrencyCodeAndQuantity));
			}
		}else{
			var getSkuPricesForSkuCurrencyCodeAndQuantity = variables.dao.getSkuPricesForSkuCurrencyCodeAndQuantity('xxx','yyy',10);
			assert(isnull(getSkuPricesForSkuCurrencyCodeAndQuantity));
		}
	}

	/**
	* @test
	*/
	public void function getSkuPricesForSkuAndQuantityRange_return_object_by_default() {
		var getSkuPriceRec = ormExecuteQuery("FROM SlatwallSkuPrice");
		assert(isArray(getSkuPriceRec));
		if(arrayLen(getSkuPriceRec)){
			var getSkuPricesForSkuAndQuantityRange = variables.dao.getSkuPricesForSkuAndQuantityRange(skuID = getSkuPriceRec[1].getskuID(),minQuantity = val(getSkuPriceRec[1].getminquantity()), maxQuantity = val(getSkuPriceRec[1].getmaxquantity()));
			if(!isnull(getSkuPricesForSkuAndQuantityRange)){
				assert(isobject(getSkuPricesForSkuAndQuantityRange));
			}else{
				assert(isNull(getSkuPricesForSkuAndQuantityRange));
			}
		}else{
			var getSkuPricesForSkuAndQuantityRange = variables.dao.getSkuPricesForSkuAndQuantityRange('xxx',1,10);
			assert(isnull(getSkuPricesForSkuAndQuantityRange));
		}
	}

	/**
	* @test
	*/
	public void function getSkuPricesForSkuAndQuantityRangeByCurrencyCode_return_object_by_default() {
		var getSkuPriceRec = ormExecuteQuery("FROM SlatwallSkuPrice");
		assert(isArray(getSkuPriceRec));
		if(arrayLen(getSkuPriceRec)){
			var getSkuPricesForSkuAndQuantityRangeByCurrencyCode = variables.dao.getSkuPricesForSkuAndQuantityRangeByCurrencyCode(skuID = getSkuPriceRec[1].getskuID(),minQuantity = val(getSkuPriceRec[1].getminquantity()), maxQuantity = val(getSkuPriceRec[1].getmaxquantity()), currencyCode = getSkuPriceRec[1].getcurrencyCode());
			if(!isnull(getSkuPricesForSkuAndQuantityRangeByCurrencyCode)){
				assert(isobject(getSkuPricesForSkuAndQuantityRangeByCurrencyCode));
			}else{
				assert(isNull(getSkuPricesForSkuAndQuantityRangeByCurrencyCode));
			}
		}else{
			var getSkuPricesForSkuAndQuantityRangeByCurrencyCode = variables.dao.getSkuPricesForSkuAndQuantityRangeByCurrencyCode('xxx',1,10,'yyy');
			assert(isnull(getSkuPricesForSkuAndQuantityRangeByCurrencyCode));
		}
	}
}