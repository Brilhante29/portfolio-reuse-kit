import http from "k6/http";
import { check } from "k6";

export const options = {
  vus: 10,
  duration: "30s",
  thresholds: {
    http_req_failed: ["rate<0.01"],
    http_req_duration: ["p(95)<500"]
  }
};

export default function () {
  const url = __ENV.TARGET_URL || "http://localhost:8000/health";
  const res = http.get(url);
  check(res, {
    "status is 2xx": (r) => r.status >= 200 && r.status < 300
  });
}
