public with sharing class Case_Constants {
    public static final String STATUS_CLOSED = 'Closed';
    public static final String STATUS_WORKING = 'Working';
    public static final String STATUS_SOLVED = 'Solved';

    //created only to get test converage
    public static final String test {
        get {
            if (test == null) {
                test = 'OK';
            }
            return test;
        }
        set;
    }
}
