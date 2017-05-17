@isTest
private class testQCP {
	
	@isTest static void test_non_rubiks() {
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
        
        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(Promotion__c=promoentry.id, SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id ,SBQQ__Incomplete__c=true, SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id ,SBQQ__Incomplete__c=true, SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);

        
        lines1.add(line1);
        lines1.add(line2);

        
        insert lines1;

        line2.SBQQ__RequiredBy__c=lines1.get(0).id;
        update line2;
        


		 //Contract
        Contract contr=new Contract();
        contr.Accountid=acct.id;
        contr.Status='Draft';
        contr.StartDate=system.today().adddays(-1);
        contr.ContractTerm=12;
        insert contr;

        //Subscription
        List<SBQQ__Subscription__c> subList=new List<SBQQ__Subscription__c>();

        SBQQ__Subscription__c subscrip=new SBQQ__Subscription__c();
        subscrip.SBQQ__Account__c=acct.id;
        subscrip.SBQQ__Contract__c=contr.id;
        subscrip.SBQQ__QuoteLine__c=lines1.get(0).id;
        subscrip.SBQQ__Product__c=p1.id;
        subscrip.SBQQ__Quantity__c=1;

        SBQQ__Subscription__c subscrip2=new SBQQ__Subscription__c();
        subscrip2.SBQQ__Account__c=acct.id;
        subscrip2.SBQQ__Contract__c=contr.id;
        subscrip2.SBQQ__QuoteLine__c=lines1.get(1).id;
        subscrip2.SBQQ__Product__c=p1.id;
        subscrip2.SBQQ__Quantity__c=1;


        subList.add(subscrip);
        subList.add(subscrip2);

        insert subList;
        
        SBQQ__Quote__c quoteamend = new SBQQ__Quote__c(SBQQ__Type__c='Amendment', SBQQ__Opportunity2__c=opp1.Id, SBQQ__StartDate__c = System.Today());
        quoteamend.SBQQ__StartDate__c = System.today();
        insert quoteamend;

        SBQQ__QuoteLine__c[] linesamend = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1amend = new SBQQ__QuoteLine__c(SBQQ__UpgradedSubscription__c=subList.get(0).id, SBQQ__Quote__c=quoteamend.Id, SBQQ__Product__c=p1.Id ,SBQQ__Incomplete__c=true, SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2amend = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quoteamend.Id, SBQQ__Product__c=p2.Id ,SBQQ__Incomplete__c=true, SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);

        linesamend.add(line1amend);
        linesamend.add(line2amend);
        insert linesamend;

        line2amend.SBQQ__RequiredBy__c=linesamend.get(0).id;
        update line2amend;

        lines1 = [SELECT Promotion__c, SBQQ__Quote__c, SBQQ__UpgradedSubscription__c, SBQQ__RenewedSubscription__c,SBQQ__Product__c, SBQQ__BundledQuantity__c, SBQQ__RequiredBy__r.SBQQ__ProductName__c, SBQQ__RequiredBy__c, SBQQ__RequiredBy__r.SBQQ__Discount__c, SBQQ__ProductCode__c, SBQQ__Quantity__c, SBQQ__ListPrice__c, SBQQ__ProratedListPrice__c, SBQQ__RegularPrice__c, SBQQ__NetPrice__c, SBQQ__ListTotal__c, SBQQ__RegularTotal__c, SBQQ__CustomerTotal__c, SBQQ__NetTotal__c, SBQQ__ProductName__c, SBQQ__EffectiveStartDate__c, SBQQ__EffectiveEndDate__c, SBQQ__SubscriptionTerm__c, SBQQ__DefaultSubscriptionTerm__c,  SBQQ__SubscriptionPricing__c, SBQQ__ProrateMultiplier__c, SBQQ__Renewal__c, SBQQ__Bundled__c, SBQQ__Existing__c, SBQQ__PricingMethod__c, SBQQ__DiscountScheduleType__c, SBQQ__OptionLevel__c, SBQQ__DistributorDiscount__c, SBQQ__PartnerDiscount__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :quoteamend.Id ORDER BY SBQQ__Number__c];
        

       

        CCHQuoteCalculator target1 = new CCHQuoteCalculator();
        target1.onInit(lines1);
        target1.onBeforeCalculate(quoteamend, lines1);
        target1.onBeforePriceRules(quoteamend, lines1);
        target1.onAfterPriceRules(quoteamend, lines1);
        target1.onAfterCalculate(quoteamend, lines1);
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}