// editing for changes

public class ContactTriggerHandler {

    public static void beforeInsert(List<Contact> newContacts) {
        for (Contact con : newContacts) {
            if (con.DummyJSON_Id_c__c == null) {
                con.DummyJSON_Id_c__c = String.valueOf(Math.mod(Crypto.getRandomInteger(), 101));
            }
        }
    }

    public static void afterInsert(List<Contact> newContacts) {
        List<Contact> toCall = new List<Contact>();
        for (Contact con : newContacts) {
            Integer idVal;
            try {
                idVal = Integer.valueOf(con.DummyJSON_Id_c__c);
            } catch (Exception e) {
                continue;
            }
            if (idVal != null && idVal <= 100) {
                toCall.add(con);
            }
        }

        for (Contact con : toCall) {
            DummyJSONCallout.getDummyJSONUserFromId(con.DummyJSON_Id_c__c); // pass String, as required
        }
    }

    public static void afterUpdate(List<Contact> updatedContacts, Map<Id, Contact> oldMap) {
        List<Contact> toPost = new List<Contact>();
        for (Contact con : updatedContacts) {
            Contact oldCon = oldMap.get(con.Id);

            Integer newVal, oldVal;
            try {
                newVal = Integer.valueOf(con.DummyJSON_Id_c__c);
                oldVal = Integer.valueOf(oldCon.DummyJSON_Id_c__c);
            } catch (Exception e) {
                continue;
            }

            if (newVal != null && newVal > 100 &&
                (oldVal == null || oldVal <= 100)) {
                toPost.add(con);
            }
        }

        for (Contact con : toPost) {
            DummyJSONCallout.postCreateDummyJSONUser(con.Id); // pass Contact.Id as String
        }
    }
}


