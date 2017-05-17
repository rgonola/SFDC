/**********************************************************************
Name: afInsertProduct2InsertPricebookEntry 
Copyright © 2012 WK
=======================================================================
=======================================================================
Purpose: This trigger will be called when a new Product is created.
         It creates an active PricebookEntry for that product with a price of $0.00.  This allows products to be
         added to opportunities.  If this org ever uses multi-currency, this trigger will need to be modified to
         handle that.
=======================================================================
=======================================================================
History
-----------------------------------------------------------------------
VERSION    AUTHOR        DATE           DETAIL
1.0        Rajesh Meti   June 8, 2012   Initial development
1.1        Ted Shevlin   March 29, 2013 Code commenting
                                        Variable renaming
                                        Added constant for record type
***********************************************************************/

trigger afInsertProduct2InsertPricebookEntry on Product2(after insert) {

    // Constants

    final String RECORD_TYPE_PRODUCT_AMFSNS = 'AM/FS/NS Product';
    final Id AMFSNSRecordTypeId = [SELECT Id FROM RecordType WHERE Name = :RECORD_TYPE_PRODUCT_AMFSNS].Id;
    final Id stdPricebookId;    

    if(test.isRunningTest()){
            stdPricebookId=Test.getStandardPricebookId();
        }else{
             stdPricebookId= [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;
        }
    List<PricebookEntry> listPBE = new List<PricebookEntry>();

    // For every product inserted,
    //     Add an active PricebookEntry with a $0.00 price
    for(Product2 p : Trigger.new) {
        if(p.RecordTypeId == AMFSNSRecordTypeId) {
            PricebookEntry pbe = new PricebookEntry(
                Pricebook2Id = stdPricebookId,
                UseStandardPrice = false,
                Product2Id = p.Id,
                IsActive = true,
                UnitPrice = 0.0
            );
            listPBE.add(pbe);
        }
    }

    // Insert the new PricebookEntries
    if(listPBE.size() > 0)  {
        insert listPBE;
    }
}