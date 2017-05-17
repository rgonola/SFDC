// Class for Creation of pid cid for trust accounts



global class Creationofpidcid{

webservice static String call(string acct) {

  if(!test.isrunningtest()){
     IIT_PID_CID_check.output op =  IIT_PID_CID_check.noPID_noCID_noOFFC_AccID(null, null, null,acct);
   }else{

    IIT_PID_CID_check.output op =  IIT_PID_CID_check.noPID_noCID_noOFFC_AccID(10084,10045,1,acct);
  }
String Result='success';

return Result;

}

}