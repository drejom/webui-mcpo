# 🧠 webui-mcpo: Run Multiple MCP Tools with a Single Config on Open WebUI

**Docker Hub Image**: [`masterno12/webui-mcpo:latest`](https://hub.docker.com/r/masterno12/webui-mcpo)

This Docker image provides a ready-to-use instance of [MCPO](https://github.com/open-webui/mcpo), a lightweight, composable MCP (Model Context Protocol) server designed to proxy multiple MCP tools in one unified API server — using a simple config file in the **Claude Desktop format**.

> 🔗 **What is MCP?**  
> Learn more at the [Open WebUI MCP Server docs](https://docs.openwebui.com/openapi-servers/mcp)  
> Supported official MCP servers: https://github.com/modelcontextprotocol/servers

---

## 🚀 Quick Start (with Docker Hub)

### 1. Pull the image

```bash
docker pull masterno12/webui-mcpo:latest
```

### 2. Create a `config.json`

You must provide a `config.json` under `/opt/mcpo` inside the container. If the file does not exist, the container will automatically generate a minimal default one.

📄 **Example `config.json`:**

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "time": {
      "command": "uvx",
      "args": ["mcp-server-time", "--local-timezone=America/New_York"]
    },
    "mcp_sse": {
      "type": "sse",
      "url": "http://127.0.0.1:8001/sse"
    },
    "mcp_streamable_http": {
      "type": "streamable_http",
      "url": "http://127.0.0.1:8002/mcp"
    }
  }
}
```

---

## 🐳 Run with Docker Compose

```yaml
services:
  mcpo:
    image: masterno12/webui-mcpo:latest
    container_name: webui-mcpo
    ports:
      - "8000:8000"
    volumes:
      - ./mcpo:/opt/mcpo
    restart: unless-stopped
```

Start the server:

```bash
docker-compose up -d
```

---

## 🔨 Build the Image from Dockerfile

Clone the repo:

```bash
git clone https://github.com/masterno12/webui-mcpo.git
cd webui-mcpo
```

Build the image locally:

```bash
docker build -t webui-mcpo:latest .
```

Then either run it directly:

```bash
docker run -d -p 8000:8000 -v "$PWD/mcpo:/opt/mcpo" webui-mcpo:latest
```

Or use the provided Docker Compose setup:

```bash
docker-compose up -d --build
```

---

## 🌐 Accessing Tools

Each tool is exposed under its **own subpath**, for example:

- `http://localhost:8000/memory`
- `http://localhost:8000/time`

Each path serves:
- An individual **OpenAPI schema** (`/docs`)
- A dedicated handler

Example:
- `http://localhost:8000/memory/docs`
- `http://localhost:8000/time/docs`

---

## ✅ Open WebUI Integration

To connect tools from this MCP server in [Open WebUI](https://docs.openwebui.com/openapi-servers/open-webui/), **you must use the full subpath** for each tool:

### ✅ Valid tool entries:
```
http://localhost:8000/memory
http://localhost:8000/time
```

### 🚫 Invalid:
```
http://localhost:8000
```

This ensures Open WebUI recognizes and communicates with each tool server correctly.

---

## 🛠 Notes

- If `/opt/mcpo/config.json` does not exist on container startup, a minimal default will be copied automatically.
- Container exposes port `8000`.
- Supports `npx`, `uvx`, and custom MCP tool types.

---

## 🔗 Related Links

- [MCPO GitHub](https://github.com/open-webui/mcpo)
- [Open WebUI: MCP Servers](https://docs.openwebui.com/openapi-servers/mcp)
- [Model Context Protocol Servers](https://github.com/modelcontextprotocol/servers)
