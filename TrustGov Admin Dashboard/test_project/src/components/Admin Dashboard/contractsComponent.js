import React, { useState } from "react";
import { useSelector, useDispatch } from "react-redux";
import {
    Container,
    Row,
    Col,
    Card,
    Form,
    Modal,
    Button,
    Spinner,
    Alert,
} from "react-bootstrap";
import {
    clearRentalContract,
    fetchRentalContractById,
} from "../../redux/slices/rentalContractSlice";
import {
    clearPurchaseContract,
    fetchPurchaseContractById,
} from "../../redux/slices/purchaseContractSlice";

export default function ContractsComponent() {
    const theme = useSelector((state) => state.theme.theme);
    const isDark = theme === "dark";
    const dispatch = useDispatch();

    const [showModal, setShowModal] = useState(false);
    const [contractType, setContractType] = useState(null);
    const [searchId, setSearchId] = useState("");

    const rentalContract = useSelector(
        (state) => state.rentalContracts.contract
    );
    const rentalLoading = useSelector((state) => state.rentalContracts.loading);
    const rentalError = useSelector((state) => state.rentalContracts.error);

    const purchaseContract = useSelector(
        (state) => state.purchaseContracts.contract
    );
    const purchaseLoading = useSelector(
        (state) => state.purchaseContracts.loading
    );
    const purchaseError = useSelector((state) => state.purchaseContracts.error);

    const handleCardClick = (type) => {
        setContractType(type);
        setShowModal(true);
        setSearchId("");
        if (type === "rental") {
            dispatch(clearRentalContract());
        } else if (type === "purchase") {
            dispatch(clearPurchaseContract());
        }
    };

    const handleCloseModal = () => {
        setShowModal(false);
        setContractType(null);
        setSearchId("");
        dispatch(clearRentalContract());
        dispatch(clearPurchaseContract());
    };
    console.log(
        "Rental Contracts State:",
        useSelector((state) => state.rentalContracts)
    );
    console.log(
        "Purchase Contracts State:",
        useSelector((state) => state.purchaseContracts)
    );

    const handleSearch = () => {
        if (contractType === "rental") {
            dispatch(fetchRentalContractById(searchId));
        } else if (contractType === "purchase") {
            dispatch(fetchPurchaseContractById(searchId));
        }
    };

    const mainCardStyle = {
        backgroundColor: isDark ? "#2F3E4D" : "#f8f9fa",
        color: isDark ? "#fff" : "#333",
        cursor: "pointer",
        textAlign: "center",
        padding: "20px",
        borderRadius: "0.5rem",
        border: "none",
    };

    const headingCardStyle = {
        backgroundColor: isDark ? "#4BABA2" : "#A3DED9",
        color: "#333",
        borderRadius: "0.5rem",
        border: "none",
    };

    return (
        <>
            <Row className="mb-4">
                <Col>
                    <Card style={headingCardStyle}>
                        <Card.Body>
                            <h2 className="m-0">Contracts</h2>
                        </Card.Body>
                    </Card>
                </Col>
            </Row>

            <Container className="py-4">
                <Row className="mb-4">
                    <Col xs={12} md={6} className="mb-3">
                        <Card
                            style={mainCardStyle}
                            onClick={() => handleCardClick("rental")}
                        >
                            <Card.Body>
                                <Card.Title>Rental Contracts</Card.Title>
                                <Card.Text>
                                    Click to search and view rental contract
                                    details by ID.
                                </Card.Text>
                            </Card.Body>
                        </Card>
                    </Col>
                    <Col xs={12} md={6} className="mb-3">
                        <Card
                            style={mainCardStyle}
                            onClick={() => handleCardClick("purchase")}
                        >
                            <Card.Body>
                                <Card.Title>Purchase Contracts</Card.Title>
                                <Card.Text>
                                    Click to search and view purchase contract
                                    details by ID.
                                </Card.Text>
                            </Card.Body>
                        </Card>
                    </Col>
                </Row>
            </Container>

            <Modal show={showModal} onHide={handleCloseModal} centered>
                <Modal.Header closeButton>
                    <Modal.Title>
                        {contractType === "rental"
                            ? "Rental Contract Details"
                            : "Purchase Contract Details"}
                    </Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form.Group controlId="searchId" className="mb-3">
                        <Form.Label>Enter Contract ID:</Form.Label>
                        <Form.Control
                            type="number"
                            placeholder="e.g., 1"
                            value={searchId}
                            onChange={(e) => setSearchId(e.target.value)}
                        />
                    </Form.Group>
                    <Button
                        variant="primary"
                        onClick={handleSearch}
                        disabled={!searchId || searchId <= 0}
                    >
                        Search
                    </Button>

                    <hr />

                    {(rentalLoading || purchaseLoading) && (
                        <div className="text-center my-3">
                            <Spinner animation="border" role="status" />
                        </div>
                    )}

                    {(rentalError || purchaseError) && (
                        <Alert variant="danger">
                            Unexpected Error Happened
                        </Alert>
                    )}

                    {contractType === "rental" && rentalContract && (
                        <div>
                            <p>
                                <strong>ID:</strong> {rentalContract.id}
                            </p>
                            <p>
                                <strong>Buyer ID:</strong>{" "}
                                {rentalContract.buyer_id}
                            </p>
                            <p>
                                <strong>Seller ID:</strong>{" "}
                                {rentalContract.seller_id}
                            </p>
                            <p>
                                <strong>Seller Address:</strong>{" "}
                                {rentalContract.seller_address}
                            </p>
                            <p>
                                <strong>Property ID:</strong>{" "}
                                {rentalContract.property_id}
                            </p>
                            <p>
                                <strong>Property Location:</strong>{" "}
                                {rentalContract.property_location}
                            </p>
                            <p>
                                <strong>Date:</strong> {rentalContract.date}
                            </p>
                        </div>
                    )}

                    {contractType === "purchase" && purchaseContract && (
                        <div>
                            <p>
                                <strong>ID:</strong> {purchaseContract.id}
                            </p>
                            <p>
                                <strong>Buyer ID:</strong>{" "}
                                {purchaseContract.buyer_id}
                            </p>
                            <p>
                                <strong>Seller ID:</strong>{" "}
                                {purchaseContract.seller_id}
                            </p>
                            <p>
                                <strong>Property ID:</strong>{" "}
                                {purchaseContract.property_id}
                            </p>
                            <p>
                                <strong>Property Location:</strong>{" "}
                                {purchaseContract.property_location}
                            </p>
                            <p>
                                <strong>Description:</strong>{" "}
                                {purchaseContract.description}
                            </p>
                            <p>
                                <strong>Total Amount:</strong> $
                                {purchaseContract.total_amount}
                            </p>
                            <p>
                                <strong>Paid Amount:</strong> $
                                {purchaseContract.paid_amount}
                            </p>
                            <p>
                                <strong>Notes:</strong> {purchaseContract.notes}
                            </p>
                            <p>
                                <strong>Date:</strong> {purchaseContract.date}
                            </p>
                        </div>
                    )}
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={handleCloseModal}>
                        Close
                    </Button>
                </Modal.Footer>
            </Modal>
        </>
    );
}
