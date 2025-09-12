/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-12-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class salesforceObjectViewerControllerTest {
    
     @TestSetup
    static void datafactory(){
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i<10; i++){
            accounts.add(new Account(Name='Test Account '+i));
        }

        insert accounts;
    }   

     @isTest 
    static void Positive_getAllObjectsTest() {
        user u = [SELECT Id FROM User WHERE name = 'testing user' LIMIT 1];
 
         System.runAs(u) {
            List<String> objects = objectControllerLwc.getAllObjects();
            System.assert(objects.size() > 0, 'No objects returned');
        }
    }

    @isTest
    static void Postive_getFieldsTest() {
        user u = [SELECT Id FROM User WHERE name = 'testing user' LIMIT 1];
 
            System.runAs(u) {
                List<Map<String, String>> fields = objectControllerLwc.getFields('Account');
                System.assert(fields.size() > 0, 'No fields returned for Account : ' + fields);
            }
        }
   
    @isTest
    static void Postive_getRecordsTest() {
        user u = [SELECT Id FROM User WHERE name = 'testing user' LIMIT 1];
 
          System.runAs(u) {
            List<String> fields = new List<String>{'Id', 'Name'};
            List<SObject> records = objectControllerLwc.getRecords('Account', fields, 5, 0);
            System.assert(records.size() == 5, 'Incorrect number of records returned'+ records.size());
        }
    }
    
 @isTest
    static void Postive_updateRecord() {
        // Query accounts from @TestSetup
        List<Account> accs = [SELECT Id, Name FROM Account LIMIT 2];

        // Change their names
        for (Account a : accs) {
            a.Name = 'UpdatedName';
        }

        // Call the method
        String result = ObjectControllerLwc.updateRecords(accs);

        // Assert success
        System.assertEquals('done', result, 'Expected updateRecords to return "done"');
    }

    
    
    @isTest
    static void Negative_getFields()
    { 
        List<Map<String, String>> fields = objectControllerLwc.getFields('not');
        System.assert(fields == NULL, 'No fields returned for Account');
        
		
    }
   	@isTest
    static void Negative_getRecordsTest() {
            List<String> fields = new List<String>{'contactId', 'Name'};
            List<SObject> records = objectControllerLwc.getRecords('Account', fields, 5, 0);
            System.assert(records == null, 'Incorrect number of records returned');
        
    }
     @isTest
    static void Negative_updateRecords()
    {
        List<Sobject> accounts = new List<sobject>();
        for(Integer i=0; i<10; i++){
            accounts.add(new Account(Name='Test Account '+i));
        }

      
         String recordList = objectControllerLwc.updateRecords( accounts);
         System.assertEquals(recordList, 'null', 'Incorrect number of records returned');
        
        
    }
   	
}