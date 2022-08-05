/**
 *
 * @format
 * @description :  Trigger Parameter Class
 * developed to more easily pass around new and old maps (and newList for beforeInsert)
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-03-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-03-2022   david@experancepartners.com   Initial Version
 *
 */
public class TriggerParameters {
    public List<SObject> newList;
    public Map<Id, SObject> newMap;
    public Map<Id, SObject> oldMap;

    public TriggerParameters(
        List<SObject> nList,
        Map<Id, SObject> nMap,
        Map<Id, SObject> oMap
    ) {
        this.newList = nList;
        this.newMap = nMap;
        this.oldMap = oMap;
    }
}
