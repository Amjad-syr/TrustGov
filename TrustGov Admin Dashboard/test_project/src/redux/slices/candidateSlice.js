import { createSlice, createAsyncThunk } from "@reduxjs/toolkit";
import { api } from "../../utils/api";
import Swal from "sweetalert2";
import { getAllElections } from "./electionSlice";

export const addCandidate = createAsyncThunk(
    "candidates/addCandidate",
    async (candidatesData, { dispatch, rejectWithValue }) => {
        const authData = JSON.parse(localStorage.getItem("auth"));
        const token = authData?.access_token;
        if (!token) {
            Swal.fire({
                position: "center",
                icon: "error",
                title: "Token Expired Please Login Again.",
                showConfirmButton: false,
                timer: 1500,
            });
            return rejectWithValue("Token Expired");
        }

        try {
            const response = await api.post(
                "/employee/elections/addcandidate ",
                candidatesData,
                {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                }
            );

            Swal.fire({
                position: "center",
                icon: "success",
                title: "Candidate Addded Successfully",
                showConfirmButton: false,
                timer: 1000,
            });
            dispatch(getAllElections());
            return response.data.data;
        } catch (error) {
            Swal.fire({
                position: "center",
                icon: "error",
                title: error.response?.data?.message || "Something went wrong",
                showConfirmButton: false,
                timer: 1500,
            });

            return rejectWithValue(
                error.response?.data?.message || "Something went wrong"
            );
        }
    }
);

export const getAllCandidates = createAsyncThunk(
    "candidates/getAllCandidates",
    async (id, { rejectWithValue }) => {
        const authData = JSON.parse(localStorage.getItem("auth"));
        const token = authData?.access_token;
        if (!token) {
            Swal.fire({
                position: "center",
                icon: "error",
                title: "Token Expired Please Login Again.",
                showConfirmButton: false,
                timer: 1500,
            });
            return rejectWithValue("Token Expired");
        }
        try {
            const response = await api.get(
                `/employee/elections/${id}/candidates`,
                {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                }
            );
            return response.data.data;
        } catch (error) {
            return rejectWithValue(
                error.response?.data?.message || "Something went wrong"
            );
        }
    }
);

export const deleteCandidate = createAsyncThunk(
    "candidates/deleteCandidate",
    async (data, { rejectWithValue }) => {
        const authData = JSON.parse(localStorage.getItem("auth"));
        const token = authData?.access_token;
        try {
            await api.post(
                `/employee/elections/candidates/delete`,
                {
                    election_id: data.electionId,
                    national_id: data.national_id,
                },
                {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                }
            );
            Swal.fire({
                position: "center",
                icon: "success",
                title: "Candidate deleted Successfully",
                showConfirmButton: false,
                timer: 1000,
            });
            return data;
        } catch (error) {
            Swal.fire({
                position: "center",
                icon: "error",
                title:
                    error.response?.data?.message ||
                    "Failed to delete candidate",
                showConfirmButton: false,
                timer: 1500,
            });
            return rejectWithValue(
                error.response?.data || "Failed to delete candidate  "
            );
        }
    }
);
const candidatesSlice = createSlice({
    name: "candidates",
    initialState: {
        candidates: [],
        loading: false,
        error: null,
    },
    reducers: {},
    extraReducers: (builder) => {
        builder
            .addCase(addCandidate.pending, (state) => {
                state.loading = true;
                state.error = null;
            })
            .addCase(addCandidate.fulfilled, (state, action) => {
                state.loading = false;
                state.candidates.push(action.payload);
            })
            .addCase(addCandidate.rejected, (state, action) => {
                state.loading = false;
                state.error = action.payload;
            });
        builder
            .addCase(getAllCandidates.pending, (state) => {
                state.loading = true;
                state.error = null;
            })
            .addCase(getAllCandidates.fulfilled, (state, action) => {
                state.elections = action.payload;
                state.loading = false;
            })
            .addCase(getAllCandidates.rejected, (state, action) => {
                state.loading = false;
                state.error = action.payload;
            });
        builder
            .addCase(deleteCandidate.pending, (state) => {
                state.loading = true;
                state.error = null;
            })
            .addCase(deleteCandidate.fulfilled, (state, action) => {
                if (Array.isArray(state.candidates)) {
                    state.candidates = state.candidates.filter(
                        (candidate) => candidate._id !== action.payload
                    );
                } else {
                    state.candidates = null;
                }
            })
            .addCase(deleteCandidate.rejected, (state, action) => {
                state.loading = false;
                state.error = action.payload;
            });
    },
});

export default candidatesSlice;
