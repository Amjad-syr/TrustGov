import { createSlice, createAsyncThunk } from "@reduxjs/toolkit";
import { api } from "../../utils/api";

export const fetchRentalContractById = createAsyncThunk(
    "rentalContracts/fetchById",
    async (id, { rejectWithValue }) => {
        try {
            const authData = JSON.parse(localStorage.getItem("auth"));
            const token = authData?.access_token;
            const response = await api.get(`/employee/rental-contracts/${id}`, {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            });
            if (response.data.message !== "ok") {
                return rejectWithValue(response.data.message);
            }
            return response.data.data;
        } catch (error) {
            return rejectWithValue(
                error.response?.data?.message || error.message
            );
        }
    }
);

const rentalContractsSlice = createSlice({
    name: "rentalContracts",
    initialState: {
        contract: null,
        loading: false,
        error: null,
    },
    reducers: {
        clearRentalContract: (state) => {
            state.contract = null;
            state.error = null;
            state.loading = false;
        },
    },
    extraReducers: (builder) => {
        builder
            .addCase(fetchRentalContractById.pending, (state) => {
                state.loading = true;
                state.error = null;
                state.contract = null;
            })
            .addCase(fetchRentalContractById.fulfilled, (state, action) => {
                state.loading = false;
                state.contract = action.payload;
            })
            .addCase(fetchRentalContractById.rejected, (state, action) => {
                state.loading = false;
                state.error = action.payload;
            });
    },
});

export const { clearRentalContract } = rentalContractsSlice.actions;
export default rentalContractsSlice;
