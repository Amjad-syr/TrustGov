import { createSlice, createAsyncThunk } from "@reduxjs/toolkit";
import { api } from "../../utils/api";
import { format, parseISO } from "date-fns";
import Swal from "sweetalert2";

export const createElection = createAsyncThunk(
    "elections/createElection",
    async (electionData, { rejectWithValue }) => {
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
            const formattedData = {
                ...electionData,
                start_date: format(
                    parseISO(electionData.startDate),
                    "yyyy/M/d"
                ),
                end_date: format(parseISO(electionData.endDate), "yyyy/M/d"),
            };

            const response = await api.post(
                "/employee/elections",
                formattedData,
                {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                }
            );

            Swal.fire({
                position: "center",
                icon: "success",
                title: "Election Created Successfully",
                showConfirmButton: false,
                timer: 1000,
            });

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

export const getAllElections = createAsyncThunk(
    "elections/getAllElections",
    async (_, { rejectWithValue }) => {
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
            const response = await api.get("/employee/elections", {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            });
            return response.data.data;
        } catch (error) {
            return rejectWithValue(
                error.response?.data?.message || "Something went wrong"
            );
        }
    }
);

export const getLatestElections = createAsyncThunk(
    "elections/getLatestElections",
    async (_, { rejectWithValue }) => {
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
            const response = await api.get("/employee/elections/latest", {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            });
            return response.data.data;
        } catch (error) {
            return rejectWithValue(
                error.response?.data?.message || "Something went wrong"
            );
        }
    }
);

export const deleteElection = createAsyncThunk(
    "elections/deleteElection",
    async (electionId, { rejectWithValue }) => {
        const authData = JSON.parse(localStorage.getItem("auth"));
        const token = authData?.access_token;
        try {
            await api.post(
                `/employee/elections/delete`,
                {
                    election_id: electionId,
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
                title: "Election deleted Successfully",
                showConfirmButton: false,
                timer: 1000,
            });
            return electionId;
        } catch (error) {
            Swal.fire({
                position: "center",
                icon: "error",
                title:
                    error.response?.data?.message ||
                    "Failed to delete election",
                showConfirmButton: false,
                timer: 1500,
            });
            return rejectWithValue(
                error.response?.data || "Failed to delete election  "
            );
        }
    }
);

export const startElection = createAsyncThunk(
    "elections/startElection",
    async (electionId, { rejectWithValue }) => {
        try {
            const authData = JSON.parse(localStorage.getItem("auth"));
            const token = authData?.access_token;

            await api.post(
                "/employee/elections/start",
                { election_id: electionId },
                {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                }
            );

            Swal.fire({
                position: "center",
                icon: "success",
                title: "Election started Successfully",
                showConfirmButton: false,
                timer: 1000,
            });

            return electionId;
        } catch (error) {
            Swal.fire({
                position: "center",
                icon: "error",
                title:
                    error.response?.data?.message || "Failed to start election",
                showConfirmButton: false,
                timer: 1500,
            });
            return rejectWithValue(
                error.response?.data || "Failed to start election"
            );
        }
    }
);

export const endElection = createAsyncThunk(
    "elections/endElection",
    async (electionId, { rejectWithValue }) => {
        try {
            const authData = JSON.parse(localStorage.getItem("auth"));
            const token = authData?.access_token;

            await api.post(
                "/employee/elections/end",
                { election_id: electionId },
                {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                }
            );

            Swal.fire({
                position: "center",
                icon: "success",
                title: "Election ended Successfully",
                showConfirmButton: false,
                timer: 1000,
            });

            return electionId;
        } catch (error) {
            Swal.fire({
                position: "center",
                icon: "error",
                title:
                    error.response?.data?.message || "Failed to end election",
                showConfirmButton: false,
                timer: 1500,
            });
            return rejectWithValue(
                error.response?.data || "Failed to end election"
            );
        }
    }
);

export const fetchLatestElection = createAsyncThunk(
    "elections/fetchLatestElection",
    async (_, { rejectWithValue }) => {
        try {
            const authData = JSON.parse(localStorage.getItem("auth"));
            const token = authData?.access_token;

            const response = await api.get("/employee/elections/latest", {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            });
            return response.data.data;
        } catch (error) {
            return rejectWithValue(
                error.response?.data?.message || "No Active Election Found"
            );
        }
    }
);

const electionsSlice = createSlice({
    name: "elections",
    initialState: {
        elections: [],
        election: {},
        loading: false,
        error: null,
    },
    reducers: {},
    extraReducers: (builder) => {
        builder
            .addCase(createElection.pending, (state) => {
                state.loading = true;
                state.error = null;
            })
            .addCase(createElection.fulfilled, (state, action) => {
                state.loading = false;
                // state.elections.push(action.payload);
            })
            .addCase(createElection.rejected, (state, action) => {
                state.loading = false;
                state.error = action.payload;
            });
        builder
            .addCase(getAllElections.pending, (state) => {
                state.loading = true;
                state.error = null;
            })
            .addCase(getAllElections.fulfilled, (state, action) => {
                state.elections = action.payload;
                state.loading = false;
            })
            .addCase(getAllElections.rejected, (state, action) => {
                state.loading = false;
                state.error = action.payload;
            });
        builder
            .addCase(getLatestElections.pending, (state) => {
                state.loading = true;
                state.error = null;
            })
            .addCase(getLatestElections.fulfilled, (state, action) => {
                state.elections = action.payload;
                state.loading = false;
            })
            .addCase(getLatestElections.rejected, (state, action) => {
                state.loading = false;
                state.error = action.payload;
            });
        builder
            .addCase(deleteElection.pending, (state) => {
                state.loading = true;
                state.error = null;
            })
            .addCase(deleteElection.fulfilled, (state, action) => {
                if (Array.isArray(state.elections)) {
                    state.elections = state.elections.filter(
                        (election) => election.id !== action.payload
                    );
                } else {
                    state.elections = null;
                }
            })

            .addCase(deleteElection.rejected, (state, action) => {
                state.loading = false;
                state.error = action.payload;
            });
        builder
            .addCase(startElection.pending, (state) => {
                state.loading = true;
                state.error = null;
            })
            .addCase(startElection.fulfilled, (state, action) => {
                state.loading = false;
                state.error = null;
                const startedElectionId = action.payload;
                const electionIndex = state.elections.findIndex(
                    (elec) => elec.id === startedElectionId
                );
                if (electionIndex !== -1) {
                    state.elections[electionIndex].isActive = true;
                }
            })
            .addCase(startElection.rejected, (state, action) => {
                state.loading = false;
                state.error = action.payload;
            });
        builder
            .addCase(endElection.pending, (state) => {
                state.loading = true;
                state.error = null;
            })
            .addCase(endElection.fulfilled, (state, action) => {
                state.loading = false;
                state.error = null;
                const endedElectionId = action.payload;
                const electionIndex = state.elections.findIndex(
                    (elec) => elec.id === endedElectionId
                );
                if (electionIndex !== -1) {
                    state.elections[electionIndex].hasEnded = true;
                }
            })
            .addCase(endElection.rejected, (state, action) => {
                state.loading = false;
                state.error = action.payload;
            });
        builder
            .addCase(fetchLatestElection.pending, (state) => {
                state.loading = true;
                state.error = null;
            })
            .addCase(fetchLatestElection.fulfilled, (state, action) => {
                state.loading = false;
                state.error = null;
                state.election = action.payload;
            })
            .addCase(fetchLatestElection.rejected, (state, action) => {
                state.loading = false;
                state.error = action.payload;
            });
    },
});

export default electionsSlice;
