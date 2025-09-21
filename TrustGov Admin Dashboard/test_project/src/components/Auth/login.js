import { useState } from "react";
import { api } from "../../utils/api";
import { login } from "../../redux/slices/authSlice";
import { useDispatch, useSelector } from "react-redux";
import Swal from "sweetalert2";
import { useNavigate } from "react-router-dom";

function Login() {
  const navigate = useNavigate();
  const theme = useSelector((state) => state.theme.theme);
  const isDark = theme === "dark";
  const [data, setData] = useState({
    username: "",
    password: "",
  });
  const dispatch = useDispatch();

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await api.post("/employee/login", data);
      const access_token = response.data.data.access_token;
      const role = response.data.data.user.role;

      const authData = {
        isLoggedIn: true,
        access_token,
        role,
      };
      localStorage.setItem("auth", JSON.stringify(authData));

      dispatch(login(authData));

      Swal.fire({
        position: "center",
        icon: "success",
        title: "Login Successful",
        showConfirmButton: false,
        timer: 1000,
      });

      setTimeout(() => navigate("/"), 1000);
    } catch (error) {
      Swal.fire({
        position: "center",
        icon: "error",
        title: error.response?.data?.message || "Something went wrong",
        showConfirmButton: false,
        timer: 1500,
      });
    }
  };

  const pageStyle = {
    backgroundColor: isDark ? "#1c1c1c" : "#f8f9fa",
    color: isDark ? "#ffffff" : "#333333",
    minHeight: "100vh",
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
  };

  const cardStyle = {
    backgroundColor: isDark ? "#333333" : "#ffffff",
    color: isDark ? "#ffffff" : "#333333",
    borderRadius: "8px",
    boxShadow: isDark
      ? "0 4px 8px rgba(0, 0, 0, 0.8)"
      : "0 4px 8px rgba(0, 0, 0, 0.1)",
  };

  const inputStyle = {
    backgroundColor: isDark ? "#444444" : "#ffffff",
    color: isDark ? "#ffffff" : "#333333",
    border: `1px solid ${isDark ? "#555555" : "#cccccc"}`,
  };

  return (
    <div style={pageStyle}>
      <div
        className="card shadow p-4"
        style={{ ...cardStyle, maxWidth: "400px", width: "100%" }}
      >
        <h3 className="text-center mb-4" style={{ color: "#007bff" }}>
          Welcome Back
        </h3>
        <p
          className="text-center mb-4"
          style={{ color: isDark ? "#bbbbbb" : "#6c757d" }}
        >
          Log in to your account to continue exploring our services.
        </p>
        <form onSubmit={handleSubmit}>
          <div className="mb-3">
            <label htmlFor="username" className="form-label">
              Username
            </label>
            <input
              value={data.username}
              onChange={(e) => setData({ ...data, username: e.target.value })}
              type="text"
              className="form-control"
              id="username"
              placeholder="Enter your username"
              required
              style={inputStyle}
            />
          </div>
          <div className="mb-3">
            <label htmlFor="password" className="form-label">
              Password
            </label>
            <input
              value={data.password}
              onChange={(e) => setData({ ...data, password: e.target.value })}
              type="password"
              className="form-control"
              id="password"
              placeholder="Enter your password"
              required
              style={inputStyle}
            />
          </div>
          <button type="submit" className="btn btn-primary w-100 mt-4">
            Login
          </button>
        </form>
        <p className="text-center mt-3">
          Don't have an account?{" "}
          <a href="/register" className="text-primary text-decoration-none">
            Sign up
          </a>
        </p>
      </div>
    </div>
  );
}

export default Login;
