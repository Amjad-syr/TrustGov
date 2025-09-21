function NotFound() {
  return (
    <>
      <div
        style={{
          minHeight: "100vh",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          textAlign: "center",
          backgroundColor: "#f8f9fa",
          padding: "2rem",
        }}
      >
        <h1
          style={{
            fontSize: "6rem",
            marginBottom: 0,
            color: "#343a40",
          }}
        >
          404
        </h1>
        <h2
          style={{
            marginTop: "0.5rem",
            marginBottom: "1rem",
            color: "#6c757d",
          }}
        >
          Page Not Found
        </h2>
        <p
          style={{
            maxWidth: "500px",
            marginBottom: "2rem",
            color: "#6c757d",
          }}
        >
          Oops! The page you are looking for doesn’t exist, or an error
          occurred. Please check the URL or head back to the homepage.
        </p>
        <a
          href="/"
          style={{
            display: "inline-block",
            padding: "0.75rem 1.5rem",
            backgroundColor: "#0d6efd",
            color: "#fff",
            borderRadius: "0.25rem",
            textDecoration: "none",
            transition: "background-color 0.2s ease",
          }}
        >
          Go to Homepage
        </a>
      </div>
    </>
  );
}
export default NotFound;
