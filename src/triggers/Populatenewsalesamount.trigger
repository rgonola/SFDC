trigger Populatenewsalesamount on Opportunity (Before Insert,Before Update) {

List<Opportunity> opptoupdate = new List<Opportunity>();
Set<Id> oppids= new Set<Id>();

for(Opportunity op :trigger.new){

if(op.Amount >0 && op.SBQQ__PrimaryQuote__c == null && op.Type !='Renewal'){
op.New_Sales_Amount__c=op.Amount;
oppids.add(op.id);

}
}



}