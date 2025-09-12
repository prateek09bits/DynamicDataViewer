/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-11-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest(seeAllData=true)
public class TestObjectController {
    @TestSetup
    static void datafactory(){
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i<10; i++){
            accounts.add(new Account(Name='Test Account '+i));
        }

        insert accounts;
    }   

     @isTest 
    static void getAllObjectsTest() {
        user u = [SELECT Id FROM User WHERE name = 'testing user' LIMIT 1];
 
         System.runAs(u) {
            List<String> objects = objectControllerLwc.getAllObjects();
            System.assert(objects.size() > 0, 'No objects returned');
        }
    }

    @isTest
    static void getFieldsTest() {
            System.runAs(u) {
                List<Map<String, String>> fields = objectControllerLwc.getFields('Account');
                System.assert(fields.size() > 0, 'No fields returned for Account');
            }
        }
   
    @isTest
    static void getRecordsTest() {
          System.runAs(u) {
            List<String> fields = new List<String>{'Id', 'Name'};
            List<SObject> records = objectControllerLwc.getRecords('Account', fields, 5, 0);
            System.assert(records.size() == 5, 'Incorrect number of records returned');
        }
    }
    
    @isTest
    static void updaterecordsTest() {
          System.runAs(u) {
            List<String> fields = new List<String>{'Id', 'Name'};
            List<SObject> records = objectControllerLwc.getRecords('Account', fields, 5, 0);
            System.assert(records.size() == 5, 'Incorrect number of records returned');
            
            // Update the names of the retrieved accounts
            for (SObject record : records) {
                record.put('Name', 'Updated Name ' + Math.random());
            }
            update records;
            
            // Verify the updates
            List<SObject> updatedRecords = [SELECT Id, Name FROM Account WHERE Id IN :records];
            for (SObject updatedRecord : updatedRecords) {
                System.assert(updatedRecord.get('Name').toString().startsWith('Updated Name'), 'Record not updated correctly');
            }
        }
    }


}