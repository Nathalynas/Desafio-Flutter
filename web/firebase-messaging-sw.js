importScripts("https://www.gstatic.com/firebasejs/10.11.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.11.0/firebase-messaging-compat.js");


firebase.initializeApp({
  apiKey: "AIzaSyCPLXk44kchXVR0M3Cnc9qXAIkKA9bwjP0",
  authDomain: "almeidatec-c2c16.firebaseapp.com",
  projectId: "almeidatec-c2c16",
  storageBucket: "almeidatec-c2c16.appspot.com",
  messagingSenderId: "548121456382",
  appId: "1:548121456382:web:c174d24ab76786175c7faf",
  measurementId: "G-F5PDW45JL4",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Mensagem em segundo plano: ', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/icon-192.png', 
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});