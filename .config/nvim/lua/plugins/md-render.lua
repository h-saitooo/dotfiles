return {
  "delphinus/md-render.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    -- 日本語を文節単位で折り返す
    "delphinus/budoux.lua",
  },
  cmd = "MdRender",
  keys = {
    { "<leader>mp", "<Plug>(md-render-preview)", ft = "markdown", desc = "Markdown preview (toggle)" },
    { "<leader>mt", "<Plug>(md-render-preview-tab)", ft = "markdown", desc = "Markdown preview in tab (toggle)" },
    { "<leader>ms", "<cmd>vert MdRender split<cr>", ft = "markdown", desc = "Markdown source/render split" },
    { "<leader>mr", "<Plug>(md-render-toggle)", ft = "markdown", desc = "Markdown render toggle (same window)" },
  },
}
