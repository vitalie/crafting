# Crafting

- [![Actions Status](https://github.com/vitalie/crafting/workflows/CI/badge.svg)](https://github.com/vitalie/cradting/actions)

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Run `mix test` to run unit tests.


### Example usage

Build the JSON request:

```bash
cat <<-EOT>/tmp/data.json
{"tasks": [
  {"name": "t1", "command": "touch /tmp/file1"},
  {"name": "t2", "command": "cat /tmp/file1", "requires": ["t3"]},
  {"name": "t3", "command": "echo 'Hello, world!' > /tmp/file1", "requires": ["t1"]},
  {"name": "t4", "command": "rm /tmp/file1", "requires": ["t2", "t3"]}
]}
EOT

```

### Call the web service

```
curl -X POST http://localhost:4000/api/tasks/schedule --json @/tmp/data.json | jq
```


### Example output

```json
{
  "tasks": [
    {
      "command": "touch /tmp/file1",
      "name": "t1"
    },
    {
      "command": "echo 'Hello, world!' > /tmp/file1",
      "name": "t3"
    },
    {
      "command": "cat /tmp/file1",
      "name": "t2"
    },
    {
      "command": "rm /tmp/file1",
      "name": "t4"
    }
  ]
}
```
