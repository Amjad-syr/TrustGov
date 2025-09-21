import React from "react";
import Nav from "react-bootstrap/Nav";
import NavItem from "react-bootstrap/NavItem";
import NavLink from "react-bootstrap/NavLink";
import { useSelector } from "react-redux";
import {
  Dashboard,
  People,
  HowToVote,
  ReportProblem,
  Description,
} from "@mui/icons-material";

function AdminSidebar({ activeTab, setActiveTab }) {
  const theme = useSelector((state) => state.theme.theme);
  const isDark = theme === "dark";

  const sidebarStyle = {
    width: "250px",
    minHeight: "100vh",
    backgroundColor: isDark ? "#2F3E4D" : "#f8f9fa",
    color: isDark ? "#ffffff" : "#333333",
  };

  const getNavLinkStyle = (tab) => {
    const isActive = activeTab === tab;
    if (isActive) {
      return {
        backgroundColor: isDark ? "#4BABA2" : "#6CC4BB",
        color: "#333",
      };
    } else {
      return { color: sidebarStyle.color };
    }
  };

  return (
    <aside
      className="flex-shrink-0 d-flex flex-column p-3"
      style={sidebarStyle}
    >
      <Nav className="flex-column mb-auto">
        <NavItem className="mb-1">
          <NavLink
            href="#dashboard"
            className="d-flex align-items-center text-decoration-none"
            style={getNavLinkStyle("dashboard")}
            onClick={() => setActiveTab("dashboard")}
          >
            <Dashboard className="me-2" />
            <span>Dashboard</span>
          </NavLink>
        </NavItem>

        <NavItem className="mb-1">
          <NavLink
            href="#employees"
            className="d-flex align-items-center text-decoration-none"
            style={getNavLinkStyle("employees")}
            onClick={() => setActiveTab("employees")}
          >
            <People className="me-2" />
            <span>Employees</span>
          </NavLink>
        </NavItem>

        <NavItem className="mb-1">
          <NavLink
            href="#elections"
            className="d-flex align-items-center text-decoration-none"
            style={getNavLinkStyle("elections")}
            onClick={() => setActiveTab("elections")}
          >
            <HowToVote className="me-2" />
            <span>Elections</span>
          </NavLink>
        </NavItem>

        <NavItem className="mb-1">
          <NavLink
            href="#complaints"
            className="d-flex align-items-center text-decoration-none"
            style={getNavLinkStyle("complaints")}
            onClick={() => setActiveTab("complaints")}
          >
            <ReportProblem className="me-2" />
            <span>Complaints</span>
          </NavLink>
        </NavItem>

        <NavItem className="mb-1">
          <NavLink
            href="#contracts"
            className="d-flex align-items-center text-decoration-none"
            style={getNavLinkStyle("contracts")}
            onClick={() => setActiveTab("contracts")}
          >
            <Description className="me-2" />
            <span>Contracts</span>
          </NavLink>
        </NavItem>
      </Nav>

      <hr className={isDark ? "text-secondary" : "text-muted"} />

      <div className="small mt-auto">© 2025 TRUSTGOV</div>
    </aside>
  );
}

export default AdminSidebar;
