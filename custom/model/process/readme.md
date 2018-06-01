In this folder, you can extend core process objects.

For example, to extend Account_Create, add a file called Account_Create.cfc which consists of:

component extends="Slatwall.model.process.Account_Create" accessors="true"{
	
}

Inside your component you can add properties and functions.