const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.followUser = functions.https.onCall(async (data, context) => {

    if (!context.auth) {
        throw new functions.https.HttpsError('permission-denied');
    }
    const email = data.email;
    if (context.auth.email == data.email) {
        throw new functions.https.HttpsError('invalid-argument');
    }
    const user = await admin.auth().getUserByEmail(email).catch(() => {
        throw new functions.https.HttpsError('not-found');
    });
    const doc = await admin.firestore().collection('users').doc(user.uid).get().catch(() => {
        throw new functions.https.HttpsError('unknown');
    })
    return {
        "uid": user.uid,
        "email": user.email,
        "achievements": doc.data().achievements,
        "streak": doc.data().streak.current
    }
})