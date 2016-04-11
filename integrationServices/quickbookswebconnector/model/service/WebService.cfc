<!---

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

--->
<cfcomponent extends="Slatwall.org.Hibachi.HibachiService" style="document" persistent="false" namespace="http://developer.intuit.com/" accessors="true" output="false">

	<cfscript>
		variables.tickets = {};

		public string function getQuickbooksGUID(){
			return insert("-",createUUID(),23);
		}


		public any function asQBXML(required string action){

			QBXMLrequest = XmlNew();
			QBXMLrequest.xmlRoot = XmlElemNew(QBXMLrequest,"QBXML");

			//depending on the action append the necessary information to the xml string
			//function for each action we need

		}

		/* Example QBXML For Account Query
		<?xml version="1.0" encoding="utf-8"?>
		<?qbxml version="13.0"?>
		<QBXML>
			<QBXMLMsgsRq onError="stopOnError">
			<AccountQueryRq metaData="ENUMTYPE">
					<!-- BEGIN OR -->
					<ListID >IDTYPE</ListID> <!-- optional, may repeat -->
					<!-- OR -->
					<FullName >STRTYPE</FullName> <!-- optional, may repeat -->
					<!-- OR -->
					<MaxReturned >INTTYPE</MaxReturned> <!-- optional -->
					<!-- ActiveStatus may have one of the following values: ActiveOnly [DEFAULT], InactiveOnly, All -->
					<ActiveStatus >ENUMTYPE</ActiveStatus> <!-- optional -->
					<FromModifiedDate >DATETIMETYPE</FromModifiedDate> <!-- optional -->
					<ToModifiedDate >DATETIMETYPE</ToModifiedDate> <!-- optional -->
					<!-- BEGIN OR -->
					<NameFilter> <!-- optional -->
					<!-- MatchCriterion may have one of the following values: StartsWith, Contains, EndsWith -->
					<MatchCriterion >ENUMTYPE</MatchCriterion> <!-- required -->
					<Name >STRTYPE</Name> <!-- required -->
					</NameFilter>
					<!-- OR -->
					<NameRangeFilter> <!-- optional -->
					<FromName >STRTYPE</FromName> <!-- optional -->
					<ToName >STRTYPE</ToName> <!-- optional -->
					</NameRangeFilter>
					<!-- END OR -->
					<!-- AccountType may have one of the following values: AccountsPayable, AccountsReceivable, Bank, CostOfGoodsSold, CreditCard, Equity, Expense, FixedAsset, Income, LongTermLiability, NonPosting, OtherAsset, OtherCurrentAsset, OtherCurrentLiability, OtherExpense, OtherIncome -->
					<AccountType >ENUMTYPE</AccountType> <!-- optional, may repeat -->
					<CurrencyFilter> <!-- optional -->
					<!-- BEGIN OR -->
					<ListID >IDTYPE</ListID> <!-- optional, may repeat -->
					<!-- OR -->
					<FullName >STRTYPE</FullName> <!-- optional, may repeat -->
					<!-- END OR -->
					</CurrencyFilter>
					<!-- END OR -->
					<IncludeRetElement >STRTYPE</IncludeRetElement> <!-- optional, may repeat -->
					<OwnerID >GUIDTYPE</OwnerID> <!-- optional, may repeat -->
			</AccountQueryRq>


			<AccountQueryRs statusCode="INTTYPE" statusSeverity="STRTYPE" statusMessage="STRTYPE" retCount="INTTYPE">
					<AccountRet> <!-- optional, may repeat -->
					<ListID >IDTYPE</ListID> <!-- required -->
					<TimeCreated >DATETIMETYPE</TimeCreated> <!-- required -->
					<TimeModified >DATETIMETYPE</TimeModified> <!-- required -->
					<EditSequence >STRTYPE</EditSequence> <!-- required -->
					<Name >STRTYPE</Name> <!-- required -->
					<FullName >STRTYPE</FullName> <!-- required -->
					<IsActive >BOOLTYPE</IsActive> <!-- optional -->
					<ParentRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</ParentRef>
					<Sublevel >INTTYPE</Sublevel> <!-- required -->
					<!-- AccountType may have one of the following values: AccountsPayable, AccountsReceivable, Bank, CostOfGoodsSold, CreditCard, Equity, Expense, FixedAsset, Income, LongTermLiability, NonPosting, OtherAsset, OtherCurrentAsset, OtherCurrentLiability, OtherExpense, OtherIncome -->
					<AccountType >ENUMTYPE</AccountType> <!-- required -->
					<!-- SpecialAccountType may have one of the following values: AccountsPayable, AccountsReceivable, CondenseItemAdjustmentExpenses, CostOfGoodsSold, DirectDepositLiabilities, Estimates, ExchangeGainLoss, InventoryAssets, ItemReceiptAccount, OpeningBalanceEquity, PayrollExpenses, PayrollLiabilities, PettyCash, PurchaseOrders, ReconciliationDifferences, RetainedEarnings, SalesOrders, SalesTaxPayable, UncategorizedExpenses, UncategorizedIncome, UndepositedFunds -->
					<SpecialAccountType >ENUMTYPE</SpecialAccountType> <!-- optional -->
					<AccountNumber >STRTYPE</AccountNumber> <!-- optional -->
					<BankNumber >STRTYPE</BankNumber> <!-- optional -->
					<Desc >STRTYPE</Desc> <!-- optional -->
					<Balance >AMTTYPE</Balance> <!-- optional -->
					<TotalBalance >AMTTYPE</TotalBalance> <!-- optional -->
					<TaxLineInfoRet> <!-- optional -->
					<TaxLineID >INTTYPE</TaxLineID> <!-- required -->
					<TaxLineName >STRTYPE</TaxLineName> <!-- optional -->
					</TaxLineInfoRet>
					<!-- CashFlowClassification may have one of the following values: None, Operating, Investing, Financing, NotApplicable -->
					<CashFlowClassification >ENUMTYPE</CashFlowClassification> <!-- optional -->
					<CurrencyRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</CurrencyRef>
					<DataExtRet> <!-- optional, may repeat -->
					<OwnerID >GUIDTYPE</OwnerID> <!-- optional -->
					<DataExtName >STRTYPE</DataExtName> <!-- required -->
					<!-- DataExtType may have one of the following values: AMTTYPE, DATETIMETYPE, INTTYPE, PERCENTTYPE, PRICETYPE, QUANTYPE, STR1024TYPE, STR255TYPE -->
					<DataExtType >ENUMTYPE</DataExtType> <!-- required -->
					<DataExtValue >STRTYPE</DataExtValue> <!-- required -->
					</DataExtRet>
					</AccountRet>
			</AccountQueryRs>
			</QBXMLMsgsRq>
		</QBXML>



		*/
		public any function syncAccountLedger(){

		}

		/* Example QBXML for Inventory Item Add
		<?xml version="1.0" encoding="utf-8"?>
		<?qbxml version="13.0"?>
		<QBXML>
			<QBXMLMsgsRq onError="stopOnError">
				<ItemInventoryAddRq>
					<ItemInventoryAdd> <!-- required -->
					<Name >STRTYPE</Name> <!-- required -->
					<BarCode> <!-- optional -->
					<BarCodeValue >STRTYPE</BarCodeValue> <!-- optional -->
					<AssignEvenIfUsed >BOOLTYPE</AssignEvenIfUsed> <!-- optional -->
					<AllowOverride >BOOLTYPE</AllowOverride> <!-- optional -->
					</BarCode>
					<IsActive >BOOLTYPE</IsActive> <!-- optional -->
					<ClassRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</ClassRef>
					<ParentRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</ParentRef>
					<ManufacturerPartNumber >STRTYPE</ManufacturerPartNumber> <!-- optional -->
					<UnitOfMeasureSetRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</UnitOfMeasureSetRef>
					<SalesTaxCodeRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</SalesTaxCodeRef>
					<SalesDesc >STRTYPE</SalesDesc> <!-- optional -->
					<SalesPrice >PRICETYPE</SalesPrice> <!-- optional -->
					<IncomeAccountRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</IncomeAccountRef>
					<PurchaseDesc >STRTYPE</PurchaseDesc> <!-- optional -->
					<PurchaseCost >PRICETYPE</PurchaseCost> <!-- optional -->
					<COGSAccountRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</COGSAccountRef>
					<PrefVendorRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</PrefVendorRef>
					<AssetAccountRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</AssetAccountRef>
					<ReorderPoint >QUANTYPE</ReorderPoint> <!-- optional -->
					<Max >QUANTYPE</Max> <!-- optional -->
					<QuantityOnHand >QUANTYPE</QuantityOnHand> <!-- optional -->
					<TotalValue >AMTTYPE</TotalValue> <!-- optional -->
					<InventoryDate >DATETYPE</InventoryDate> <!-- optional -->
					<ExternalGUID >GUIDTYPE</ExternalGUID> <!-- optional -->
					</ItemInventoryAdd>
					<IncludeRetElement >STRTYPE</IncludeRetElement> <!-- optional, may repeat -->
				</ItemInventoryAddRq>
				<ItemInventoryAddRs statusCode="INTTYPE" statusSeverity="STRTYPE" statusMessage="STRTYPE">
					<ItemInventoryRet> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- required -->
					<TimeCreated >DATETIMETYPE</TimeCreated> <!-- required -->
					<TimeModified >DATETIMETYPE</TimeModified> <!-- required -->
					<EditSequence >STRTYPE</EditSequence> <!-- required -->
					<Name >STRTYPE</Name> <!-- required -->
					<FullName >STRTYPE</FullName> <!-- required -->
					<BarCodeValue >STRTYPE</BarCodeValue> <!-- optional -->
					<IsActive >BOOLTYPE</IsActive> <!-- optional -->
					<ClassRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</ClassRef>
					<ParentRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</ParentRef>
					<Sublevel >INTTYPE</Sublevel> <!-- required -->
					<ManufacturerPartNumber >STRTYPE</ManufacturerPartNumber> <!-- optional -->
					<UnitOfMeasureSetRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</UnitOfMeasureSetRef>
					<SalesTaxCodeRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</SalesTaxCodeRef>
					<SalesDesc >STRTYPE</SalesDesc> <!-- optional -->
					<SalesPrice >PRICETYPE</SalesPrice> <!-- optional -->
					<IncomeAccountRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</IncomeAccountRef>
					<PurchaseDesc >STRTYPE</PurchaseDesc> <!-- optional -->
					<PurchaseCost >PRICETYPE</PurchaseCost> <!-- optional -->
					<COGSAccountRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</COGSAccountRef>
					<PrefVendorRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</PrefVendorRef>
					<AssetAccountRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</AssetAccountRef>
					<ReorderPoint >QUANTYPE</ReorderPoint> <!-- optional -->
					<Max >QUANTYPE</Max> <!-- optional -->
					<QuantityOnHand >QUANTYPE</QuantityOnHand> <!-- optional -->
					<AverageCost >PRICETYPE</AverageCost> <!-- optional -->
					<QuantityOnOrder >QUANTYPE</QuantityOnOrder> <!-- optional -->
					<QuantityOnSalesOrder >QUANTYPE</QuantityOnSalesOrder> <!-- optional -->
					<ExternalGUID >GUIDTYPE</ExternalGUID> <!-- optional -->
					<DataExtRet> <!-- optional, may repeat -->
					<OwnerID >GUIDTYPE</OwnerID> <!-- optional -->
					<DataExtName >STRTYPE</DataExtName> <!-- required -->
					<!-- DataExtType may have one of the following values: AMTTYPE, DATETIMETYPE, INTTYPE, PERCENTTYPE, PRICETYPE, QUANTYPE, STR1024TYPE, STR255TYPE -->
					<DataExtType >ENUMTYPE</DataExtType> <!-- required -->
					<DataExtValue >STRTYPE</DataExtValue> <!-- required -->
					</DataExtRet>
					</ItemInventoryRet>
					<ErrorRecovery> <!-- optional -->
					<!-- BEGIN OR -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<!-- OR -->
					<OwnerID >GUIDTYPE</OwnerID> <!-- optional -->
					<!-- OR -->
					<TxnID >IDTYPE</TxnID> <!-- optional -->
					<!-- END OR -->
					<TxnNumber >INTTYPE</TxnNumber> <!-- optional -->
					<EditSequence >STRTYPE</EditSequence> <!-- optional -->
					<ExternalGUID >GUIDTYPE</ExternalGUID> <!-- optional -->
					</ErrorRecovery>
				</ItemInventoryAddRs>
			</QBXMLMsgsRq>
		</QBXML>
		*/
		public any function pushProduct(){

		}

		/* Example QBXML for Account Add
		<?xml version="1.0" encoding="utf-8"?>
		<?qbxml version="13.0"?>
		<QBXML>
			<QBXMLMsgsRq onError="stopOnError">
				<AccountAddRq>
					<AccountAdd> <!-- required -->
						<Name >STRTYPE</Name> <!-- required -->
						<IsActive >BOOLTYPE</IsActive> <!-- optional -->
						<ParentRef> <!-- optional -->
						<ListID >IDTYPE</ListID> <!-- optional -->
						<FullName >STRTYPE</FullName> <!-- optional -->
						</ParentRef>
						<!-- AccountType may have one of the following values: AccountsPayable, AccountsReceivable, Bank, CostOfGoodsSold, CreditCard, Equity, Expense, FixedAsset, Income, LongTermLiability, NonPosting, OtherAsset, OtherCurrentAsset, OtherCurrentLiability, OtherExpense, OtherIncome -->
						<AccountType >ENUMTYPE</AccountType> <!-- required -->
						<AccountNumber >STRTYPE</AccountNumber> <!-- optional -->
						<BankNumber >STRTYPE</BankNumber> <!-- optional -->
						<Desc >STRTYPE</Desc> <!-- optional -->
						<OpenBalance >AMTTYPE</OpenBalance> <!-- optional -->
						<OpenBalanceDate >DATETYPE</OpenBalanceDate> <!-- optional -->
						<TaxLineID >INTTYPE</TaxLineID> <!-- optional -->
						<CurrencyRef> <!-- optional -->
						<ListID >IDTYPE</ListID> <!-- optional -->
						<FullName >STRTYPE</FullName> <!-- optional -->
						</CurrencyRef>
					</AccountAdd>
					<IncludeRetElement >STRTYPE</IncludeRetElement> <!-- optional, may repeat -->
				</AccountAddRq>
				<AccountAddRs statusCode="INTTYPE" statusSeverity="STRTYPE" statusMessage="STRTYPE">
					<AccountRet> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- required -->
					<TimeCreated >DATETIMETYPE</TimeCreated> <!-- required -->
					<TimeModified >DATETIMETYPE</TimeModified> <!-- required -->
					<EditSequence >STRTYPE</EditSequence> <!-- required -->
					<Name >STRTYPE</Name> <!-- required -->
					<FullName >STRTYPE</FullName> <!-- required -->
					<IsActive >BOOLTYPE</IsActive> <!-- optional -->
					<ParentRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</ParentRef>
					<Sublevel >INTTYPE</Sublevel> <!-- required -->
					<!-- AccountType may have one of the following values: AccountsPayable, AccountsReceivable, Bank, CostOfGoodsSold, CreditCard, Equity, Expense, FixedAsset, Income, LongTermLiability, NonPosting, OtherAsset, OtherCurrentAsset, OtherCurrentLiability, OtherExpense, OtherIncome -->
					<AccountType >ENUMTYPE</AccountType> <!-- required -->
					<!-- SpecialAccountType may have one of the following values: AccountsPayable, AccountsReceivable, CondenseItemAdjustmentExpenses, CostOfGoodsSold, DirectDepositLiabilities, Estimates, ExchangeGainLoss, InventoryAssets, ItemReceiptAccount, OpeningBalanceEquity, PayrollExpenses, PayrollLiabilities, PettyCash, PurchaseOrders, ReconciliationDifferences, RetainedEarnings, SalesOrders, SalesTaxPayable, UncategorizedExpenses, UncategorizedIncome, UndepositedFunds -->
					<SpecialAccountType >ENUMTYPE</SpecialAccountType> <!-- optional -->
					<AccountNumber >STRTYPE</AccountNumber> <!-- optional -->
					<BankNumber >STRTYPE</BankNumber> <!-- optional -->
					<Desc >STRTYPE</Desc> <!-- optional -->
					<Balance >AMTTYPE</Balance> <!-- optional -->
					<TotalBalance >AMTTYPE</TotalBalance> <!-- optional -->
					<TaxLineInfoRet> <!-- optional -->
					<TaxLineID >INTTYPE</TaxLineID> <!-- required -->
					<TaxLineName >STRTYPE</TaxLineName> <!-- optional -->
					</TaxLineInfoRet>
					<!-- CashFlowClassification may have one of the following values: None, Operating, Investing, Financing, NotApplicable -->
					<CashFlowClassification >ENUMTYPE</CashFlowClassification> <!-- optional -->
					<CurrencyRef> <!-- optional -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<FullName >STRTYPE</FullName> <!-- optional -->
					</CurrencyRef>
					<DataExtRet> <!-- optional, may repeat -->
					<OwnerID >GUIDTYPE</OwnerID> <!-- optional -->
					<DataExtName >STRTYPE</DataExtName> <!-- required -->
					<!-- DataExtType may have one of the following values: AMTTYPE, DATETIMETYPE, INTTYPE, PERCENTTYPE, PRICETYPE, QUANTYPE, STR1024TYPE, STR255TYPE -->
					<DataExtType >ENUMTYPE</DataExtType> <!-- required -->
					<DataExtValue >STRTYPE</DataExtValue> <!-- required -->
					</DataExtRet>
					</AccountRet>
					<ErrorRecovery> <!-- optional -->
					<!-- BEGIN OR -->
					<ListID >IDTYPE</ListID> <!-- optional -->
					<!-- OR -->
					<OwnerID >GUIDTYPE</OwnerID> <!-- optional -->
					<!-- OR -->
					<TxnID >IDTYPE</TxnID> <!-- optional -->
					<!-- END OR -->
					<TxnNumber >INTTYPE</TxnNumber> <!-- optional -->
					<EditSequence >STRTYPE</EditSequence> <!-- optional -->
					<ExternalGUID >GUIDTYPE</ExternalGUID> <!-- optional -->
					</ErrorRecovery>
				</AccountAddRs>
			</QBXMLMsgsRq>
		</QBXML>
		 */
		public any function pushAccounts(){

		}

		/* Example QBXML for Order Add
		<?xml version="1.0" encoding="utf-8"?>
		<?qbxml version="13.0"?>
		<QBXML>
		<QBXMLMsgsRq onError="stopOnError">
			<SalesOrderAddRq>
				<SalesOrderAdd defMacro="MACROTYPE"> <!-- required -->
				<CustomerRef> <!-- required -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</CustomerRef>
				<ClassRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</ClassRef>
				<TemplateRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</TemplateRef>
				<TxnDate >DATETYPE</TxnDate> <!-- optional -->
				<RefNumber >STRTYPE</RefNumber> <!-- optional -->
				<BillAddress> <!-- optional -->
				<Addr1 >STRTYPE</Addr1> <!-- optional -->
				<Addr2 >STRTYPE</Addr2> <!-- optional -->
				<Addr3 >STRTYPE</Addr3> <!-- optional -->
				<Addr4 >STRTYPE</Addr4> <!-- optional -->
				<Addr5 >STRTYPE</Addr5> <!-- optional -->
				<City >STRTYPE</City> <!-- optional -->
				<State >STRTYPE</State> <!-- optional -->
				<PostalCode >STRTYPE</PostalCode> <!-- optional -->
				<Country >STRTYPE</Country> <!-- optional -->
				<Note >STRTYPE</Note> <!-- optional -->
				</BillAddress>
				<ShipAddress> <!-- optional -->
				<Addr1 >STRTYPE</Addr1> <!-- optional -->
				<Addr2 >STRTYPE</Addr2> <!-- optional -->
				<Addr3 >STRTYPE</Addr3> <!-- optional -->
				<Addr4 >STRTYPE</Addr4> <!-- optional -->
				<Addr5 >STRTYPE</Addr5> <!-- optional -->
				<City >STRTYPE</City> <!-- optional -->
				<State >STRTYPE</State> <!-- optional -->
				<PostalCode >STRTYPE</PostalCode> <!-- optional -->
				<Country >STRTYPE</Country> <!-- optional -->
				<Note >STRTYPE</Note> <!-- optional -->
				</ShipAddress>
				<PONumber >STRTYPE</PONumber> <!-- optional -->
				<TermsRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</TermsRef>
				<DueDate >DATETYPE</DueDate> <!-- optional -->
				<SalesRepRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</SalesRepRef>
				<FOB >STRTYPE</FOB> <!-- optional -->
				<ShipDate >DATETYPE</ShipDate> <!-- optional -->
				<ShipMethodRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</ShipMethodRef>
				<ItemSalesTaxRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</ItemSalesTaxRef>
				<IsManuallyClosed >BOOLTYPE</IsManuallyClosed> <!-- optional -->
				<Memo >STRTYPE</Memo> <!-- optional -->
				<CustomerMsgRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</CustomerMsgRef>
				<IsToBePrinted >BOOLTYPE</IsToBePrinted> <!-- optional -->
				<IsToBeEmailed >BOOLTYPE</IsToBeEmailed> <!-- optional -->
				<CustomerSalesTaxCodeRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</CustomerSalesTaxCodeRef>
				<Other >STRTYPE</Other> <!-- optional -->
				<ExchangeRate >FLOATTYPE</ExchangeRate> <!-- optional -->
				<ExternalGUID >GUIDTYPE</ExternalGUID> <!-- optional -->
				<!-- BEGIN OR -->
				<SalesOrderLineAdd> <!-- optional -->
				<ItemRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</ItemRef>
				<Desc >STRTYPE</Desc> <!-- optional -->
				<Quantity >QUANTYPE</Quantity> <!-- optional -->
				<UnitOfMeasure >STRTYPE</UnitOfMeasure> <!-- optional -->
				<!-- BEGIN OR -->
				<Rate >PRICETYPE</Rate> <!-- optional -->
				<!-- OR -->
				<RatePercent >PERCENTTYPE</RatePercent> <!-- optional -->
				<!-- OR -->
				<PriceLevelRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</PriceLevelRef>
				<!-- END OR -->
				<ClassRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</ClassRef>
				<Amount >AMTTYPE</Amount> <!-- optional -->
				<!-- OptionForPriceRuleConflict may have one of the following values: Zero, BasePrice -->
				<OptionForPriceRuleConflict >ENUMTYPE</OptionForPriceRuleConflict> <!-- optional -->
				<InventorySiteRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</InventorySiteRef>
				<InventorySiteLocationRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</InventorySiteLocationRef>
				<!-- BEGIN OR -->
				<SerialNumber >STRTYPE</SerialNumber> <!-- optional -->
				<!-- OR -->
				<LotNumber >STRTYPE</LotNumber> <!-- optional -->
				<!-- END OR -->
				<SalesTaxCodeRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</SalesTaxCodeRef>
				<IsManuallyClosed >BOOLTYPE</IsManuallyClosed> <!-- optional -->
				<Other1 >STRTYPE</Other1> <!-- optional -->
				<Other2 >STRTYPE</Other2> <!-- optional -->
				<DataExt> <!-- optional, may repeat -->
				<OwnerID >GUIDTYPE</OwnerID> <!-- required -->
				<DataExtName >STRTYPE</DataExtName> <!-- required -->
				<DataExtValue >STRTYPE</DataExtValue> <!-- required -->
				</DataExt>
				</SalesOrderLineAdd>
				<!-- OR -->
				<SalesOrderLineGroupAdd> <!-- optional -->
				<ItemGroupRef> <!-- required -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</ItemGroupRef>
				<Quantity >QUANTYPE</Quantity> <!-- optional -->
				<UnitOfMeasure >STRTYPE</UnitOfMeasure> <!-- optional -->
				<InventorySiteRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</InventorySiteRef>
				<InventorySiteLocationRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</InventorySiteLocationRef>
				<DataExt> <!-- optional, may repeat -->
				<OwnerID >GUIDTYPE</OwnerID> <!-- required -->
				<DataExtName >STRTYPE</DataExtName> <!-- required -->
				<DataExtValue >STRTYPE</DataExtValue> <!-- required -->
				</DataExt>
				</SalesOrderLineGroupAdd>
				<!-- END OR -->
				</SalesOrderAdd>
				<IncludeRetElement >STRTYPE</IncludeRetElement> <!-- optional, may repeat -->
			</SalesOrderAddRq>
		<SalesOrderAddRs statusCode="INTTYPE" statusSeverity="STRTYPE" statusMessage="STRTYPE">
			<SalesOrderRet> <!-- optional -->
				<TxnID >IDTYPE</TxnID> <!-- required -->
				<TimeCreated >DATETIMETYPE</TimeCreated> <!-- required -->
				<TimeModified >DATETIMETYPE</TimeModified> <!-- required -->
				<EditSequence >STRTYPE</EditSequence> <!-- required -->
				<TxnNumber >INTTYPE</TxnNumber> <!-- optional -->
				<CustomerRef> <!-- required -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</CustomerRef>
				<ClassRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</ClassRef>
				<TemplateRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</TemplateRef>
				<TxnDate >DATETYPE</TxnDate> <!-- required -->
				<RefNumber >STRTYPE</RefNumber> <!-- optional -->
				<BillAddress> <!-- optional -->
				<Addr1 >STRTYPE</Addr1> <!-- optional -->
				<Addr2 >STRTYPE</Addr2> <!-- optional -->
				<Addr3 >STRTYPE</Addr3> <!-- optional -->
				<Addr4 >STRTYPE</Addr4> <!-- optional -->
				<Addr5 >STRTYPE</Addr5> <!-- optional -->
				<City >STRTYPE</City> <!-- optional -->
				<State >STRTYPE</State> <!-- optional -->
				<PostalCode >STRTYPE</PostalCode> <!-- optional -->
				<Country >STRTYPE</Country> <!-- optional -->
				<Note >STRTYPE</Note> <!-- optional -->
				</BillAddress>
				<BillAddressBlock> <!-- optional -->
				<Addr1 >STRTYPE</Addr1> <!-- optional -->
				<Addr2 >STRTYPE</Addr2> <!-- optional -->
				<Addr3 >STRTYPE</Addr3> <!-- optional -->
				<Addr4 >STRTYPE</Addr4> <!-- optional -->
				<Addr5 >STRTYPE</Addr5> <!-- optional -->
				</BillAddressBlock>
				<ShipAddress> <!-- optional -->
				<Addr1 >STRTYPE</Addr1> <!-- optional -->
				<Addr2 >STRTYPE</Addr2> <!-- optional -->
				<Addr3 >STRTYPE</Addr3> <!-- optional -->
				<Addr4 >STRTYPE</Addr4> <!-- optional -->
				<Addr5 >STRTYPE</Addr5> <!-- optional -->
				<City >STRTYPE</City> <!-- optional -->
				<State >STRTYPE</State> <!-- optional -->
				<PostalCode >STRTYPE</PostalCode> <!-- optional -->
				<Country >STRTYPE</Country> <!-- optional -->
				<Note >STRTYPE</Note> <!-- optional -->
				</ShipAddress>
				<ShipAddressBlock> <!-- optional -->
				<Addr1 >STRTYPE</Addr1> <!-- optional -->
				<Addr2 >STRTYPE</Addr2> <!-- optional -->
				<Addr3 >STRTYPE</Addr3> <!-- optional -->
				<Addr4 >STRTYPE</Addr4> <!-- optional -->
				<Addr5 >STRTYPE</Addr5> <!-- optional -->
				</ShipAddressBlock>
				<PONumber >STRTYPE</PONumber> <!-- optional -->
				<TermsRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</TermsRef>
				<DueDate >DATETYPE</DueDate> <!-- optional -->
				<SalesRepRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</SalesRepRef>
				<FOB >STRTYPE</FOB> <!-- optional -->
				<ShipDate >DATETYPE</ShipDate> <!-- optional -->
				<ShipMethodRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</ShipMethodRef>
				<Subtotal >AMTTYPE</Subtotal> <!-- optional -->
				<ItemSalesTaxRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</ItemSalesTaxRef>
				<SalesTaxPercentage >PERCENTTYPE</SalesTaxPercentage> <!-- optional -->
				<SalesTaxTotal >AMTTYPE</SalesTaxTotal> <!-- optional -->
				<TotalAmount >AMTTYPE</TotalAmount> <!-- optional -->
				<CurrencyRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</CurrencyRef>
				<ExchangeRate >FLOATTYPE</ExchangeRate> <!-- optional -->
				<TotalAmountInHomeCurrency >AMTTYPE</TotalAmountInHomeCurrency> <!-- optional -->
				<IsManuallyClosed >BOOLTYPE</IsManuallyClosed> <!-- optional -->
				<IsFullyInvoiced >BOOLTYPE</IsFullyInvoiced> <!-- optional -->
				<Memo >STRTYPE</Memo> <!-- optional -->
				<CustomerMsgRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</CustomerMsgRef>
				<IsToBePrinted >BOOLTYPE</IsToBePrinted> <!-- optional -->
				<IsToBeEmailed >BOOLTYPE</IsToBeEmailed> <!-- optional -->
				<CustomerSalesTaxCodeRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</CustomerSalesTaxCodeRef>
				<Other >STRTYPE</Other> <!-- optional -->
				<ExternalGUID >GUIDTYPE</ExternalGUID> <!-- optional -->
				<LinkedTxn> <!-- optional, may repeat -->
				<TxnID >IDTYPE</TxnID> <!-- required -->
				<!-- TxnType may have one of the following values: ARRefundCreditCard, Bill, BillPaymentCheck, BillPaymentCreditCard, BuildAssembly, Charge, Check, CreditCardCharge, CreditCardCredit, CreditMemo, Deposit, Estimate, InventoryAdjustment, Invoice, ItemReceipt, JournalEntry, LiabilityAdjustment, Paycheck, PayrollLiabilityCheck, PurchaseOrder, ReceivePayment, SalesOrder, SalesReceipt, SalesTaxPaymentCheck, Transfer, VendorCredit, YTDAdjustment -->
				<TxnType >ENUMTYPE</TxnType> <!-- required -->
				<TxnDate >DATETYPE</TxnDate> <!-- required -->
				<RefNumber >STRTYPE</RefNumber> <!-- optional -->
				<!-- LinkType may have one of the following values: AMTTYPE, QUANTYPE -->
				<LinkType >ENUMTYPE</LinkType> <!-- optional -->
				<Amount >AMTTYPE</Amount> <!-- required -->
				</LinkedTxn>
				<!-- BEGIN OR -->
				<SalesOrderLineRet> <!-- optional -->
				<TxnLineID >IDTYPE</TxnLineID> <!-- required -->
				<ItemRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</ItemRef>
				<Desc >STRTYPE</Desc> <!-- optional -->
				<Quantity >QUANTYPE</Quantity> <!-- optional -->
				<UnitOfMeasure >STRTYPE</UnitOfMeasure> <!-- optional -->
				<OverrideUOMSetRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</OverrideUOMSetRef>
				<!-- BEGIN OR -->
				<Rate >PRICETYPE</Rate> <!-- optional -->
				<!-- OR -->
				<RatePercent >PERCENTTYPE</RatePercent> <!-- optional -->
				<!-- END OR -->
				<ClassRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</ClassRef>
				<Amount >AMTTYPE</Amount> <!-- optional -->
				<InventorySiteRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</InventorySiteRef>
				<InventorySiteLocationRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</InventorySiteLocationRef>
				<!-- BEGIN OR -->
				<SerialNumber >STRTYPE</SerialNumber> <!-- optional -->
				<!-- OR -->
				<LotNumber >STRTYPE</LotNumber> <!-- optional -->
				<!-- END OR -->
				<SalesTaxCodeRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</SalesTaxCodeRef>
				<Invoiced >QUANTYPE</Invoiced> <!-- optional -->
				<IsManuallyClosed >BOOLTYPE</IsManuallyClosed> <!-- optional -->
				<Other1 >STRTYPE</Other1> <!-- optional -->
				<Other2 >STRTYPE</Other2> <!-- optional -->
				<DataExtRet> <!-- optional, may repeat -->
				<OwnerID >GUIDTYPE</OwnerID> <!-- optional -->
				<DataExtName >STRTYPE</DataExtName> <!-- required -->
				<!-- DataExtType may have one of the following values: AMTTYPE, DATETIMETYPE, INTTYPE, PERCENTTYPE, PRICETYPE, QUANTYPE, STR1024TYPE, STR255TYPE -->
				<DataExtType >ENUMTYPE</DataExtType> <!-- required -->
				<DataExtValue >STRTYPE</DataExtValue> <!-- required -->
				</DataExtRet>
				</SalesOrderLineRet>
				<!-- OR -->
				<SalesOrderLineGroupRet> <!-- optional -->
				<TxnLineID >IDTYPE</TxnLineID> <!-- required -->
				<ItemGroupRef> <!-- required -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</ItemGroupRef>
				<Desc >STRTYPE</Desc> <!-- optional -->
				<Quantity >QUANTYPE</Quantity> <!-- optional -->
				<UnitOfMeasure >STRTYPE</UnitOfMeasure> <!-- optional -->
				<OverrideUOMSetRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</OverrideUOMSetRef>
				<IsPrintItemsInGroup >BOOLTYPE</IsPrintItemsInGroup> <!-- required -->
				<TotalAmount >AMTTYPE</TotalAmount> <!-- required -->
				<SalesOrderLineRet> <!-- optional, may repeat -->
				<TxnLineID >IDTYPE</TxnLineID> <!-- required -->
				<ItemRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</ItemRef>
				<Desc >STRTYPE</Desc> <!-- optional -->
				<Quantity >QUANTYPE</Quantity> <!-- optional -->
				<UnitOfMeasure >STRTYPE</UnitOfMeasure> <!-- optional -->
				<OverrideUOMSetRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</OverrideUOMSetRef>
				<!-- BEGIN OR -->
				<Rate >PRICETYPE</Rate> <!-- optional -->
				<!-- OR -->
				<RatePercent >PERCENTTYPE</RatePercent> <!-- optional -->
				<!-- END OR -->
				<ClassRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</ClassRef>
				<Amount >AMTTYPE</Amount> <!-- optional -->
				<InventorySiteRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</InventorySiteRef>
				<InventorySiteLocationRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</InventorySiteLocationRef>
				<!-- BEGIN OR -->
				<SerialNumber >STRTYPE</SerialNumber> <!-- optional -->
				<!-- OR -->
				<LotNumber >STRTYPE</LotNumber> <!-- optional -->
				<!-- END OR -->
				<SalesTaxCodeRef> <!-- optional -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<FullName >STRTYPE</FullName> <!-- optional -->
				</SalesTaxCodeRef>
				<Invoiced >QUANTYPE</Invoiced> <!-- optional -->
				<IsManuallyClosed >BOOLTYPE</IsManuallyClosed> <!-- optional -->
				<Other1 >STRTYPE</Other1> <!-- optional -->
				<Other2 >STRTYPE</Other2> <!-- optional -->
				<DataExtRet> <!-- optional, may repeat -->
				<OwnerID >GUIDTYPE</OwnerID> <!-- optional -->
				<DataExtName >STRTYPE</DataExtName> <!-- required -->
				<!-- DataExtType may have one of the following values: AMTTYPE, DATETIMETYPE, INTTYPE, PERCENTTYPE, PRICETYPE, QUANTYPE, STR1024TYPE, STR255TYPE -->
				<DataExtType >ENUMTYPE</DataExtType> <!-- required -->
				<DataExtValue >STRTYPE</DataExtValue> <!-- required -->
				</DataExtRet>
				</SalesOrderLineRet>
				<DataExtRet> <!-- optional, may repeat -->
				<OwnerID >GUIDTYPE</OwnerID> <!-- optional -->
				<DataExtName >STRTYPE</DataExtName> <!-- required -->
				<!-- DataExtType may have one of the following values: AMTTYPE, DATETIMETYPE, INTTYPE, PERCENTTYPE, PRICETYPE, QUANTYPE, STR1024TYPE, STR255TYPE -->
				<DataExtType >ENUMTYPE</DataExtType> <!-- required -->
				<DataExtValue >STRTYPE</DataExtValue> <!-- required -->
				</DataExtRet>
				</SalesOrderLineGroupRet>
				<!-- END OR -->
				<DataExtRet> <!-- optional, may repeat -->
				<OwnerID >GUIDTYPE</OwnerID> <!-- optional -->
				<DataExtName >STRTYPE</DataExtName> <!-- required -->
				<!-- DataExtType may have one of the following values: AMTTYPE, DATETIMETYPE, INTTYPE, PERCENTTYPE, PRICETYPE, QUANTYPE, STR1024TYPE, STR255TYPE -->
				<DataExtType >ENUMTYPE</DataExtType> <!-- required -->
				<DataExtValue >STRTYPE</DataExtValue> <!-- required -->
				</DataExtRet>
				</SalesOrderRet>
				<ErrorRecovery> <!-- optional -->
				<!-- BEGIN OR -->
				<ListID >IDTYPE</ListID> <!-- optional -->
				<!-- OR -->
				<OwnerID >GUIDTYPE</OwnerID> <!-- optional -->
				<!-- OR -->
				<TxnID >IDTYPE</TxnID> <!-- optional -->
				<!-- END OR -->
				<TxnNumber >INTTYPE</TxnNumber> <!-- optional -->
				<EditSequence >STRTYPE</EditSequence> <!-- optional -->
				<ExternalGUID >GUIDTYPE</ExternalGUID> <!-- optional -->
				</ErrorRecovery>
			</SalesOrderAddRs>
		</QBXMLMsgsRq>
		</QBXML>
		 */
		public any function pushOrders(){

		}

		/* Example Qwc File
		 <?xml version="1.0"?>
			<QBWCXML>
				<AppName>WCWebService1</AppName>
				<AppID></AppID>
				<AppURL>http://localhost/WCWebService/WCWebService.asmx</AppURL>
				<AppDescription>A short description for WCWebService1</AppDescription>
				<AppSupport>http://developer.intuit.com</AppSupport>
				<UserName>iqbal1</UserName>
				<OwnerID>{57F3B9B1-86F1-4fcc-B1EE-566DE1813D20}</OwnerID>
				<FileID>{90A44FB5-33D9-4815-AC85-BC87A7E7D1EB}</FileID>
				<QBType>QBFS</QBType>
				<Scheduler>
					<RunEveryNMinutes>2</RunEveryNMinutes>
				</Scheduler>
			</QBWCXML>
		 **/
		public any function getQBWCFile(){

			var fileID = getQuickbooksGUID();

			//temp owner ID for testing
			var ownerID = getService("SettingService").getSettingValue("integrationquickbookswebconnectorownerid");
			var appID = ""; //leave blank
			var appURL= getService("SettingService").getSettingValue("integrationquickbookswebconnectorappurl") & "/integrationServices/quickbookswebconnector/model/service/WebService.cfc?wsdl";

			if(isNumeric(getService("SettingService").getSettingValue("integrationquickbookswebconnectorrequestFrequency"))){
				var runEveryNMinutes = getService("SettingService").getSettingValue("integrationquickbookswebconnectorrequestfrequency");
			} else {
				var runEveryNMinutes = 15;
			}

			if(len(getService("SettingService").getSettingValue("integrationquickbookswebconnectorappname")) > 0){
				var appName = getService("SettingService").getSettingValue("integrationquickbookswebconnectorappname");
			} else {
				var appName = "";
			}

			if(len(getService("SettingService").getSettingValue("integrationquickbookswebconnectorusername"))){
	            var userName = getService("SettingService").getSettingValue("integrationquickbookswebconnectorusername");
			} else {
	            var userName = "";
			}

	        //get the auth token won't need this unless we end up locking down the route

	        //append it to the url string authToken=#authToken#

			savecontent variable="qwcFile" {
				writeOutput(
					'<?xml version="1.0"?>
						<QBWCXML>' &
						'<AppName>' & appName & '</AppName>' &
						'<AppID>' & appID & '</AppID>' &
						'<AppURL>' & appURL & '</AppURL>' &
						'<AppDescription>' & appURL & '</AppDescription>' &
						'<AppSupport>' & getService("SettingService").getSettingValue("integrationquickbookswebconnectorappurl") & '</AppSupport>' &
						'<UserName>' & userName & '</UserName>' &
						'<OwnerID>{' & ownerID & '}</OwnerID>' &
						'<FileID>{' & fileID & '}</FileID>' &
						'<QBType>QBFS</QBType>' &
						'<Style>Document</Style>' &
						'<Scheduler><RunEveryNMinutes>' & runEveryNMinutes & '</RunEveryNMinutes></Scheduler>' &
						'</QBWCXML>'
				);
			}
			var fileName = fileID;
			var fileExt = "qwc";
			var filePath = getTempDirectory() & fileName & "." & fileExt;
			FileWrite(filePath,qwcFile);
			getService("HibachiUtilityService").downloadFile(fileName,filePath,fileExt);
		}

		/*necessary web service methods*/
	</cfscript>

	<cffunction
    	name="authenticate"
    	returnType="string[]"
    	output="no"
    	access="remote">
		<cfargument name="strUserName" type="string" required="true" />
		<cfargument name="strPassword" type="string" required="true" />
		<cfscript>
			var thisTicket = getQuickbooksGUID();

	        //We can assume that if this method was hit, that authentication is valid
	        if(len(getService("SettingService").getSettingValue("integrationquickbookswebconnectorcompanyfilename"))){
	        	var companyFileName = getService("SettingService").getSettingValue("integrationquickbookswebconnectorcompanyfilename");
	        } else {
	        	//else we cant go on
	        	var companyFileName = "";//use the currently open company file
	        }

			var updatePostponeInterval = "1";
			var everyMinute = "1";

			if(isNumeric(getService("SettingService").getSettingValue("integrationquickbookswebconnectorrequestfrequency"))){
				var runEveryNMinutes = getService("SettingService").getSettingValue("integrationquickbookswebconnectorrequestfrequency");
			} else {
				var runEveryNMinutes = 15;
			}

			//queue events
		    variables.tickets[thisTicket] = ["syncAccountLedger"];

		    var answer = [javaCast("string","nvu"),javaCast("string",updatePostponeInterval),javaCast("string",everyMinute),javaCast("string",runEveryNMinutes)];
            return javaCast("string[]", answer); 
		    //return "new String[] { ""one"", ""two"", ""three"" }"
		</cfscript>
    </cffunction>

    <cffunction 
        name = "serverVersion"
        returnType = "string" 
        output = "no"
        access = "remote">
        <cfargument name="ticket" type="string" />
        <cfreturn "testImplementation" />
    </cffunction>

    <cffunction 
        name = "clientVersion"
        returnType = "string"
        output = "no"
        access = "remote">
        <cfargument name="strVersion" type="string" required="true" />
        <cfreturn "" />
    </cffunction>

	<cffunction
    	name = "sendRequestXML"
    	returnType = "array"
    	output = "no"
    	access = "remote">
		<cfargument name="ticket" type="string" required="true" />
		<cfargument name="strHCPResponse" type="string" required="true" />
		<cfargument name="qbXMLCountry" type="string" required="true" />
		<cfargument name="qbXMLMajorVers" type="string" required="true" />
		<cfargument name="qbXMLMinorVers" type="string" required="true" />
		<cfscript>
			//pop off whatever action needs to be taken and execute it
			var actionQueue = variables.tickets[ticket];
			var answer = [];

			if(arrayLen(actionQueue) > 0){
				var action = actionQueue[1];

				switch(action) {
					case "syncAccountLedger":
						//get the sync account ledger xml
					case "pushProducts":
						//get the push product xml
					case "pushOrders":
						//get the push order xml
					case "pushAccounts":
						//get the push accounts xml
					default:
						//we're done let the web connector know
				}
				//attach the xml to the resposne

			} else {
				//we're done let the web connector know
			}

			return answer;
		</cfscript>
    </cffunction>

	<cffunction
    	name = "recieveResponseXML"
    	returnType = "array"
    	output = "no"
    	access = "remote">
		<cfargument name="ticket" type="string" required="true" />
		<cfargument name="response" type="string" required="true" />
		<cfargument name="hresult" type="string" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfscript>
			var answer = [];

			//confirm the action was sucessful - log it

			//store data

			return answer;
		</cfscript>
    </cffunction>

	<cffunction
    	name = "connectionError"
    	returnType = "array"
    	output = "no"
    	access = "remote">
		<cfargument name="ticket" type="string" required="true" />
		<cfargument name="hresult" type="string" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfscript>
			var answer = "The process encountered an error, the connection will now be closed. The hresult was: " & hresult & " ::::: And the message was: " & message;

			//log the error if possible

			structDelete(variables.tickets, ticket);

			//Delete the queue for the ticket

			return answer;
		</cfscript>
    </cffunction>

	<cffunction
    	name = "getLastError"
    	returnType = "array"
    	output = "no"
    	access = "remote">
		<cfargument name="ticket" type="string" required="true" />
		<cfscript>
			var answer = "The process encountered an error, the connection will now be closed.";

			//log the error if possible

			structDelete(variables.tickets, ticket);

			//Delete the queue for the ticket

			return answer;
		</cfscript>
    </cffunction>

	<cffunction
    	name = "closeConnection"
    	returnType = "array"
    	output = "no"
    	access = "remote">
		<cfargument name="ticket" type="string" required="true" />
		<cfargument name="fakeargumenttopass">
		<cfscript>
			var answer = "The process has completed sucessfully the connection will now be closed.";

			structDelete(variables.tickets, ticket);

			return answer;
		</cfscript>
    </cffunction>

	// ===================== START: Logical Methods ===========================

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	// =====================  END: Process Methods ============================

	// ====================== START: Save Overrides ===========================

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================
</cfcomponent>
