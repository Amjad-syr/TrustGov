import { lazy } from "react";
import DashboardPage from "../components/Admin Dashboard/adminDashboard";
import ViewCandidatesPage from "../components/Admin Dashboard/candidatesInElection";

const Login = lazy(
  () =>
    new Promise((resolve) => {
      setTimeout(() => resolve(import("../components/Auth/login")), 2000);
    })
);
const SignUp = lazy(() => import("../components/Auth/register"));
const NotFound = lazy(() => import("../pages/not-found"));

export const routes = [
  {
    path: "*",
    element: <NotFound />,
  },
  {
    path: "/",
    element: <DashboardPage />,
  },
  {
    path: "/login",
    element: <Login />,
  },
  {
    path: "/register",
    element: <SignUp />,
  },
  {
    path: "/elections/:id/candidates",
    element: <ViewCandidatesPage />,
  },
];
