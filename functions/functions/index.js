const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.followUser = functions.https.onCall(async (data, context) => {
    const email = data.email;
    const user = await admin.auth().getUserByEmail(email);
    if (user) {
        admin.firestore().collection('users').doc(user.uid).get().then(doc => {
            return {
                "uid": user.uid,
                "email": user.email,
                "achievements": doc.data().achievements,
                "streak": doc.data().streak.current
            };
        }).catch(_ => {
            throw new functions.https.HttpsError('not-found', 'Error');
        })
    } else {
        throw new functions.https.HttpsError('not-found', 'The user was not found.');
    }
})