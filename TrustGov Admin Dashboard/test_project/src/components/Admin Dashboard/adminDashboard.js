import React, { useState, useEffect } from "react";
import { useSelector } from "react-redux";
import AdminSidebar from "./admin-sidebar";
import DashboardSection from "../../pages/dashboard";
import ElectionsPage from "../../pages/elections";
import EmployeesPage from "../../pages/employees";
import ComplaintsComponent from "./complaintsComponent";
import ContractsComponent from "./contractsComponent";

function DashboardPage() {
    const theme = useSelector((state) => state.theme.theme);
    const isDark = theme === "dark";

    const { isLoggedIn } = useSelector((state) => state.auth);

    const [activeTab, setActiveTab] = useState(
        localStorage.getItem("activeTab") || "dashboard"
    );

    useEffect(() => {
        const handleHashChange = () => {
            if (window.location.hash) {
                setActiveTab(window.location.hash.substring(1));
            } else {
                setActiveTab(localStorage.getItem("activeTab"));
            }
        };

        handleHashChange();

        window.addEventListener("hashchange", handleHashChange);
        return () => {
            window.removeEventListener("hashchange", handleHashChange);
        };
    }, []);

    useEffect(() => {
        localStorage.setItem("activeTab", activeTab);
    }, [activeTab]);

    const pageStyle = {
        backgroundColor: isDark ? "#2F3E4D" : "#f8f9fa",
        color: isDark ? "#fff" : "#333",
        minHeight: "100vh",
    };

    const renderContent = () => {
        if (!isLoggedIn) {
            return (
                <div
                    style={{
                        backgroundColor: isDark ? "#3A4B59" : "#f8f9fa",
                        color: isDark ? "#fff" : "#333",
                        padding: "20px",
                        textAlign: "center",
                        borderRadius: "8px",
                    }}
                >
                    <h3>You must be logged in to access this page.</h3>
                </div>
            );
        }

        switch (activeTab) {
            case "dashboard":
                return <DashboardSection isDark={isDark} />;
            case "elections":
                return <ElectionsPage />;
            case "employees":
                return <EmployeesPage />;
            case "complaints":
                return <ComplaintsComponent />;
            case "contracts":
                return <ContractsComponent />;
            default:
                return <div>Select a tab</div>;
        }
    };

    return (
        <div style={pageStyle} className="container-fluid">
            <div className="row">
                <div className="col-auto p-0">
                    <AdminSidebar
                        activeTab={activeTab}
                        setActiveTab={setActiveTab}
                    />
                </div>
                <div className="col pt-3 pb-5">{renderContent()}</div>
            </div>
        </div>
    );
}

export default DashboardPage;
