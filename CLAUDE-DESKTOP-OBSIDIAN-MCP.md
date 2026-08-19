# Claude Desktop + Obsidian MCP

This setup lets a normal Claude Desktop chat search, read, and—when explicitly requested—modify an Obsidian vault. It does not require Claude Cowork.

## How it works

```text
Claude Desktop
    -> npx mcp-remote
    -> http://127.0.0.1:22360/mcp + Bearer token
    -> Obsidian MCP Connector
    -> Obsidian vault
```

Obsidian must be running and the MCP plugin must be enabled while Claude Desktop uses the vault.

> Claudian is a different workflow: it runs a Claude Code-style agent inside Obsidian. It is useful, but it is not the MCP server used by this Claude Desktop setup.

## 1. Install and enable MCP Connector

In Obsidian:

1. Open **Settings -> Community plugins**.
2. Install **MCP Connector** (`mcp-tools-istefox`). This setup was verified with version `2.1.1`.
3. Enable the plugin.
4. Keep the default port `22360`, unless the Claude configuration below is changed to match.
5. Run the plugin's Node verification. It should report that `node` and `npx` are available.
6. Use **Copy Claude Desktop config** in the plugin settings to obtain the current endpoint and Bearer token.

Review the plugin's permissions before enabling write-capable tools. The connected Claude client may be able to edit notes, not only read them.

## 2. Make Node.js visible to macOS GUI apps

Node installed through `nvm` works in a shell that loads `nvm`, but macOS apps launched from Finder or the Dock often do not inherit that shell environment. In this setup, Terminal found Node here:

```text
~/.nvm/versions/node/v20.5.0/bin/node
```

Obsidian could not see it. The stable fix is to install a system-level Homebrew Node as well:

```sh
brew install node
```

This does not stop Terminal from continuing to use the `nvm` version. Confirm both installations are visible:

```sh
which -a node
which -a npx
node -v
npm -v
npx -v
```

On an Apple Silicon Mac, the Homebrew executables are normally under `/opt/homebrew/bin`. On an Intel Mac, they are normally under `/usr/local/bin`.

After installation, fully quit Obsidian with `Cmd + Q`, reopen it, and select **Verify again** in the plugin settings.

## 3. Configure Claude Desktop

Claude Desktop reads its MCP configuration from:

```text
~/Library/Application Support/Claude/claude_desktop_config.json
```

Open Claude Desktop's developer settings to edit this file, or edit it directly. If the file has no other MCP servers, use:

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "/opt/homebrew/bin/npx",
      "args": [
        "-y",
        "mcp-remote",
        "http://127.0.0.1:22360/mcp",
        "--header",
        "Authorization: Bearer YOUR_TOKEN_HERE"
      ],
      "env": {
        "PATH": "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
      }
    }
  }
}
```

Replace `YOUR_TOKEN_HERE` with the token from **MCP Connector -> Copy Claude Desktop config**. Never commit the real token to Git or paste it into chat.

If `mcpServers` already contains other entries, add only the `obsidian` entry; do not replace the existing entries. The file must remain valid JSON.

MCP Connector 2.1.1 uses Streamable HTTP at `/mcp`. The older `/sse` endpoint returns `404` and should not be used with this version.

The command above is for Apple Silicon Macs. On an Intel Mac, change `/opt/homebrew/bin/npx` to `/usr/local/bin/npx`.

Fully quit Claude Desktop with `Cmd + Q`, then reopen it so it reloads the configuration.

## 4. Test the connection

Keep Obsidian open, then try these prompts in a normal Claude Desktop chat:

```text
What files are in my Obsidian vault?
```

```text
Search my Obsidian vault for notes about manifold capacity.
```

For a cautious paper-reading workflow, start with:

```text
I'm reading this paper. Use my Obsidian vault as additional context and
search existing notes when relevant. Do not modify any notes unless I
explicitly ask you to.
```

## Troubleshooting

### Obsidian says it cannot find Node on PATH

If `which node` points only into `~/.nvm/`, Obsidian is probably missing the shell-managed path. Install Homebrew Node, fully restart Obsidian, and verify again.

Do not hard-code an `nvm` version directory into the GUI app configuration unless necessary. That path changes when the active Node version changes.

### Claude cannot connect to the MCP server

Check that:

- Obsidian is running.
- The MCP plugin is enabled and has passed its Node verification.
- The plugin is listening on port `22360`.
- The URL in Claude's config is `http://127.0.0.1:22360/mcp`.
- The `Authorization: Bearer ...` header contains the current token copied from MCP Connector.
- `claude_desktop_config.json` is valid JSON.
- Claude Desktop was fully restarted after the config changed.

### Claude reports `404` when connecting

The client is probably using the obsolete `/sse` endpoint. Change it to `/mcp` and include the Bearer token header copied from MCP Connector.

### Claude reports `401` or `403`

Copy a fresh Claude Desktop configuration from MCP Connector and update the Bearer token. The token may have been rotated or copied incorrectly.

### `npx` asks to install `mcp-remote`

This can happen the first time it runs. Approve the package only after confirming that the package name and source match the MCP plugin's current documentation.

### Terminal works, but Claude Desktop still cannot find `npx`

Use the Homebrew executable explicitly in the Claude configuration:

```json
"command": "/opt/homebrew/bin/npx"
```

For an Intel Mac, use `/usr/local/bin/npx` instead. Confirm the exact path with:

```sh
brew --prefix
which -a npx
```

## Security notes

- Bind the MCP server to localhost only; do not expose port `22360` to the network.
- Treat the Bearer token as a secret. Rotate it in MCP Connector if it is exposed.
- Treat the vault as writable if the plugin exposes write tools.
- Ask Claude to show or describe proposed changes before writing important notes.
- Keep the vault backed up or under version control.
