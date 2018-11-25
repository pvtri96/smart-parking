import React from "react";
import ReactDOM from "react-dom";
import App from "./Container/App";
import * as serviceWorker from "./serviceWorker";
import * as Firebase from "firebase";

Firebase.initializeApp({
  apiKey: "AIzaSyBoU3Fl8SqbpcG5IuUL7BeTdVey6adZcSM",
  databaseURL: "https://api-project-211707321887.firebaseio.com/"
});

ReactDOM.render(<App />, document.getElementById("root"));

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: http://bit.ly/CRA-PWA
serviceWorker.unregister();
