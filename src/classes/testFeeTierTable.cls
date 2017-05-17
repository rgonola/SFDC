@isTest
private class testFeeTierTable{
    
    @isTest static void test_one() {
        Account acct = new Account(Name='Test');
        acct.BillingCountry = 'United States';
        acct.BillingStreet = 'Test Street';
        acct.BillingState ='Test Billing State';
        acct.BillingPostalCode ='12345';
        acct.ShippingCity ='Pune';
        acct.ShippingCountry ='India';
        acct.ShippingPostalCode = '12345';
        acct.ShippingState = 'Maharashtra';
        acct.ShippingStreet = 'Test Shipping Street';  
        acct.Website = 'www.google.com';
        insert acct;
        
        Opportunity opp1 = new Opportunity(Name='Test', AccountId=acct.Id, StageName='B - Discover', CloseDate=System.today());
        opp1.Type = 'New Business';
        opp1.NextStep = 'test';
        opp1.LeadSource = 'Website';
        insert opp1;
        
        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Product1',ProductCode='BNDL-SVC-ADV',SBQQ__PricingMethod__c='List',SBQQ__SubscriptionPricing__c='Fixed Price');
        Product2 p2 = new Product2(Name='Product2',ProductCode='PROD-MA-SEL-USE',SBQQ__PricingMethod__c='List',SBQQ__SubscriptionPricing__c='Fixed Price');
       
        products.add(p1);
        products.add(p2);


        insert products;
        
        Promotion__c promo=new Promotion__c(Name='New Promo',  Start__c=system.today(), End__c=system.today().adddays(365));
        insert promo;

        Promotion_Entry__c promoentry=new Promotion_Entry__c(Name='New Promo', Promotion__c=promo.id,  Price__c=100, Product_Name__c='Product1' , Product__c=products.get(0).id);
        insert promoentry;

        SBQQ__Quote__c quote1 = new SBQQ__Quote__c(SBQQ__Type__c='New', SBQQ__Opportunity2__c=opp1.Id, SBQQ__StartDate__c = System.Today());
        quote1.SBQQ__StartDate__c = System.today();
        insert quote1;
        
        //Discount Schedule and Tiers
        
        List<SBQQ__DiscountSchedule__c> schedules=new List<SBQQ__DiscountSchedule__c>();
        schedules.add(new SBQQ__DiscountSchedule__c(Name='Schedule1', SBQQ__Type__c='Slab',SBQQ__DiscountUnit__c='Amount' ));
        schedules.add(new SBQQ__DiscountSchedule__c(Name='Schedule2', SBQQ__Type__c='Slab',SBQQ__DiscountUnit__c='Amount' ));        
        
        insert schedules;
        
        List<SBQQ__DiscountTier__c> tiers=new List<SBQQ__DiscountTier__c>();
        tiers.add(new SBQQ__DiscountTier__c(Name='1-75',SBQQ__DiscountAmount__c=1,SBQQ__LowerBound__c=1, SBQQ__UpperBound__c=75, SBQQ__Number__c=1,SBQQ__Schedule__c=schedules.get(0).id   ));
        tiers.add(new SBQQ__DiscountTier__c(Name='75-150',SBQQ__DiscountAmount__c=1,SBQQ__LowerBound__c=76, SBQQ__UpperBound__c=150, SBQQ__Number__c=2,SBQQ__Schedule__c=schedules.get(0).id  ));
        tiers.add(new SBQQ__DiscountTier__c(Name='150+',SBQQ__DiscountAmount__c=1,SBQQ__LowerBound__c=151,  SBQQ__Number__c=3,SBQQ__Schedule__c=schedules.get(0).id  ));
        tiers.add(new SBQQ__DiscountTier__c(Name='1-75',SBQQ__DiscountAmount__c=1,SBQQ__LowerBound__c=1, SBQQ__UpperBound__c=75, SBQQ__Number__c=1,SBQQ__Schedule__c=schedules.get(1).id   ));
        tiers.add(new SBQQ__DiscountTier__c(Name='75-150',SBQQ__DiscountAmount__c=1,SBQQ__LowerBound__c=76, SBQQ__UpperBound__c=150, SBQQ__Number__c=2,SBQQ__Schedule__c=schedules.get(1).id  ));
        tiers.add(new SBQQ__DiscountTier__c(Name='150+',SBQQ__DiscountAmount__c=1,SBQQ__LowerBound__c=151,  SBQQ__Number__c=3,SBQQ__Schedule__c=schedules.get(1).id  ));
        insert tiers;
                           
        
        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__DiscountSchedule__c=schedules.get(0).id, Promotion__c=promoentry.id, SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id ,SBQQ__Incomplete__c=true, SBQQ__OriginalPrice__c = 0, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__DiscountSchedule__c=schedules.get(1).id, SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id ,SBQQ__Incomplete__c=true, SBQQ__OriginalPrice__c = 100, SBQQ__Quantity__c=10);

        
        lines1.add(line1);
        lines1.add(line2);

        
        insert lines1;

        line2.SBQQ__RequiredBy__c=lines1.get(0).id;
        update line2;
        
         Account acc=new Account(Name='Test Account');
                insert acc;
                Contact con=new Contact(LastName='LName', Accountid=acc.id, Email='test@test.com');
                insert con;
                quote1.SBQQ__PrimaryContact__c=con.id;
                
        update quote1;
        

    }
    
    @isTest static void test_method_two() {
        // Implement test code
    }
    
}