importScripts("https://www.gstatic.com/firebasejs/10.11.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.11.0/firebase-messaging-compat.js");

// Substitua pelos seus dados do Firebase
firebase.initializeApp({
  apiKey: "AIzaSyCPLxK44ckhXVR0M3Cnc9qXAIkKA9bwjP0",
  authDomain: "almeidatec-c2c16.firebaseapp.com",
  projectId: "almeidatec-c2c16",
  storageBucket: "almeidatec-c2c16.appspot.com",
  messagingSenderId: "548124156382",
  appId: "1:548124156382:web:c174d24ab76786175c7faf",
});

const messaging = firebase.messaging();
