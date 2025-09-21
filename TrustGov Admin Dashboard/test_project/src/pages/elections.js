import React, { useEffect, useState, useMemo } from "react";
import { useDispatch, useSelector } from "react-redux";
import { Row, Col, Card } from "react-bootstrap";
import CreateElectionModal from "../components/Admin Dashboard/createElectionModal";
import { createElection, getAllElections } from "../redux/slices/electionSlice";
import ElectionsComponent from "../components/Admin Dashboard/electionsComponent";

function ElectionsPage() {
    const theme = useSelector((state) => state.theme.theme);

    const { elections, loading, error } = useSelector(
        (state) => state.elections
    );

    const dispatch = useDispatch();
    const isDark = theme === "dark";

    const [showModal, setShowModal] = useState(false);
    const [data, setData] = useState({
        name: "",
        startDate: "",
        endDate: "",
    });

    const [activeFilter, setActiveFilter] = useState("All");
    const [hasEndedFilter, setHasEndedFilter] = useState("All");

    useEffect(() => {
        dispatch(getAllElections()).unwrap();
    }, [dispatch]);

    const handleOpenModal = () => setShowModal(true);

    const handleCloseModal = () => {
        setShowModal(false);
        setData({
            name: "",
            startDate: "",
            endDate: "",
        });
    };

    const handleCreateElection = (e) => {
        e.preventDefault();
        dispatch(createElection(data))
            .unwrap()
            .then(() => {
                handleCloseModal();
            })
            .catch((error) => {
                console.error("Error creating election:", error);
            });
    };

    const pageStyle = {
        backgroundColor: isDark ? "#2F3E4D" : "#f8f9fa",
        color: isDark ? "#fff" : "#333",
        minHeight: "100vh",
    };

    const filteredElections = useMemo(() => {
        return elections.filter((elec) => {
            const activeCondition =
                activeFilter === "All"
                    ? true
                    : activeFilter === "Yes"
                    ? elec.isActive === true
                    : elec.isActive === false;

            const hasEndedCondition =
                hasEndedFilter === "All"
                    ? true
                    : hasEndedFilter === "Yes"
                    ? elec.hasEnded === true
                    : elec.hasEnded === false;

            return activeCondition && hasEndedCondition;
        });
    }, [elections, activeFilter, hasEndedFilter]);

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
                            <h2 className="m-0">Elections</h2>
                        </Card.Body>
                    </Card>
                </Col>
            </Row>
            <div style={pageStyle}>
                <ElectionsComponent
                    isDark={isDark}
                    handleOpenModal={handleOpenModal}
                    activeFilter={activeFilter}
                    setActiveFilter={setActiveFilter}
                    hasEndedFilter={hasEndedFilter}
                    setHasEndedFilter={setHasEndedFilter}
                    loading={loading}
                    error={error}
                    filteredElections={filteredElections}
                />

                <CreateElectionModal
                    isDark={isDark}
                    showModal={showModal}
                    data={data}
                    setData={setData}
                    handleCloseModal={handleCloseModal}
                    handleCreateElection={handleCreateElection}
                />
            </div>
        </>
    );
}

export default ElectionsPage;
