return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python", "leoluz/nvim-dap-go",
  },
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "Debug: iniciar/continuar" },
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: breakpoint" },
    { "<F10>", function() require("dap").step_over() end, desc = "Debug: próxima linha" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debug: entrar na função" },
    { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: sair da função" },
    { "<leader>vb", function() require("dap").toggle_breakpoint() end, desc = "Debug: breakpoint" },
    { "<leader>vc", function() require("dap").continue() end, desc = "Debug: iniciar/continuar" },
    { "<leader>vi", function() require("dap").step_into() end, desc = "Debug: entrar na função" },
    { "<leader>vo", function() require("dap").step_over() end, desc = "Debug: próxima linha" },
    { "<leader>vO", function() require("dap").step_out() end, desc = "Debug: sair da função" },
    { "<leader>vq", function() require("dap").terminate() end, desc = "Debug: encerrar" },
    { "<leader>vu", function() require("dapui").toggle() end, desc = "Debug: painel" },
    { "<leader>ve", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Debug: inspecionar expressão" },
  },
  config = function()
    local dap, ui = require("dap"), require("dapui")
    local mason = vim.fn.stdpath("data") .. "/mason"
    ui.setup()
    dap.listeners.after.event_initialized["ide-ui"] = function() ui.open() end
    dap.listeners.before.event_terminated["ide-ui"] = function() ui.close() end
    dap.listeners.before.event_exited["ide-ui"] = function() ui.close() end
    require("dap-python").setup(mason .. "/packages/debugpy/venv/bin/python")
    require("dap-go").setup({ delve = { path = mason .. "/bin/dlv" } })
    dap.adapters.codelldb = {
      type = "server", port = "${port}",
      options = { initialize_timeout_sec = 30 },
      executable = { command = mason .. "/bin/codelldb", args = { "--port", "${port}" } },
    }
    dap.configurations.rust = {{
      name = "Rust: executar binário (cargo build)", type = "codelldb", request = "launch",
      program = function()
        local root = vim.fs.root(0, "Cargo.toml") or vim.fn.getcwd()
        return vim.fn.input("Binário: ", root .. "/target/debug/", "file")
      end,
      cwd = "${workspaceFolder}", stopOnEntry = false,
    }}
    for _, kind in ipairs({ "pwa-node", "pwa-chrome" }) do
      dap.adapters[kind] = {
        type = "server", host = "127.0.0.1", port = "${port}",
        executable = { command = mason .. "/bin/js-debug-adapter", args = { "${port}", "127.0.0.1" } },
      }
    end
    for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
      dap.configurations[ft] = {
        { name = "Node: executar arquivo JS", type = "pwa-node", request = "launch", program = "${file}", cwd = "${workspaceFolder}", sourceMaps = true },
        { name = "Node/TS: conectar a processo --inspect", type = "pwa-node", request = "attach", processId = require("dap.utils").pick_process, cwd = "${workspaceFolder}", sourceMaps = true },
        { name = "Frontend: abrir Chrome", type = "pwa-chrome", request = "launch", webRoot = "${workspaceFolder}", sourceMaps = true,
          url = function() return vim.fn.input("URL do servidor de desenvolvimento: ", "http://localhost:3000") end },
      }
    end
    -- launch.json do projeto também pode usar os nomes node/chrome do VS Code.
    dap.adapters.node = dap.adapters["pwa-node"]
    dap.adapters.chrome = dap.adapters["pwa-chrome"]
  end,
}
