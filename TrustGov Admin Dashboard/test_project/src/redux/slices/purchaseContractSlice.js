import { createSlice, createAsyncThunk } from "@reduxjs/toolkit";
import { api } from "../../utils/api";

export const fetchPurchaseContractById = createAsyncThunk(
    "purchaseContracts/fetchById",
    async (id, { rejectWithValue }) => {
        try {
            const authData = JSON.parse(localStorage.getItem("auth"));
            const token = authData?.access_token;
            const response = await api.get(
                `/employee/purchase-contracts/${id}`,
                {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                }
            );
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

const purchaseContractsSlice = createSlice({
    name: "purchaseContracts",
    initialState: {
        contract: null,
        loading: false,
        error: null,
    },
    reducers: {
        clearPurchaseContract: (state) => {
            state.contract = null;
            state.error = null;
            state.loading = false;
        },
    },
    extraReducers: (builder) => {
        builder
            .addCase(fetchPurchaseContractById.pending, (state) => {
                state.loading = true;
                state.error = null;
                state.contract = null;
            })
            .addCase(fetchPurchaseContractById.fulfilled, (state, action) => {
                state.loading = false;
                state.contract = action.payload;
            })
            .addCase(fetchPurchaseContractById.rejected, (state, action) => {
                state.loading = false;
                state.error = action.payload;
            });
    },
});

export const { clearPurchaseContract } = purchaseContractsSlice.actions;
export default purchaseContractsSlice;
