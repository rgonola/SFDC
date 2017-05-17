/* @Description: Test class for 'afInsertProduct2InsertPricebookEntry'
   @Modified By: Vaibhav Kulkarni
   @Date: 24.May.2013
*/ 

@isTest(seeAllData=true)
public class TestafInsertProduct2InsertPricebookEntry   {

    static testMethod void TestafInsertProduct2InsertPricebookEntry() { 
    
    //Commented @Vaibhav   
    /*   
        Id AMFSNSproductRecordTypeId=[SELECT Id FROM RecordType WHERE Name='AM/FS/NS Product'].Id;        
              
        Pricebook2 newPricebook = new Pricebook2(Name = 'Renewal Quote Test', IsActive = True, 
                                                 Description = 'test pricebook');
        insert newPricebook;
           
        Product2 newProduct = new Product2(Name = 'TEST PRODUCT RENEWAL', ProductCode = 'TEST PRODUCT RENEWAL', 
                                           Family = 'Others', IsActive = True, Description = 'test product',
                                           RecordTypeId = AMFSNSproductRecordTypeId);
        insert newProduct;                 
        System.assertEquals(newProduct.RecordTypeId, AMFSNSproductRecordTypeId);        
    }
    */
    //Commented @Vaibhav
    
        Id AMFSNSproductRecordTypeId=[SELECT Id FROM RecordType WHERE Name='AM/FS/NS Product'].Id;        
        List<Product2> productLst = new List<Product2>();
        Product2 newProduct ;
        for(integer i=0; i<200; i++){
            newProduct = new Product2(Name = 'TEST PRODUCT RENEWAL', ProductCode = 'TEST PRODUCT RENEWAL', 
                                               Family = 'Others', IsActive = True, Description = 'test product',
                                               RecordTypeId = AMFSNSproductRecordTypeId);
            productLst.add(newProduct);
        }
        insert productLst;    
        
        for(PricebookEntry pbe :[Select id,UnitPrice,Product2Id From PricebookEntry Where Product2Id IN: productLst]){             
            System.assertEquals(pbe.UnitPrice,0.0);    
        }
    }
}