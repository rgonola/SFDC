@isTest
public class WebupdateOppyGeneratedTest {
    static testMethod void m1() {
    
    WebupdateOppyGenerated.LogInfo obj1 = new WebupdateOppyGenerated.LogInfo ();
    
    WebupdateOppyGenerated.LogInfo obj4 = new WebupdateOppyGenerated.LogInfo ();
    WebupdateOppyGenerated.DebuggingInfo_element obj2 = new WebupdateOppyGenerated.DebuggingInfo_element ();
    WebupdateOppyGenerated.address obj3 = new WebupdateOppyGenerated.address ();
    WebupdateOppyGenerated.SessionHeader_element obj5 = new WebupdateOppyGenerated.SessionHeader_element ();
    WebupdateOppyGenerated.QTCResponse_element obj6 = new WebupdateOppyGenerated.QTCResponse_element ();
    WebupdateOppyGenerated.CallOptions_element obj7 = new WebupdateOppyGenerated.CallOptions_element ();
    WebupdateOppyGenerated.DebuggingHeader_element obj8 = new WebupdateOppyGenerated.DebuggingHeader_element ();
    WebupdateOppyGenerated.AllowFieldTruncationHeader_element obj = new WebupdateOppyGenerated.AllowFieldTruncationHeader_element ();
    WebupdateOppyGenerated.QTC_element obj9 = new WebupdateOppyGenerated.QTC_element ();
    WebupdateOppyGenerated.Webupdateopportunity obj10= new WebupdateOppyGenerated.Webupdateopportunity();
    WebupdateOppyGenerated.location obj11 = new WebupdateOppyGenerated.location (); 
     opportunity p=new opportunity();
    p.Type='NEW';
    p.Name='tstop';
    p.StageName='Negotiation';
    p.CloseDate=system.today();
    insert p;
     Webupdateopportunity.QTC(p.id);
            
    
    }
    }