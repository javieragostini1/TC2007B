firebase.auth().onAuthStateChanged(function(user) {
    if (user) {
      // User is signed in.
  
    //   document.getElementById("user_div").style.display = "block";
    //   document.getElementById("login_div").style.display = "none";
  
      var user = firebase.auth().currentUser;
  
      if(user != null){
        // window.location.replace("./control.html")

        window.location.replace("../index.html")
  
        var email_id = user.email;
        document.getElementById("user_para").innerHTML = "Welcome User : " + email_id;
      
      }
  
    }
    
});
  
  function login(){
  
    var userEmail = document.getElementById("email_field").value;
    var userPass = document.getElementById("password_field").value;
  
    firebase.auth().signInWithEmailAndPassword(userEmail, userPass).catch(function(error) {
      // Handle Errors here.
      var errorCode = error.code;
      var errorMessage = error.message;
  
      window.alert("Error : " + errorMessage);
      
    });
  
  }
  
  function logout(){
    firebase.auth().signOut();
  }
  