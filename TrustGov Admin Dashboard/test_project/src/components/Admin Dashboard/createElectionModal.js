import { Button, Form, Modal } from "react-bootstrap";
export default function CreateElectionModal({
    isDark,
    showModal,
    data,
    setData,
    handleCloseModal,
    handleCreateElection,
}) {
    return (
        <>
            <Modal
                show={showModal}
                onHide={handleCloseModal}
                contentClassName={isDark ? "bg-dark text-white" : ""}
            >
                <Modal.Header closeButton>
                    <Modal.Title>Create Election</Modal.Title>
                </Modal.Header>
                <Form onSubmit={handleCreateElection}>
                    <Modal.Body>
                        <Form.Group className="mb-3" controlId="electionName">
                            <Form.Label>Name</Form.Label>
                            <Form.Control
                                type="text"
                                placeholder="Enter election name"
                                value={data.name}
                                onChange={(e) =>
                                    setData({ ...data, name: e.target.value })
                                }
                                required
                                style={{
                                    backgroundColor: isDark
                                        ? "#3A4B59"
                                        : "#fff",
                                    color: isDark ? "#fff" : "#333",
                                }}
                            />
                        </Form.Group>
                        <Form.Group className="mb-3" controlId="startDate">
                            <Form.Label>Start Date</Form.Label>
                            <Form.Control
                                type="date"
                                value={data.startDate}
                                onChange={(e) =>
                                    setData({
                                        ...data,
                                        startDate: e.target.value,
                                    })
                                }
                                required
                                style={{
                                    backgroundColor: isDark
                                        ? "#3A4B59"
                                        : "#fff",
                                    color: isDark ? "#fff" : "#333",
                                }}
                            />
                        </Form.Group>
                        <Form.Group className="mb-3" controlId="endDate">
                            <Form.Label>End Date</Form.Label>
                            <Form.Control
                                type="date"
                                value={data.endDate}
                                onChange={(e) =>
                                    setData({
                                        ...data,
                                        endDate: e.target.value,
                                    })
                                }
                                required
                                style={{
                                    backgroundColor: isDark
                                        ? "#3A4B59"
                                        : "#fff",
                                    color: isDark ? "#fff" : "#333",
                                }}
                            />
                        </Form.Group>
                    </Modal.Body>
                    <Modal.Footer>
                        <Button
                            variant={isDark ? "secondary" : "outline-secondary"}
                            onClick={handleCloseModal}
                        >
                            Cancel
                        </Button>
                        <Button
                            type="submit"
                            variant="success"
                            style={{
                                backgroundColor: "#4BABA2",
                                borderColor: "#4BABA2",
                                color: "#333",
                            }}
                        >
                            Create
                        </Button>
                    </Modal.Footer>
                </Form>
            </Modal>
        </>
    );
}
