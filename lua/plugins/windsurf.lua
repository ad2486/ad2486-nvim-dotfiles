-- lua/plugins/windsurf.lua
-- Autocomplete com IA (ex-Codeium). Sugestão aparece como "ghost text" e
-- <Tab> aceita. Depois de instalar, rode :Codeium Auth uma vez pra logar.

return {
  "Exafunction/windsurf.vim",
  event = "BufEnter",
  config = function()
    -- Desliga os binds padrão pra controlar exatamente o que cada tecla faz
    -- (evita colidir com o <Tab> de outros plugins, tipo cmp)
    vim.g.codeium_disable_bindings = 1

    local map = vim.keymap.set
    map("i", "<Tab>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true, silent = true, desc = "Windsurf: aceitar sugestão" })

    map("i", "<C-;>", function()
      return vim.fn["codeium#CycleCompletions"](1)
    end, { expr = true, silent = true, desc = "Windsurf: próxima sugestão" })

    map("i", "<C-,>", function()
      return vim.fn["codeium#CycleCompletions"](-1)
    end, { expr = true, silent = true, desc = "Windsurf: sugestão anterior" })

    map("i", "<C-x>", function()
      return vim.fn["codeium#Clear"]()
    end, { expr = true, silent = true, desc = "Windsurf: descartar sugestão" })
  end,
}
