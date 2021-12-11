_G.MUtils = MUtils == nil and {} or MUtils

MUtils.highlight = {}

function MUtils.highlight.on_yank(args)
  if (vim.b.visual_multi == nil) then
    vim.highlight.on_yank(args)
  end
end
