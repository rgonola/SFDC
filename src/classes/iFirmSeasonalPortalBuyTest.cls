@isTest
public class iFirmSeasonalPortalBuyTest 
{
    static testMethod void PortalOnlyTest() 
    {
    
    //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__C='6000672');
        insert account;
        
        Test.startTest();
                
                   PageReference pageRef1 = Page.iFirmSeasonalPortalBuy;
                        Test.setCurrentPage(pageRef1);
                   
 
                 iFirmtaskExt testSubmission = new iFirmtaskExt();

                
                testSubmission.Cid= '6000672';
                testSubmission.CompName = 'Dee Test Company';
                testSubmission.FirstName = 'Dee';      
                testSubmission.LastName = 'Landis';
                testSubmission.Email = 'dntlandis@gmail.com';
                testSubmission.PhneNumber = '(919) 824-1104';
                testSubmission.IfirmUrl ='MyIfirmURL';
        		
                

                testSubmission.save(); 
                
            
        
                 Test.stopTest();
    }
    
     static testMethod void blanktest() 
    {
    
    
        
        Test.startTest();
                
                   PageReference pageRef1 = Page.iFirmSeasonalPortalBuy;
                        Test.setCurrentPage(pageRef1);
                   
 
                 iFirmtaskExt testSubmission = new iFirmtaskExt();

                
                testSubmission.Cid= '';
                
                

                testSubmission.save(); 
                
            
        
                 Test.stopTest();
    }
    
     static testMethod void blanktest2() 
    {
    
    
        
        Test.startTest();
                
                   PageReference pageRef1 = Page.iFirmSeasonalPortalBuy;
                        Test.setCurrentPage(pageRef1);
                   
 
                 iFirmtaskExt testSubmission = new iFirmtaskExt();

                
                testSubmission.Cid= '1234567';
                
                

                testSubmission.save(); 
                
            
        
                 Test.stopTest();
    }
    
     static testMethod void blanktest3() 
    {
    
    //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__C='6000672');
        insert account;
        
        
        Test.startTest();
                
                   PageReference pageRef1 = Page.iFirmSeasonalPortalBuy;
                        Test.setCurrentPage(pageRef1);
                   
 
                 iFirmtaskExt testSubmission = new iFirmtaskExt();

                testSubmission.Cid= '6000672';
                testSubmission.CompName = '123';
                

                testSubmission.save(); 
                
            
        
                 Test.stopTest();
    }
 
    static testMethod void blanktest4() 
    {
    
    //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__C='6000672');
        insert account;
        
        
        Test.startTest();
                
                   PageReference pageRef1 = Page.iFirmSeasonalPortalBuy;
                        Test.setCurrentPage(pageRef1);
                   
 
                 iFirmtaskExt testSubmission = new iFirmtaskExt();

                testSubmission.Cid= '6000672';
                testSubmission.CompName = 't';
                

                testSubmission.save(); 
                
            
        
                 Test.stopTest();
    }
    
    static testMethod void blanktest5() 
    {
    
    //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__C='6000672');
        insert account;
        
        
        Test.startTest();
                
                   PageReference pageRef1 = Page.iFirmSeasonalPortalBuy;
                        Test.setCurrentPage(pageRef1);
                   
 
                 iFirmtaskExt testSubmission = new iFirmtaskExt();

                testSubmission.Cid= '6000672';
                testSubmission.CompName = 'test&test';
                

                testSubmission.save(); 
                
            
        
                 Test.stopTest();
    }
}