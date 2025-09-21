import { createSlice, createAsyncThunk } from "@reduxjs/toolkit";
import { api } from "../../utils/api";
import Swal from "sweetalert2";

export const getAllEmployees = createAsyncThunk(
  "employees/getAllEmployees",
  async (_, { rejectWithValue }) => {
    const authData = JSON.parse(localStorage.getItem("auth"));
    const token = authData?.access_token;
    if (!token) {
      Swal.fire({
        position: "center",
        icon: "error",
        title: "Token Expired. Please login again.",
        showConfirmButton: false,
        timer: 1500,
      });
      return rejectWithValue("Token Expired");
    }
    try {
      const response = await api.get("/employee/getall", {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      const employeesArray = Array.isArray(response.data.data)
        ? response.data.data
        : Object.values(response.data.data);
      return employeesArray;
    } catch (error) {
      return rejectWithValue(
        error.response?.data?.message || "Something went wrong"
      );
    }
  }
);

const employeesSlice = createSlice({
  name: "employees",
  initialState: {
    employees: [],
    loading: false,
    error: null,
  },
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(getAllEmployees.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(getAllEmployees.fulfilled, (state, action) => {
        state.employees = action.payload;
        state.loading = false;
      })
      .addCase(getAllEmployees.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      });
  },
});

export default employeesSlice;
