# Salesforce Enterprise Trigger System for a new World - or - yet another trigger system
Note: this work requires the thanks of all the other systems that have been put forward to date, more on them later, but please view this as an improvement/differientiation of them.  It is merly my piece of the mozaic.

## Introduction
The question of trigger systems seems to be pretty settled, but I have found that in enterprise level organizations with lots of code and many developers, over the years, the currently generally acceptable Trigger System, Handler with Helpers leads to tangled code and poor execution times.  In some cases this can lead to SOQL Limit errors (usually several helpers making functionally equivilent calls for their "properly" bulkified tast) and even CPU Timeouts when partnered with CPQ.

Basically, we are talking about a situation where everyone is doing the "right" thing, but over time, build up of the right thing leads to issues.

### What are the issues?
Multiple Helpers doing the same things
Queries created in multiple trigger states doing the same thing
DML statements being bulkified, but called at the helper level, leading to executions whos flow chart looks like a random walk
Significant time to add just one little thing to the current trigge
and over time, unfortunately unreadable code that does the right thing, but requires forensics to figure out what is going on.


## How do you do solve this? 
I struggle with out to outline this since several of these go together
1. Create a framework to handle all trigger execution and flow. Additions to the trigger should not take a full days effort. (Trigger Factory)
2. Create one helper for each SObject with DML, to both make it easy to find where you need to update a trigger and to consolidate the DML to that object at the appopriate time.
3. The helper should be written for single execution, let trigger system handle the looping through records and in most cases consolidate and handle the DML to that object
4. Consolidate SOQL queries in a static class where executions are lazy, thereby calling the query only if execution requires it
5. more on flow control later

## Components
 
### Handler
- This handles the flow control like the traditional Handler/Helper flow \n
- Extends: TriggerHandlerBase
- Naming: \<Trigger SObject\>_Handler
- Example: Contact_Handler
- Notes: This is the controller, it handles only the flow control.  further work can be done to work specific execution of the trigger
  
### Helper
- There is one helper for each SObject that is updated, that way you can easily see where additions/modifications and deletions go.
- Extends: TriggerHelperBase
- Naming \<Trigger SObject\>_\<SObject Modified\>
- Example: Contact_Contact, Contact_Account
- Note: writing of triggers is based upon the SObject updated, not the task given, so an issue might be handled with several classes. This may seem inefficient to the current programmer, but think of the long term and the future developers that will have to use your code.  This makes all future jobs easy peasy.
  
### Query
- There is one query class with all static properties that are lazily sustantiated.
- Extends:
- Naming: \<Trigger SObject\>_Query
- Example: Contact_Query
- Note: Make the base queries as simple and as open as possible.  Again this is for the next person.  You never want to filter a query already created and possibily screwing up other parts of the trigger.  Create a separate map that calls the base query and filters approprately for your work.  These secondary maps can be written in a way that further creates a single flow (Id based upon the trigger record and either a single return object or a list or map of tiems that need to be processed for that trigger record)

### State
- There is one state class with all static properties.
- Extends:
- Naming: \<Trigger SObject\>_State
- Example: Contact_State
- Note: Used to manage flow control.  Allows for monitoring and affecting flow control.  Best example can trigger run once actions.


## Trigger Factory Framework

| FileName | Type | Notes |
| ------------- | ------------- | ------------- |
| TriggerFactory.cls | Base Class | This is the Trigger Controller executed in the appropriate Trigger with TriggerFactory.createTriggerHandler(\<SOBJECT\>.getSObjectType); |
| TriggerHandlerBase.cls | Virtual Class | This class is extended for each of the handlers.  You only need to override the TriggerStates you will implement. Each Trigger State calls the approprate TriggerHelpers. Note only flow control logic should be here. |
| iTriggerHandler.cls | Interface | Interface used to implement virtual structure of Handlers |
| TriggerHelperBase.cls | Virtual Class | This class is extended for each helper class. Note singlethreaded and bulk operations available for each Trigger States.  I suggest all efforts be used to use only single threaded methods. |
| iTriggerHelper.cls | Interface | Interface used to implement virtual structure of Helpers |
| iTriggerStateBase.cls | Virtual Class | This class is extended once for each class to facilitate flow control |
| iTriggerState.cls | Interface | Interface used to implement virtual structure of TriggerState |
| TriggerException.cls | Exception Class | Simple Exception class which could be built out to individual reporting requirements |
| TriggerParameters.cls | Object Definition | Simple Data Object definition for Virtual Structure |
