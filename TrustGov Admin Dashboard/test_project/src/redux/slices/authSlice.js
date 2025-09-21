import { createSlice } from "@reduxjs/toolkit";

const storedAuthState = JSON.parse(localStorage.getItem("auth")) || {
    isLoggedIn: false,
    access_token: null,
    role: null,
};

const authSlice = createSlice({
    name: "auth",
    initialState: storedAuthState,
    reducers: {
        login: (state, action) => {
            state.isLoggedIn = true;
            state.access_token = action.payload.access_token;
            state.role = action.payload.role;

            localStorage.setItem(
                "auth",
                JSON.stringify({
                    isLoggedIn: state.isLoggedIn,
                    access_token: state.access_token,
                    role: state.role,
                })
            );
        },
        logout: (state) => {
            state.isLoggedIn = false;
            state.access_token = null;
            state.role = null;

            localStorage.removeItem("auth");
        },
    },
});

export const { login, logout } = authSlice.actions;
export default authSlice;
