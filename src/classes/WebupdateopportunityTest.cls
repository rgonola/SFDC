@isTest    
class WebupdateopportunityTest
{
    static testMethod void myTest() {
    
    opportunity p=new opportunity();
    p.Type='NEW';
    p.Name='tstop';
    p.StageName='Negotiation';
    p.CloseDate=system.today();
    insert p;
        Test.startTest();
        Webupdateopportunity.QTC(p.id);
        Test.StopTest();
        
      }
}