import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
  apiKey: "AIzaSyBHnLyfkczm885sYWhktmzvTF7LdbPHIy0",
  authDomain: "projetiot-a0f6d.firebaseapp.com",
  projectId: "projetiot-a0f6d",
  storageBucket: "projetiot-a0f6d.firebasestorage.app",
  messagingSenderId: "657380913755",
  appId: "1:657380913755:web:b3fc7e947bfe8f59ff857e"
};

const app = initializeApp(firebaseConfig);

export const db = getFirestore(app);
export const auth = getAuth(app);
export default app;
