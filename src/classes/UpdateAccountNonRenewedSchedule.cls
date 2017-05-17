/**********************************************************************
Name: UpdateAccountNonRenewedSchedule
Copyright © 2012 WK
======================================================
======================================================
Purpose: This schedule apex class is used to schedule UpdateAccountNonRenewedBatchApex.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR   DATE       DETAIL 
1.0       Natesh   19/06/2012 INITIAL DEVELOPMENT 
***********************************************************************/
global class UpdateAccountNonRenewedSchedule implements Schedulable{
	global void execute(SchedulableContext sc) {
		UpdateAccountNonRenewedBatchApex batchApex = new UpdateAccountNonRenewedBatchApex();
		Id AMFSNSRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Account'].Id;
		batchApex.query = 'SELECT Id,Type FROM Account WHERE (Type=\'Renewed customer\' OR Type=\'New customer\') AND RecordTypeId=\''+AMFSNSRecordTypeId+'\'';
		//batchApex.query = batchApex.query + ' AND ownerId= \'005M0000000KCKH\'';
		//System.debug(batchApex.query);
		database.executebatch(batchApex,1000);
	}
}