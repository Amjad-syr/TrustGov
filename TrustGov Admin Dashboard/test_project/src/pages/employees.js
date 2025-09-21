import React, { useEffect, useState, useMemo } from "react";
import { useDispatch, useSelector } from "react-redux";
import { Row, Col, Card } from "react-bootstrap";
import { getAllEmployees } from "../redux/slices/employeeSlice";
import EmployeesComponent from "../components/Admin Dashboard/employeesComponent";

function EmployeesPage() {
  const theme = useSelector((state) => state.theme.theme);

  const { employees, loading, error } = useSelector((state) => state.employees);
  const dispatch = useDispatch();
  const isDark = theme === "dark";
  const [searchTerm, setSearchTerm] = useState("");

  useEffect(() => {
    dispatch(getAllEmployees())
      .unwrap()
      .catch((err) => {
        console.error("Failed to fetch employees:", err);
      });
  }, [dispatch]);

  const filteredEmployees = useMemo(() => {
    return employees.filter((emp) =>
      emp.username.toLowerCase().includes(searchTerm.toLowerCase())
    );
  }, [employees, searchTerm]);

  const pageStyle = {
    backgroundColor: isDark ? "#2F3E4D" : "#f8f9fa",
    color: isDark ? "#fff" : "#333",
    minHeight: "100vh",
  };

  return (
    <>
      <Row className="mb-4">
        <Col>
          <Card
            className="border-0"
            style={{
              backgroundColor: isDark ? "#4BABA2" : "#A3DED9",
              color: "#333",
              borderRadius: "0.5rem",
            }}
          >
            <Card.Body>
              <h2 className="m-0">Employees</h2>
            </Card.Body>
          </Card>
        </Col>
      </Row>
      <div style={pageStyle}>
        <EmployeesComponent
          isDark={isDark}
          searchTerm={searchTerm}
          setSearchTerm={setSearchTerm}
          loading={loading}
          error={error}
          filteredEmployees={filteredEmployees}
        />
      </div>
    </>
  );
}

export default EmployeesPage;
