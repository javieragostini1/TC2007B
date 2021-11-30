const form = document.querySelector('#log');


firebase.auth().onAuthStateChanged(function(user) {
  
  if (user) {
    var user = firebase.auth().currentUser;

    if(user != null && (user.email == "ana.zuniga@tec.mx" || user.email == "mpamanes@tec.mx")){
      // window.location.replace("./control.html")

      window.location.replace("../index.html")

      var email_id = user.email;
      document.getElementById("user_para").innerHTML = "Welcome User : " + email_id;
    
    } else {
      window.alert("Usuario ingresado no es administrador");
      logout();
    }

  }
  
});

form.addEventListener('submit', (e) => {
  e.preventDefault();

  // window.alert("Bienvenido");
  var userEmail = form.email.value;
  var userPass = form.password.value;
  firebase.auth().signInWithEmailAndPassword(userEmail, userPass).catch(function(error) {
    // Handle Errors here.
    var errorCode = error.code;
    var errorMessage = error.message;

    window.alert("Error : " + errorMessage);
    
  });
  
  
});

// getting data
db.collection('Users').get().then(snapshot => {
  snapshot.docs.forEach(doc => {
      validation(doc);
  });
});

function logout(){
  firebase.auth().signOut();
}