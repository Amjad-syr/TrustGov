import React, { useEffect, useState } from "react";
import {
    Container,
    Row,
    Col,
    Card,
    Button,
    Alert,
    Spinner,
    Badge,
} from "react-bootstrap";
import { useParams, useNavigate, useLocation } from "react-router-dom";
import { api } from "../../utils/api";
import { useDispatch, useSelector } from "react-redux";
import { deleteCandidate } from "../../redux/slices/candidateSlice";

const ViewCandidatesPage = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const location = useLocation();
    const dispatch = useDispatch();

    const [candidates, setCandidates] = useState([]);
    // eslint-disable-next-line no-unused-vars
    const [totalVotes, setTotalVotes] = useState(0);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");
    const role = useSelector((state) => state.auth.role);
    const electionName = location.state?.election?.name || "Election";

    useEffect(() => {
        const fetchCandidates = async () => {
            try {
                const authData = JSON.parse(localStorage.getItem("auth"));
                const token = authData?.access_token;

                if (!token) {
                    setError("Token expired. Please login again.");
                    setLoading(false);
                    return;
                }

                const response = await api.get(
                    `/employee/elections/${id}/candidates`,
                    {
                        headers: {
                            Authorization: `Bearer ${token}`,
                        },
                    }
                );

                const data = response.data.data;
                setCandidates(data);

                const votes = data.reduce(
                    (acc, candidate) => acc + candidate.votes,
                    0
                );
                setTotalVotes(votes);

                setLoading(false);
            } catch (err) {
                setError(
                    err.response?.data?.message ||
                        "Something went wrong while fetching candidates."
                );
                setLoading(false);
            }
        };

        fetchCandidates();
    }, [id, candidates]);

    const handleBack = () => {
        navigate(-1);
    };

    return (
        <Container className="py-4">
            <Row className="mb-3">
                <Col>
                    <Button variant="secondary" onClick={handleBack}>
                        &larr; Back
                    </Button>
                </Col>
            </Row>
            <h2 className="mb-4">
                All Candidates for Election: {electionName}
            </h2>

            {loading && (
                <div style={{ textAlign: "center", margin: "20px 0" }}>
                    <Spinner animation="border" variant="primary" />
                </div>
            )}

            {error && <Alert variant="danger">{error}</Alert>}

            {!loading && !error && candidates.length === 0 && (
                <Alert variant="info">
                    No candidates found for this election.
                </Alert>
            )}

            {!loading && !error && candidates.length > 0 && (
                <Row xs={1} sm={2} md={3} lg={4} className="g-4">
                    {candidates.map((candidate, index) => (
                        <Col key={index}>
                            <Card
                                className="h-100 shadow-sm"
                                style={{
                                    cursor: "pointer",
                                    transition: "transform 0.2s",
                                }}
                                onMouseEnter={(e) =>
                                    (e.currentTarget.style.transform =
                                        "scale(1.02)")
                                }
                                onMouseLeave={(e) =>
                                    (e.currentTarget.style.transform =
                                        "scale(1)")
                                }
                            >
                                <Card.Body className="d-flex flex-column">
                                    <div>
                                        <Card.Title
                                            className="mb-2"
                                            style={{
                                                fontSize: "1.2rem",
                                                fontWeight: "bold",
                                            }}
                                        >
                                            {candidate.name}
                                        </Card.Title>
                                    </div>

                                    {/* Votes */}
                                    <div className="mt-3">
                                        <Badge bg="primary" pill>
                                            Votes: {candidate.votes}
                                        </Badge>
                                    </div>
                                    {role === 1 && (
                                        <div className="mt-auto d-flex justify-content-end">
                                            <Button
                                                variant="danger"
                                                size="sm"
                                                style={{ minWidth: "90px" }}
                                                onClick={() =>
                                                    dispatch(
                                                        deleteCandidate({
                                                            electionId: id,
                                                            national_id:
                                                                candidate.National_Id,
                                                        })
                                                    )
                                                }
                                            >
                                                Delete Candidate
                                            </Button>
                                        </div>
                                    )}
                                </Card.Body>
                            </Card>
                        </Col>
                    ))}
                </Row>
            )}
        </Container>
    );
};

export default ViewCandidatesPage;
