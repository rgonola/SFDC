@IsTest
public class PfxAccountpullResponse_Test {
    
    static testMethod void testParse() {
        String json = '{\"Response_Message\":\"Success\",\"ContactID\":\"0030j000005u4GLAAY\",\"AccountId\":\"0010j000007fwSOAAY\"}';
        PfxAccountpullResponse obj = PfxAccountpullResponse.parse(json);
        System.assert(obj != null);
    }
}