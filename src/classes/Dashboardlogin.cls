public with sharing class Dashboardlogin {

 public pagereference urltosaveprdct(){
  
  try{
   cookie rid= ApexPages.currentPage().getCookies().get('dshlogin');
            
           List<Dashboard_Login__c>  cartexist =[select id from Dashboard_Login__c where id =:rid.getvalue()];
           
           if(cartexist.size()>0){
           
            String url = '/apex/Bartchart_View';
            return new PageReference( url);
           
           }
           
            }catch(Exception e) {}  
  return null;
 }


}