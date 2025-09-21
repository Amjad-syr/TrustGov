import React, { useEffect } from "react";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import Card from "react-bootstrap/Card";
import { Bar } from "react-chartjs-2";
// eslint-disable-next-line no-unused-vars
import { Chart as ChartJS } from "chart.js/auto";
import { useSelector, useDispatch } from "react-redux";
import { fetchLatestElection } from "../redux/slices/electionSlice";

export default function DashboardSection({ isDark }) {
    const dispatch = useDispatch();

    const { election, loading, error } = useSelector(
        (state) => state.elections
    );

    useEffect(() => {
        dispatch(fetchLatestElection());
    }, [dispatch]);

    const candidateNames = election?.candidates?.map((c) => c.name) || [];
    const candidateVotes = election?.candidates?.map((c) => c.votes) || [];
    const totalVotes = election?.totalvotes || 0;

    const chartData = {
        labels: candidateNames,
        datasets: [
            {
                label: "Votes",
                data: candidateVotes,
                backgroundColor: [
                    "#4285F4",
                    "#9B59B6",
                    "#2ECC71",
                    "#FF66CC",
                    "#FFA500",
                ],
                borderWidth: 1,
            },
        ],
    };

    const chartOptions = {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
            y: {
                beginAtZero: true,
                ticks: {
                    color: isDark ? "#fff" : "#333",
                },
            },
            x: {
                ticks: {
                    color: isDark ? "#fff" : "#333",
                },
            },
        },
        plugins: {
            legend: {
                labels: {
                    color: isDark ? "#fff" : "#333",
                },
            },
            title: {
                display: true,
                text: "Presidential Elections",
                color: isDark ? "#fff" : "#333",
                font: { size: 16 },
            },
        },
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
                            <h2 className="m-0">Dashboard</h2>
                        </Card.Body>
                    </Card>
                </Col>
            </Row>

            <Row>
                <Col>
                    <h4
                        className="fw-bold mb-4"
                        style={{ color: isDark ? "#fff" : "#333" }}
                    >
                        Presidential Elections
                    </h4>
                </Col>
            </Row>

            {loading && (
                <Row className="mb-4">
                    <Col>
                        <div style={{ color: isDark ? "#fff" : "#333" }}>
                            Loading...
                        </div>
                    </Col>
                </Row>
            )}
            {error && (
                <Row className="mb-4">
                    <Col>
                        <div style={{ color: "red" }}>{error}</div>
                    </Col>
                </Row>
            )}

            <Row className="mb-4">
                <Col xs={12} md={6} lg={3}>
                    <Card
                        className="mb-3"
                        style={{
                            backgroundColor: isDark ? "#3A4B59" : "#D4EFDF",
                            color: isDark ? "#fff" : "#333",
                        }}
                    >
                        <Card.Body>
                            <div className="d-flex align-items-center">
                                <i
                                    className="bi bi-person-fill fs-2 me-3"
                                    style={{ minWidth: "40px" }}
                                />
                                <div>
                                    <h6 className="fw-bold">Total Votes</h6>
                                    <h4>{totalVotes}</h4>
                                </div>
                            </div>
                        </Card.Body>
                    </Card>
                </Col>
            </Row>

            <Row>
                <Col xs={12}>
                    <Card
                        className="mb-4"
                        style={{
                            backgroundColor: isDark ? "#3A4B59" : "#e5e6e7",
                            color: isDark ? "#fff" : "#333",
                        }}
                    >
                        <Card.Body style={{ height: "400px" }}>
                            <Bar data={chartData} options={chartOptions} />
                        </Card.Body>
                    </Card>
                </Col>
            </Row>
        </>
    );
}
