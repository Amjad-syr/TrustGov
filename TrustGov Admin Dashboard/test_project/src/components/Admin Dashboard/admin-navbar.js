import { useSelector, useDispatch } from "react-redux";
import Container from "react-bootstrap/Container";
import Navbar from "react-bootstrap/Navbar";
import Nav from "react-bootstrap/Nav";
import Button from "react-bootstrap/Button";
import { toggleTheme } from "../../redux/slices/themeSlices";
import { logout } from "../../redux/slices/authSlice";
import { IconButton } from "@mui/material";
import LightModeIcon from "@mui/icons-material/LightMode";
import DarkModeIcon from "@mui/icons-material/DarkMode";

function AdminNavbar() {
    const dispatch = useDispatch();
    const theme = useSelector((state) => state.theme.theme);
    const isLoggedIn = useSelector((state) => state.auth.isLoggedIn);

    const handleLogout = () => {
        localStorage.removeItem("access_token");
        localStorage.removeItem("role");
        dispatch(logout());
    };

    const navbarVariant = theme === "dark" ? "dark" : "light";

    const navbarStyle = {
        background:
            theme === "light"
                ? "linear-gradient(90deg, #ffffff 0%, #f8f9fa 100%)"
                : "linear-gradient(90deg, #343a40 0%, #212529 100%)",
        boxShadow: "0 2px 4px rgba(0, 0, 0, 0.1)",
    };

    const brandStyle = {
        display: "flex",
        alignItems: "center",
        fontWeight: "700",
        fontSize: "1.25rem",
        textTransform: "uppercase",
        letterSpacing: "1px",
        color: theme === "dark" ? "#f8f9fa" : "#212529",
    };

    const brandLogoStyle = {
        marginRight: "0.5rem",
    };

    return (
        <Navbar
            expand="lg"
            bg={navbarVariant}
            variant={navbarVariant}
            sticky="top"
            className="bg-body-tertiary"
            style={navbarStyle}
        >
            <Container>
                <Navbar.Brand href="#dashboard" style={brandStyle}>
                    <img
                        alt="logo"
                        src="/logo.png"
                        width="70"
                        height="70"
                        style={brandLogoStyle}
                    />
                    Trustgov
                </Navbar.Brand>

                <Navbar.Toggle aria-controls="basic-navbar-nav" />

                <Navbar.Collapse id="basic-navbar-nav">
                    <Nav className="ms-auto align-items-center">
                        <IconButton
                            onClick={() => dispatch(toggleTheme())}
                            color={theme === "dark" ? "inherit" : "default"}
                            style={{
                                color: theme === "dark" ? "#f8f9fa" : "#212529",
                            }}
                        >
                            {theme === "dark" ? (
                                <LightModeIcon />
                            ) : (
                                <DarkModeIcon />
                            )}
                        </IconButton>
                        {isLoggedIn ? (
                            <>
                                <Button
                                    variant={
                                        theme === "dark"
                                            ? "outline-light"
                                            : "outline-dark"
                                    }
                                    className="ms-3"
                                    onClick={handleLogout}
                                >
                                    Logout
                                </Button>
                            </>
                        ) : (
                            <>
                                <Button
                                    variant="outline-primary"
                                    className="me-2"
                                    href="/login"
                                >
                                    Login
                                </Button>
                            </>
                        )}
                    </Nav>
                </Navbar.Collapse>
            </Container>
        </Navbar>
    );
}

export default AdminNavbar;
