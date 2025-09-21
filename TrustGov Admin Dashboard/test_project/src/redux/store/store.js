import { configureStore } from "@reduxjs/toolkit";
import authSlice from "../slices/authSlice";
import themeSlice from "../slices/themeSlices";
import electionSlice from "../slices/electionSlice";
import employeesSlice from "../slices/employeeSlice";
import candidatesSlice from "../slices/candidateSlice";
import rentalContractsSlice from "../slices/rentalContractSlice";
import purchaseContractsSlice from "../slices/purchaseContractSlice";

const store = configureStore({
    reducer: {
        auth: authSlice.reducer,
        theme: themeSlice.reducer,
        elections: electionSlice.reducer,
        employees: employeesSlice.reducer,
        candidates: candidatesSlice.reducer,
        rentalContracts: rentalContractsSlice.reducer,
        purchaseContracts: purchaseContractsSlice.reducer,
    },
});

export default store;
