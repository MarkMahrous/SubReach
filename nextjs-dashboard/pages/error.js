export default function ErrorPage({ statusCode }) {
  return <div>{statusCode ? `An error ${statusCode}` : "An error occurred"}</div>;
}
