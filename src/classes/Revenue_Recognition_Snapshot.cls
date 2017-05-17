public class Revenue_Recognition_Snapshot implements Schedulable {
public void execute(SchedulableContext sc) {
  
  List<invoiceit_s__Currency__c> currency1 =[select id,invoiceit_s__Currency_Name__c from invoiceit_s__Currency__c where invoiceit_s__Currency_Name__c='United States Dollar' Limit 1];
  
   Revenue_Recognition_Snapshot__c RR = new Revenue_Recognition_Snapshot__c();
   RR.Name = 'Revenue_Recognition_Snapshot'+system.today();
   RR.Start_Date__c = system.today();
   Date theDate = system.today();
   RR.End_Date__c = theDate.AddYears(3);
   if(currency1.size() >0){
   system.debug('Currency1 ' + currency1 );
   RR.Currency__c = currency1[0].ID ;
   insert RR;
   
  }


}
   
}