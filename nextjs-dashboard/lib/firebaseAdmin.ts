import admin from 'firebase-admin';
import * as serviceAccount from './keys/subreach-c98fd-firebase-adminsdk-da3dx-4bf4c56ccf.json';

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
  });
}

export const auth = admin.auth();