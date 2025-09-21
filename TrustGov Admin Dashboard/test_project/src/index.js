import React from "react";
import ReactDOM from "react-dom/client";
import "./index.css";
import App from "./App";
import { Provider } from "react-redux";
import store from "./redux/store/store";
import AdminNavbar from "./components/Admin Dashboard/admin-navbar";

const root = ReactDOM.createRoot(document.getElementById("root"));

root.render(
    <React.StrictMode>
        <Provider store={store}>
            <AdminNavbar />
            <App />
        </Provider>
    </React.StrictMode>
);
