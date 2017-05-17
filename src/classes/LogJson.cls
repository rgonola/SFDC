global class LogJson{
   public LogInfo LogInfo;
   
   global class LogInfo {
        public String Id;   
        public String CreateDate;
        public String eventSource;
    }
    
  public static LogJson parse(String json){
        return (LogJson) System.JSON.deserialize(json, LogJson.class);
    } 
}