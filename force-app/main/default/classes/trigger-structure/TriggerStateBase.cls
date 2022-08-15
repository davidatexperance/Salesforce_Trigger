/**
 *
 * @format
 * @description :  Case Trigger State Base
 * Tracts the number of times each Trigger State is called and thereby can be utilized for flow control
 *
 * @author : david@experancepartners.com
 * @group :
 * @last modified on  : 08-15-2022
 * @last modified by  : david@experancepartners.com
 *  * 1.0   08-15-2022   david@experancepartners.com   Initial Version
 *
 */ public virtual class TriggerStateBase implements iTriggerState {
    public map<String, Integer> countMap = new Map<String, Integer>();

    public virtual Integer countAt(String tState) {
        Integer runCount = countMap?.get(tState.toLowerCase()) == null
            ? 1
            : countMap.get(tState.toLowerCase());
        runCount++;
        countMap.put(tState.toLowerCase(), runCount);
        return runCount;
    }
}
