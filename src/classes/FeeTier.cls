public class FeeTier{
  
  public List<invoiceit_s__Job_Rate_Plan_Charge_Tier__c> orpctier{get;set;}
  public Set<String>ProductName{get;set;}

 public FeeTier(){
 
  Set<ID>contractstoprocess = new Set<ID>();
   Set<ID>substoprocess = new Set<ID>();
   Set<ID>Idstoberemoved= new Set<ID>();
   Map<String,Decimal>producttoqunatity= new Map<String,Decimal>();
   opportunity   opp;
   SBQQ__Quote__c newquote;
   String accountId;
   
   try{
   accountId= ApexPages.currentPage().getParameters().get('aci');
   
   Account   acc=[Select id,BillingStreet,Billingcity,BillingCountry,ShippingCountry,Contact__r.id,BillingState,Billingpostalcode,SBQQ__DefaultOpportunity__r.SBQQ__PrimaryQuote__c,SBQQ__DefaultOpportunity__c,Email__c,ShippingStreet,shippingcity,shippingState,
                                 shippingpostalcode,Primary_Contact_Name__c From Account where id=:accountId];  
  
                                 
   List<Contract> contracts =[select Id,AccountId,Status,ContractNumber From Contract where AccountId=:accountId AND Status='Activated' order by CreatedDate desc ];
     
     if(contracts.size()>0){
     
      for(Contract c:contracts ){
      
      contractstoprocess.add(c.id);
      
      }
    
     
       
    List<SBQQ__Subscription__c> sub =[select Id,SBQQ__Quantity__c,SBQQ__Product__r.ProductCode,SBQQ__RevisedSubscription__c,QTC__Order_Rate_Plan_Charge__c,Name,SBQQ__Contract__c,SBQQ__Product__c,SBQQ__QuoteLine__c,SBQQ__Product__r.SBQQ__RenewalProduct__c,SBQQ__Product__r.Renewal_Product_Mapping_Diff__c From SBQQ__Subscription__c 
                                             where SBQQ__Contract__c IN :contractstoprocess  AND SBQQ__Product__r.Shipping_Processing__c=False
                                             AND (Is_Subscription__c=False AND (Package__c = TRUE  )) AND SBQQ__Product__r.Name != 'Sales Tax'  
                                             order by CreatedDate desc ];
    
    //AND QTC__Order_Rate_Plan_Charge__r.invoiceit_s__Status__c !='Cancelled' AND (SBQQ__Quantity__c > 0 OR SBQQ__Quantity__c = 0)
                    
   // List<Contact >   cn=[Select Id,AccountID,Is_Primary__c From Contact Where Is_Primary__c =true AND AccountID=:accountId order by CreatedDate desc Limit 1 ];   
    
   
   
  
    //Create main lines items
    
     
     List<SBQQ__QuoteLine__c> qlinetoupdate= new List<SBQQ__QuoteLine__c>();
     Set<ID>revisedsubs= new Set<ID>();
     Set<String>orpcs= new Set<String>();
     ProductName= new Set<String>();
     
    
     for(SBQQ__Subscription__c  qln :sub ){
     
     System.debug('********Orpc here '+qln.QTC__Order_Rate_Plan_Charge__c);
     
     if(qln.SBQQ__RevisedSubscription__c != null ){  revisedsubs.add(qln.SBQQ__RevisedSubscription__c);   }
     
     if(qln.SBQQ__Quantity__c < 0 ) {  revisedsubs.add(qln.id);   }
     
     if(!revisedsubs.contains(qln.id) ) {
      orpcs.add(String.valueOf(qln.QTC__Order_Rate_Plan_Charge__c).substring(0, 15));
      }
      
      
    }
    System.debug('********Orpc Tier'+orpcs);
   
   orpctier=[select Id,Start_Unitx__c,Name,End_Unitx__c,Unit_Pricex__c,invoiceit_s__Unit_Cost_Price__c,Product__c,Fee_Product__c,
                                                                     invoiceit_s__Job_Rate_Plan_Charge__c,Required_By_ORPC__c,ORPC_Status__c 
                                                                     From invoiceit_s__Job_Rate_Plan_Charge_Tier__c where Required_By_ORPC__c IN:orpcs AND ORPC_Status__c !='Cancelled'];
  
 
 }



}catch(Exception e) {}






}
}