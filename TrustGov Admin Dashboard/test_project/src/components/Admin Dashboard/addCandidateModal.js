// src/components/AddCandidateModal.js

import React, { useState } from "react";
import { Modal, Button, Form, Alert } from "react-bootstrap";
import { useDispatch, useSelector } from "react-redux";
import { addCandidate } from "../../redux/slices/candidateSlice";

const AddCandidateModal = ({ show, handleClose, election }) => {
    const dispatch = useDispatch();
    const { loading, error } = useSelector((state) => state.candidates);

    const [formData, setFormData] = useState({
        national_id: "",
        gender: "",
        name: "",
        election_id: election.id,
    });

    const [validated, setValidated] = useState(false);
    const [errors, setErrors] = useState({});

    const handleChange = (e) => {
        const { name, value } = e.target;

        let newValue = value;
        if (name === "national_id") {
            newValue = value.replace(/\D/g, "");
        }

        setFormData({ ...formData, [name]: newValue });

        let error = "";

        if (name === "national_id") {
            if (!/^\d{11}$/.test(newValue)) {
                error = "National ID must be exactly 11 digits.";
            }
        } else if (name === "name") {
            if (newValue.length < 5 || newValue.length > 35) {
                error = "Name must be between 5 and 35 characters.";
            }
        } else if (name === "gender") {
            if (!newValue) {
                error = "Please select a gender.";
            }
        }

        // Update the errors state
        setErrors((prevErrors) => ({ ...prevErrors, [name]: error }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        let formErrors = {};

        // Validate National ID
        if (!/^\d{11}$/.test(formData.national_id)) {
            formErrors.national_id = "National ID must be exactly 11 digits.";
        }

        // Validate Name
        if (formData.name.length < 5 || formData.name.length > 35) {
            formErrors.name = "Name must be between 5 and 35 characters.";
        }

        // Validate Gender
        if (!formData.gender) {
            formErrors.gender = "Please select a gender.";
        }

        setErrors(formErrors);

        if (Object.keys(formErrors).length > 0) {
            setValidated(true);
            return;
        }

        await dispatch(addCandidate(formData));

        if (!error) {
            handleClose();
            setFormData({
                national_id: "",
                gender: "",
                name: "",
                election_id: election.id,
            });
            setErrors({});
            setValidated(false);
        }
    };

    const hasErrors = Object.values(errors).some((errorMsg) => errorMsg);

    return (
        <Modal show={show} onHide={handleClose} centered>
            <Form noValidate validated={validated} onSubmit={handleSubmit}>
                <Modal.Header closeButton>
                    <Modal.Title>
                        Add Candidate to "{election.name}"
                    </Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    {error && <Alert variant="danger">{error}</Alert>}

                    <Form.Group className="mb-3" controlId="formNationalID">
                        <Form.Label>National ID</Form.Label>
                        <Form.Control
                            type="text"
                            placeholder="Enter National ID"
                            name="national_id"
                            value={formData.national_id}
                            onChange={handleChange}
                            required
                            isInvalid={!!errors.national_id}
                            maxLength={11}
                        />
                        <Form.Control.Feedback type="invalid">
                            {errors.national_id}
                        </Form.Control.Feedback>
                    </Form.Group>

                    <Form.Group className="mb-3" controlId="formName">
                        <Form.Label>Name</Form.Label>
                        <Form.Control
                            type="text"
                            placeholder="Enter Candidate Name"
                            name="name"
                            value={formData.name}
                            onChange={handleChange}
                            required
                            isInvalid={!!errors.name}
                        />
                        <Form.Control.Feedback type="invalid">
                            {errors.name}
                        </Form.Control.Feedback>
                    </Form.Group>

                    <Form.Group className="mb-3" controlId="formGender">
                        <Form.Label>Gender</Form.Label>
                        <Form.Select
                            name="gender"
                            value={formData.gender}
                            onChange={handleChange}
                            required
                            isInvalid={!!errors.gender}
                        >
                            <option value="">Select Gender</option>
                            <option value="male">Male</option>
                            <option value="female">Female</option>
                        </Form.Select>
                        <Form.Control.Feedback type="invalid">
                            {errors.gender}
                        </Form.Control.Feedback>
                    </Form.Group>

                    <Form.Control
                        type="hidden"
                        name="election_id"
                        value={formData.election_id}
                    />
                </Modal.Body>
                <Modal.Footer>
                    <Button
                        variant="secondary"
                        onClick={handleClose}
                        disabled={loading}
                    >
                        Cancel
                    </Button>
                    <Button
                        variant="primary"
                        type="submit"
                        disabled={hasErrors || loading}
                    >
                        {loading ? "Adding..." : "Add Candidate"}
                    </Button>
                </Modal.Footer>
            </Form>
        </Modal>
    );
};

export default AddCandidateModal;
