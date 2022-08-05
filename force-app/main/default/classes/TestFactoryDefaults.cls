/**
 * @format            :
 * @description       : Based upon multiple test factories
 * @author            : Salesforce Apex Receipes et al
 * @group             :
 * @last modified on  : 05-09-2022
 * @last modified by  : david@experancepartners.com
 * Modifications Log
 * Ver   Date         Author                        Modification
 * 1.0   12-29-2020   david@experancepartners.com   Initial Version
 * 1.1   02*09*2022   david@experancepartners.com   removed freight line item from OLI default and cleaned up debug calls
 * 2.0   08-04-2022   david@experancepartbers.com   Reverting to base from Hoechst
 **/

@IsTest
public class TestFactoryDefaults {
    // To specify defaults for objects, use the naming convention [ObjectName]Defaults.
    // For custom objects, omit the __c from the Object Name

    public class AccountDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{
                Account.Name => 'Test Account'
            };
        }
    }

    public class MyAccountDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{
                Account.Name => 'My Test Account'
            };
        }
    }

    public class ContactDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{
                Contact.FirstName => 'First',
                Contact.LastName => 'Last'
            };
        }
    }

    public class OpportunityDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{
                Opportunity.Name => 'Test Opportunity',
                Opportunity.StageName => 'Closed Won',
                Opportunity.CloseDate => System.today()
            };
        }
    }

    public class CaseDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{
                Case.Subject => 'Test Case'
            };
        }
    }
}
