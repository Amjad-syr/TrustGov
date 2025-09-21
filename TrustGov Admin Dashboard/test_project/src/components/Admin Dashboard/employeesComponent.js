import { useSelector } from "react-redux";
import LoadingSpinner from "../loadingSpinner";
import {
    Container,
    Row,
    Col,
    Card,
    Table,
    Form,
    Alert,
    Button,
} from "react-bootstrap";

export default function EmployeesComponent({
    isDark,
    searchTerm,
    setSearchTerm,
    loading,
    error,
    filteredEmployees,
}) {
    const role = useSelector((state) => state.auth.role);
    return (
        <>
            <Container className="py-4">
                <Card
                    style={{
                        backgroundColor: isDark ? "#3A4B59" : "#ffffff",
                        color: isDark ? "#fff" : "#333",
                    }}
                >
                    <Card.Body>
                        {role === 1 && (
                            <Button variant="success" href="/register">
                                Add Employee
                            </Button>
                        )}
                        <Row className="mb-3">
                            <Col className="text-end">
                                <Form.Label className="me-2">
                                    Search:
                                </Form.Label>
                                <Form.Control
                                    type="search"
                                    placeholder="Search by name..."
                                    size="sm"
                                    style={{
                                        width: "200px",
                                        display: "inline-block",
                                    }}
                                    value={searchTerm}
                                    onChange={(e) =>
                                        setSearchTerm(e.target.value)
                                    }
                                />
                            </Col>
                        </Row>

                        {loading && (
                            <div className="text-center my-4">
                                <LoadingSpinner />
                            </div>
                        )}

                        {error && <Alert variant="danger">{error}</Alert>}

                        {!loading && !error && (
                            <Table
                                bordered
                                hover
                                responsive
                                variant={isDark ? "dark" : "light"}
                                className="mb-3"
                            >
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Employee Name</th>
                                        <th>Role</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {filteredEmployees &&
                                    filteredEmployees.length > 0 ? (
                                        filteredEmployees.map((emp, index) => (
                                            <tr key={emp.id}>
                                                <td>{index + 1}</td>
                                                <td>{emp.username}</td>
                                                <td>
                                                    {emp.role === 1 ? (
                                                        <span
                                                            className="badge bg-primary"
                                                            style={{
                                                                fontSize:
                                                                    "0.9rem",
                                                            }}
                                                        >
                                                            Admin
                                                        </span>
                                                    ) : (
                                                        <span
                                                            className="badge bg-secondary"
                                                            style={{
                                                                fontSize:
                                                                    "0.9rem",
                                                            }}
                                                        >
                                                            User
                                                        </span>
                                                    )}
                                                </td>
                                            </tr>
                                        ))
                                    ) : (
                                        <tr>
                                            <td
                                                colSpan="5"
                                                className="text-center"
                                            >
                                                No employees found.
                                            </td>
                                        </tr>
                                    )}
                                </tbody>
                            </Table>
                        )}
                    </Card.Body>
                </Card>
            </Container>
        </>
    );
}
