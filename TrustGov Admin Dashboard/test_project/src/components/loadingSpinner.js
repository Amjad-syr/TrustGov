export default function LoadingSpinner() {
  return (
    <div
      style={{
        display: "flex",
        height: "100vh",
        justifyContent: "center",
        alignItems: "center",
        flexDirection: "column",
        textAlign: "center",
      }}
    >
      <style>
        {`
            @keyframes pulse {
              0% {
                transform: scale(1);
              }
              50% {
                transform: scale(1.2);
              }
              100% {
                transform: scale(1);
              }
            }
          `}
      </style>

      <img
        src="/logo.png"
        alt="Project Logo"
        style={{
          width: "80px",
          height: "80px",
          animation: "pulse 2s ease-in-out infinite",
        }}
      />
    </div>
  );
}
