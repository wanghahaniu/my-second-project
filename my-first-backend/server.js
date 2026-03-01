// server.js
const http = require("http");
const { URL } = require("url");

/**
 * 一个最小但“像样”的 HTTP 后端：
 * 一个最小但“像样”的 HTTP 后端：
 * - 打印请求 METHOD / PATH / QUERY
 * - 简单路由：/  /hello  /api/time  /api/echo
 * - 返回 JSON / 文本
 * - 404 处理
 */

const server = http.createServer((req, res) => {
  // 1) 解析 URL
  const fullUrl = new URL(req.url, `http://${req.headers.host || "localhost"}`);
  const pathname = fullUrl.pathname; // 例如："/api/time"
  const query = Object.fromEntries(fullUrl.searchParams.entries()); // 例如：{ x: "1" }

  // 2) 打印请求信息
  console.log("----- NEW REQUEST -----");
  console.log("METHOD:", req.method);
  console.log("PATH:", pathname);
  console.log("QUERY:", query);

  // 3) 路由

  // 首页
  if (req.method === "GET" && pathname === "/") {
    res.writeHead(200, { "Content-Type": "text/plain; charset=utf-8" });
    return res.end(
      [
        "你好！这是一个更完整的本地后端服务 😄",
        "",
        "试试这些地址：",
        "1) http://localhost:3000/hello",
        "2) http://localhost:3000/api/time",
        "3) http://localhost:3000/api/echo?name=tan&lang=zh",
      ].join("\n")
    );
  }

  // /hello
  if (req.method === "GET" && pathname === "/hello") {
    res.writeHead(200, { "Content-Type": "text/plain; charset=utf-8" });
    return res.end("hello! 你已经学会路由了 ✅");
  }

  // /api/time
  if (req.method === "GET" && pathname === "/api/time") {
    const payload = {
      ok: true,
      now: Date.now(),
      iso: new Date().toISOString(),
    };

    res.writeHead(200, { "Content-Type": "application/json; charset=utf-8" });
    return res.end(JSON.stringify(payload, null, 2));
  }

  // /api/echo
  if (req.method === "GET" && pathname === "/api/echo") {
    const payload = {
      ok: true,
      method: req.method,
      path: pathname,
      query,
    };

    res.writeHead(200, { "Content-Type": "application/json; charset=utf-8" });
    return res.end(JSON.stringify(payload, null, 2));
  }

  // 4) 404
  res.writeHead(404, { "Content-Type": "application/json; charset=utf-8" });
  return res.end(
    JSON.stringify(
      {
        ok: false,
        error: "Not Found",
        hint: "Try /, /hello, /api/time, /api/echo",
        got: { method: req.method, path: pathname },
      },
      null,
      2
    )
  );
});

server.listen(3001, () => {
  console.log("Server running at http://localhost:3001);
});