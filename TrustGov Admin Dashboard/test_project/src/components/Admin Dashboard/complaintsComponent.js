import { useState } from "react";
import {
  Container,
  Row,
  Col,
  Card,
  Table,
  Form,
  Alert,
  Modal,
} from "react-bootstrap";
import LoadingSpinner from "../loadingSpinner";
import { useSelector } from "react-redux";
import { dummyComplaints } from "../../Data/complaints";

export default function ComplaintsComponent() {
  const theme = useSelector((state) => state.theme.theme);
  const isDark = theme === "dark";
  const loading = false;
  const error = null;

  const [searchTerm, setSearchTerm] = useState("");

  const filteredContracts = dummyComplaints.filter(
    (contract) =>
      contract.desc.toLowerCase().includes(searchTerm.toLowerCase()) ||
      contract.location.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const [showModal, setShowModal] = useState(false);
  const [modalImage, setModalImage] = useState("");

  const handleImageClick = (imgSrc) => {
    setModalImage(imgSrc);
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setModalImage("");
    setShowModal(false);
  };

  const renderStatusBadge = (status) => {
    let variant = "secondary";
    if (status.toLowerCase() === "active") variant = "success";
    if (status.toLowerCase() === "pending") variant = "warning";
    if (status.toLowerCase() === "completed") variant = "secondary";

    return (
      <span className={`badge bg-${variant}`} style={{ fontSize: "0.9rem" }}>
        {status}
      </span>
    );
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
              <h2 className="m-0">Complaints</h2>
            </Card.Body>
          </Card>
        </Col>
      </Row>

      <Container className="py-4">
        <Card
          style={{
            backgroundColor: isDark ? "#3A4B59" : "#ffffff",
            color: isDark ? "#fff" : "#333",
          }}
        >
          <Card.Body>
            <Row className="mb-3">
              <Col className="text-end">
                <Form.Label className="me-2">Search:</Form.Label>
                <Form.Control
                  type="search"
                  placeholder="Search by description or location..."
                  size="sm"
                  style={{ width: "250px", display: "inline-block" }}
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
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
                    <th>Photo 1</th>
                    <th>Photo 2</th>
                    <th>Description</th>
                    <th>Location</th>
                    <th>Status</th>
                    <th>Total Votes</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredContracts && filteredContracts.length > 0 ? (
                    filteredContracts.map((contract, index) => (
                      <tr key={contract.id}>
                        <td>{index + 1}</td>

                        <td>
                          <img
                            src={contract.photo_path1}
                            alt="First complaint"
                            style={{ width: "60px", cursor: "pointer" }}
                            onClick={() =>
                              handleImageClick(contract.photo_path1)
                            }
                          />
                        </td>

                        <td>
                          <img
                            src={contract.photo_path2}
                            alt="Second complaint"
                            style={{ width: "60px", cursor: "pointer" }}
                            onClick={() =>
                              handleImageClick(contract.photo_path2)
                            }
                          />
                        </td>

                        <td>{contract.desc}</td>
                        <td>{contract.location}</td>
                        <td>{renderStatusBadge(contract.status)}</td>
                        <td>{contract.total_votes}</td>
                      </tr>
                    ))
                  ) : (
                    <tr>
                      <td colSpan="8" className="text-center">
                        No contracts found.
                      </td>
                    </tr>
                  )}
                </tbody>
              </Table>
            )}
          </Card.Body>
        </Card>
      </Container>

      <Modal show={showModal} onHide={handleCloseModal} size="lg" centered>
        <Modal.Header closeButton className="border-0" />
        <Modal.Body className="text-center">
          <img
            src={modalImage}
            alt="Zoomed complaint"
            style={{ maxWidth: "100%", maxHeight: "80vh" }}
          />
        </Modal.Body>
      </Modal>
    </>
  );
}
