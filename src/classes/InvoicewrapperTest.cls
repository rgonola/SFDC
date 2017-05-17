@isTest
Public class InvoicewrapperTest{


static testMethod void testParse() {
        String json=        '{'+
        '                "Cancel_Invoice": {'+
        '                                "Invoice_Number": "INV-63057"'+
        '                }'+
        '}'+
        ''+
        '';
         System.assert(Invoicejsonwrapper.parse(json)!= null);
    }







}