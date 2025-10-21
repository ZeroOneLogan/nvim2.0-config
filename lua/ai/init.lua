local M = {}

function M.status()
  if not require("user.prefs").values.ai then
    return "AI assistants disabled"
  end
  if not vim.env.OPENAI_API_KEY then
    return "Set OPENAI_API_KEY to enable AI completion"
  end
  return "AI backend ready"
end

return M
