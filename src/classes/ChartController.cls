public class ChartController {
    public CandData6[] getCandidateData6() {
        CandData6[] cands6 = new CandData6[] {};
            for (AggregateResult ar : [select Pipeline_Designation_Text__c n, COUNT(Id) 
                                       from Opportunitylineitem Where Quote_Status__c ='Invoiced' AND Required_by_QL__c <> Null AND Pipeline_Designation_Text__c <> NULL
                                        group by Pipeline_Designation_Text__c]) 
        {            
            cands6.add(new CandData6(ar));
        }
        
        return cands6;
    }
    
     // Wrapper class 
    public class CandData6
    {
        public string Designation {get; set;}
        public Integer count {get; set;}
        public string Value {get; set; }
        CandData6(aggregateresult a) 
        {
            this.count = (Integer) a.get('expr0');
            this.Designation = (string) a.get('n');           
            this.Value = Designation+'';
        }
    }
    
    public salebyproduct[] getsalebyProduct() {
        salebyproduct[] salesprdct= new salebyproduct[] {};
            for (AggregateResult ar : [select Purchased_Product_Code__c n, COUNT(Id) 
                                       from Opportunitylineitem Where Quote_Status__c ='Invoiced' AND Required_by_QL__c = Null AND Package__c= true AND Product2.RegCode_Required__c=true AND Pipeline_Designation_Text__c='ATX' AND Product2.Product_Year__c ='2017'
                                        group by Purchased_Product_Code__c]) 
        {            
            salesprdct.add(new salebyproduct(ar));
        }
        
        return salesprdct;
    }
    
    public class salebyproduct
    {
        public string Designation {get; set;}
        public Integer count {get; set;}
        public string Value {get; set; }
        salebyproduct(aggregateresult a) 
        {
            this.count = (Integer) a.get('expr0');
            this.Designation = (string) a.get('n');           
            this.Value = Designation+'';
        }
    }
    
   
}