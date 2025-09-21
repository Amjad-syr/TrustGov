import React, { useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import AddIcon from "@mui/icons-material/Add";
import {
    Button,
    Container,
    Row,
    Col,
    Card,
    Table,
    Form,
    Alert,
} from "react-bootstrap";
import LoadingSpinner from "../loadingSpinner";
import AddCandidateModal from "./addCandidateModal";
import { useNavigate } from "react-router-dom";
import {
    deleteElection,
    endElection,
    startElection,
} from "../../redux/slices/electionSlice";

export default function ElectionsComponent({
    isDark,
    handleOpenModal,
    activeFilter,
    setActiveFilter,
    hasEndedFilter,
    setHasEndedFilter,
    loading,
    error,
    filteredElections,
}) {
    const [showAddCandidateModal, setShowAddCandidateModal] = useState(false);
    const [selectedElection, setSelectedElection] = useState(null);

    const dispatch = useDispatch();
    const navigate = useNavigate();

    const handleCloseAddCandidateModal = () => setShowAddCandidateModal(false);

    const handleShowAddCandidateModal = (election) => {
        setSelectedElection(election);
        setShowAddCandidateModal(true);
    };

    const handleViewCandidates = (election) => {
        navigate(`/elections/${election.id}/candidates`, {
            state: { election },
        });
    };
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
                        <Row className="mb-3">
                            {role === 1 ? (
                                <Col xs="auto">
                                    <Button
                                        variant="success"
                                        style={{
                                            backgroundColor: "#4BABA2",
                                            borderColor: "#4BABA2",
                                            color: "#333",
                                        }}
                                        onClick={handleOpenModal}
                                    >
                                        <AddIcon />
                                        Create Election
                                    </Button>
                                </Col>
                            ) : null}
                            <Col className="text-end">
                                <Form.Label className="me-2">
                                    Active:
                                </Form.Label>
                                <Form.Select
                                    size="sm"
                                    style={{
                                        width: "150px",
                                        display: "inline-block",
                                        marginRight: "1rem",
                                    }}
                                    value={activeFilter}
                                    onChange={(e) =>
                                        setActiveFilter(e.target.value)
                                    }
                                >
                                    <option value="All">All</option>
                                    <option value="Yes">Yes</option>
                                    <option value="No">No</option>
                                </Form.Select>

                                <Form.Label className="me-2">
                                    Has Ended:
                                </Form.Label>
                                <Form.Select
                                    size="sm"
                                    style={{
                                        width: "150px",
                                        display: "inline-block",
                                    }}
                                    value={hasEndedFilter}
                                    onChange={(e) =>
                                        setHasEndedFilter(e.target.value)
                                    }
                                >
                                    <option value="All">All</option>
                                    <option value="Yes">Yes</option>
                                    <option value="No">No</option>
                                </Form.Select>

                                <Button
                                    variant="secondary"
                                    size="sm"
                                    onClick={() => {
                                        setActiveFilter("All");
                                        setHasEndedFilter("All");
                                    }}
                                    style={{ marginLeft: "1rem" }}
                                >
                                    Clear Filters
                                </Button>
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
                                        <th>Election Name</th>
                                        <th>Candidates Count</th>
                                        <th>Active</th>
                                        <th>Has Ended</th>
                                        <th style={{ width: "220px" }}>
                                            Action
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {filteredElections &&
                                    filteredElections.length > 0 ? (
                                        filteredElections.map((elec, index) => (
                                            <tr key={elec.id}>
                                                <td>{index + 1}</td>
                                                <td>{elec.name}</td>
                                                <td>{elec.candidatesCount}</td>
                                                <td>
                                                    {elec.isActive ? (
                                                        <span
                                                            className="badge bg-success"
                                                            style={{
                                                                fontSize:
                                                                    "0.9rem",
                                                            }}
                                                        >
                                                            Yes
                                                        </span>
                                                    ) : (
                                                        <>
                                                            <span
                                                                className="badge bg-info text-dark"
                                                                style={{
                                                                    fontSize:
                                                                        "0.9rem",
                                                                }}
                                                            >
                                                                No
                                                            </span>
                                                            <br />
                                                            {!elec.hasEnded &&
                                                            elec.candidatesCount >=
                                                                2 ? (
                                                                <>
                                                                    <Button
                                                                        variant={
                                                                            isDark
                                                                                ? "outline-light"
                                                                                : "outline-primary"
                                                                        }
                                                                        size="sm"
                                                                        className="me-2"
                                                                        style={{
                                                                            minWidth:
                                                                                "90px",
                                                                        }}
                                                                        onClick={() =>
                                                                            dispatch(
                                                                                startElection(
                                                                                    elec.id
                                                                                )
                                                                            )
                                                                        }
                                                                    >
                                                                        Activate
                                                                    </Button>
                                                                </>
                                                            ) : null}
                                                        </>
                                                    )}
                                                </td>
                                                <td>
                                                    {elec.hasEnded ? (
                                                        <span
                                                            className="badge bg-danger"
                                                            style={{
                                                                fontSize:
                                                                    "0.9rem",
                                                            }}
                                                        >
                                                            Yes
                                                        </span>
                                                    ) : (
                                                        <>
                                                            <span
                                                                className="badge bg-warning text-dark"
                                                                style={{
                                                                    fontSize:
                                                                        "0.9rem",
                                                                }}
                                                            >
                                                                No
                                                            </span>
                                                            <br />
                                                            {role === 1 &&
                                                            elec.isActive ? (
                                                                <Button
                                                                    variant="danger"
                                                                    size="sm"
                                                                    style={{
                                                                        minWidth:
                                                                            "90px",
                                                                    }}
                                                                    onClick={() =>
                                                                        dispatch(
                                                                            endElection(
                                                                                elec.id
                                                                            )
                                                                        )
                                                                    }
                                                                >
                                                                    End
                                                                </Button>
                                                            ) : null}
                                                        </>
                                                    )}
                                                </td>
                                                <td>
                                                    {role === 1 &&
                                                    !elec.hasEnded ? (
                                                        <Button
                                                            variant={
                                                                isDark
                                                                    ? "outline-light"
                                                                    : "outline-primary"
                                                            }
                                                            size="sm"
                                                            className="me-2"
                                                            onClick={() =>
                                                                handleShowAddCandidateModal(
                                                                    elec
                                                                )
                                                            }
                                                            style={{
                                                                marginRight:
                                                                    "0.5rem",
                                                            }}
                                                        >
                                                            <i className="bi bi-pencil-square me-1" />
                                                            Add Candidate
                                                        </Button>
                                                    ) : null}
                                                    <Button
                                                        variant={
                                                            isDark
                                                                ? "outline-light"
                                                                : "outline-primary"
                                                        }
                                                        size="sm"
                                                        className="me-2"
                                                        onClick={() =>
                                                            handleViewCandidates(
                                                                elec
                                                            )
                                                        }
                                                        style={{
                                                            marginRight:
                                                                "0.5rem",
                                                        }}
                                                    >
                                                        <i className="bi bi-eye me-1" />
                                                        View All Candidates
                                                    </Button>
                                                    {elec.hasEnded === false &&
                                                    elec.isActive === false &&
                                                    role === 1 ? (
                                                        <Button
                                                            variant="danger"
                                                            size="sm"
                                                            style={{
                                                                minWidth:
                                                                    "90px",
                                                            }}
                                                            onClick={() =>
                                                                dispatch(
                                                                    deleteElection(
                                                                        elec.id
                                                                    )
                                                                )
                                                            }
                                                        >
                                                            Delete Election
                                                        </Button>
                                                    ) : null}
                                                </td>
                                            </tr>
                                        ))
                                    ) : (
                                        <tr>
                                            <td
                                                colSpan="6"
                                                className="text-center"
                                            >
                                                No elections found.
                                            </td>
                                        </tr>
                                    )}
                                </tbody>
                            </Table>
                        )}
                    </Card.Body>
                </Card>
            </Container>

            {selectedElection && (
                <AddCandidateModal
                    show={showAddCandidateModal}
                    handleClose={handleCloseAddCandidateModal}
                    election={selectedElection}
                />
            )}
        </>
    );
}
