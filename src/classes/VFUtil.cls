/*
 * Got tired of typing in the long version so created these shortcuts
 * In VF page, add "VFUtil.AddErrorMessage( 'This is your error');"
 *      instead of "ApexPages.AddMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'This is your error'));"
 *
 * In Test Classes you can check to see if messages have been added to pages by using the "hasMessage" method.
 * In Test Class, use "VFUtil.hasMessage( 'Expected Error Message');"
 */
public abstract class VFUtil {

    public static boolean isEmpty(Object value){
        return  ( value == NULL ) || 
                ( value == False ) || 
                ( value instanceof String && ((String) value).trim() == '' ) || 
                ( value instanceof List<Object> && ((List<Object>) value).isEmpty() ) || 
                ( value instanceof Set<Object> && ((Set<Object>) value).isEmpty() );
    }
    
    public static void AddInfoMessage( String s) {
        ApexPages.AddMessage( new ApexPages.Message( ApexPages.Severity.INFO, s));
    }

    public static void AddWarningMessage( String s) {
        ApexPages.AddMessage( new ApexPages.Message( ApexPages.Severity.WARNING, s));
    }

    public static void AddConfirmMessage( String s) {
        ApexPages.AddMessage( new ApexPages.Message( ApexPages.Severity.CONFIRM, s));
    }
    
    public static void AddErrorMessage( String s) {
        ApexPages.AddMessage( new ApexPages.Message( ApexPages.Severity.ERROR, s));
    }
    
    public static void AddFatalMessage( String s) {
        ApexPages.AddMessage( new ApexPages.Message( ApexPages.Severity.FATAL, s));
    }

    // Utility method to check for specifc page message in apex pages
    public static Boolean hasMessage( String pageMessage) {
        if ( ApexPages.hasMessages() ) {
            for ( ApexPages.Message msg : ApexPages.getMessages()) {
                if ( msg.getDetail().contains( pageMessage)) {
                    return true;
                }
            }
        }
        
        return false;
    }
    
    // Test Coverage    
    static TestMethod void testAddMessages() {
        String message = 'Test Message';
        VFUtil.addInfoMessage( message);
        VFUtil.addWarningMessage( message);
        VFUtil.addConfirmMessage( message);
        VFUtil.addErrorMessage( message);
        VFUtil.addFatalMessage( message);
        string x='';
        Boolean y=VFUtil.isEmpty(x);
        System.assert( VFUtil.hasMessage( message));
        System.assert( !VFUtil.hasMessage( 'Negative Test Case'));
    }
}