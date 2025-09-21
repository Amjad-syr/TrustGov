import { useState } from "react";
import { useSelector } from "react-redux";
import Swal from "sweetalert2";
import { api } from "../../utils/api";
import { useNavigate } from "react-router-dom";

export default function SignupPage() {
    const navigate = useNavigate();
    const theme = useSelector((state) => state.theme.theme);
    const isDark = theme === "dark";

    const [data, setData] = useState({
        username: "",
        password: "",
    });

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const authData = JSON.parse(localStorage.getItem("auth"));
            const token = authData?.access_token;
            if (!token) {
                Swal.fire({
                    position: "center",
                    icon: "error",
                    title: "Unauthorized",
                    showConfirmButton: false,
                    timer: 1000,
                });
            }
            await api.post("/employee/register", data, {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            });
            Swal.fire({
                position: "center",
                icon: "success",
                title: "Account Created Successfully",
                showConfirmButton: false,
                timer: 1000,
            }).then(() => {
                navigate(-1);
            });
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
                    Create an Account
                </h3>
                <p
                    className="text-center mb-4"
                    style={{ color: isDark ? "#bbbbbb" : "#6c757d" }}
                >
                    Join us and start your journey today!
                </p>
                <form onSubmit={handleSubmit}>
                    <div className="mb-3">
                        <label htmlFor="username" className="form-label">
                            Username
                        </label>
                        <input
                            type="text"
                            className="form-control"
                            value={data.username}
                            onChange={(e) =>
                                setData({ ...data, username: e.target.value })
                            }
                            id="username"
                            placeholder="Enter employee's username"
                            required
                            style={inputStyle}
                        />
                    </div>
                    <div className="mb-3">
                        <label htmlFor="password" className="form-label">
                            Password
                        </label>
                        <input
                            type="password"
                            className="form-control"
                            value={data.password}
                            onChange={(e) =>
                                setData({ ...data, password: e.target.value })
                            }
                            id="password"
                            placeholder="Create a password"
                            required
                            style={inputStyle}
                        />
                    </div>
                    <button
                        type="submit"
                        className="btn btn-primary w-100 mt-4"
                    >
                        Add Employee
                    </button>
                </form>
                <p className="text-center mt-3">
                    Already have an account?{" "}
                    <a
                        href="/login"
                        className="text-primary text-decoration-none"
                    >
                        Login
                    </a>
                </p>
            </div>
        </div>
    );
}
